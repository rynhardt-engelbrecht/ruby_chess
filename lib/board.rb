# frozen_string_literal: true

require 'observer'

# contains logic for a chess board, mainly to keep track of the state of the game and all pieces present in the game.
class Board
  include Observable

  INITIAL_POSITIONS = [
    { piece: :Rook, file: 0 },
    { piece: :Knight, file: 1 },
    { piece: :Bishop, file: 2 },
    { piece: :Queen, file: 3 },
    { piece: :King, file: 4 },
    { piece: :Bishop, file: 5 },
    { piece: :Knight, file: 6 },
    { piece: :Rook, file: 7 }
  ].freeze

  attr_accessor :data, :active_color
  attr_reader :en_passant_target, :castling_avail, :halfmove_clock

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data # board represented using a 2-Dimensional array.
    @active_color = params[:active_color]
    @en_passant_target = params[:en_passant_target]
    @castling_avail = params[:castling_avail]
    @halfmove_clock = params[:halfmove_clock]
  end

  def piece_setup
    initial_white_placement
    initial_black_placement

    notify # notifies pieces to update valid_moves and valid_captures
  end

  def move_piece(piece, new_location)
    current_rank = piece.location[0]
    current_file = piece.location[1]

    data[new_location[0]][new_location[1]] = data[current_rank][current_file]
    data[current_rank][current_file] = nil

    notify # notifies pieces to update valid_moves and valid_captures
  end

  private

  def initial_white_placement
    data[-1].each_index do |index|
      piece_type = Object.const_get(INITIAL_POSITIONS[index][:piece])
      place_piece(piece_type, -1, index, :white)
    end

    data[-2].each_index do |index|
      data[-2][index] = Pawn.new(self, [6, index], :white)
    end
  end

  def initial_black_placement
    data[0].each_index do |index|
      piece_type = Object.const_get(INITIAL_POSITIONS[index][:piece])
      place_piece(piece_type, 0, index, :black)
    end

    data[1].each_index do |index|
      data[1][index] = Pawn.new(self, [6, index], :black)
    end
  end

  def place_piece(type, rank, file, color)
    data[rank][file] = type.new(self, [rank, file], color)
  end

  # just to combine the changed and notify_observers into one method, this slims down code
  # and makes it more readable
  def notify
    changed
    notify_observers(self)
  end
end
