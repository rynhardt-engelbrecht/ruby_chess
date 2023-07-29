# frozen_string_literal: true

require 'observer'

# contains logic for a chess board, mainly to keep track of the state of the game and all pieces present in the game.
class Board
  include Observable

  INITIAL_POSITIONS = [
    { piece: Rook, file: 0 },
    { piece: Knight, file: 1 },
    { piece: Bishop, file: 2 },
    { piece: Queen, file: 3 },
    { piece: King, file: 4 },
    { piece: Bishop, file: 5 },
    { piece: Knight, file: 6 },
    { piece: Rook, file: 7 }
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

  # we'll handle movement using a separate class, by removing the active piece
  # from it's original location and placing it at the new location, and then notifying
  # all pieces of the changes so that all pieces update their @valid_moves and @valid_captures values.
  # psuedo code:
  # def move_piece(piece, origin, destination)
  #   data[origin[0]][origin[1]] = nil
  #   data[destination[0]][destination[1]] = piece
  #   changed & notify(self)

  def piece_setup
    initial_white_placement
    initial_black_placement
  end

  private

  def initial_white_placement
    data[-1].each_index do |index|
      data[-1][index] = INITIAL_POSITIONS[index][:piece].new(self, [7, index], :white)
    end

    data[-2].each_index do |index|
      data[-2][index] = Pawn.new(self, [6, index], :white)
    end
  end

  def initial_black_placement
    data[0].each_index do |index|
      data[0][index] = INITIAL_POSITIONS[index][:piece].new(self, [7, index], :black)
    end

    data[1].each_index do |index|
      data[1][index] = Pawn.new(self, [6, index], :black)
    end
  end
end
