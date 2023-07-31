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

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  def move_piece(piece, new_location)
    temp_piece = piece # create a copy of the piece so we can remove the original piece from it's original location
    remove_old_piece(piece)
    data[new_location[0]][new_location[1]] = temp_piece # insert the copied piece at the specified location
    temp_piece.moved = true
    update_location(temp_piece, new_location)

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  private

  def initial_white_placement
    data[7].each_index do |index|
      piece_type = Object.const_get(INITIAL_POSITIONS[index][:piece])
      place_piece(piece_type, 7, index, :white)
    end

    data[6].each_index do |index|
      data[6][index] = Pawn.new(self, [6, index], :white)
    end
  end

  def initial_black_placement
    data[0].each_index do |index|
      piece_type = Object.const_get(INITIAL_POSITIONS[index][:piece])
      place_piece(piece_type, 0, index, :black)
    end

    data[1].each_index do |index|
      data[1][index] = Pawn.new(self, [1, index], :black)
    end
  end

  def place_piece(type, rank, file, color)
    data[rank][file] = type.new(self, [rank, file], color)
  end

  # just to combine the changed and notify_observers methods into one method, this slims down code
  # and makes it more readable
  def changed_and_notify
    changed
    notify_observers(self)
  end

  def update_location(piece, new_location)
    piece.location = [new_location[0], new_location[1]]
  end

  def remove_old_piece(piece)
    rank = piece.location[0]
    file = piece.location[1]

    data[rank][file] = nil
  end
end
