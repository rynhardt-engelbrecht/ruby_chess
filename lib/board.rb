# frozen_string_literal: true

require 'observer'
require_relative 'displayable'
require_relative 'movement/moveable'

# contains logic for a chess board, mainly to keep track of the state of the game and all pieces present in the game.
class Board
  include Observable
  include Displayable
  include Moveable

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

  attr_accessor :data, :active_color, :halfmove_clock, :active_piece, :previous_piece
  attr_reader :last_move, :white_king, :black_king

  def initialize(
    data = Array.new(8) { Array.new(8) },
    params = { active_color: :white, en_passant_square: nil, halfmove_clock: 0 }
  )
    @data = data # board represented using a 2-Dimensional array.
    @active_color = params[:active_color]
    @active_piece = params[:active_piece]
    @last_move = nil
  end

  def piece_setup
    initial_white_placement
    initial_black_placement

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  def in_check?(color)
    king = find_king(color)

    opponent_color = color == :white ? :black : :white
    opponent_pieces = find_pieces(opponent_color)

    opponent_pieces.any? { |piece| piece.valid_moves.include?(king.location) }
  end

  def checkmate?(color)
    pieces = find_pieces(color)

    pieces.all? { |p| p.safe_moves(self).empty? }
  end

  def find_king(color)
    data.flatten.compact.find { |piece| piece.instance_of?(King) && piece.color == color }
  end

  def find_pieces(color)
    data.flatten.compact.select { |piece| piece.color == color }
  end

  def score(color)
    calculate_score(color)
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

  def calculate_score(color)
    pieces = find_pieces(color)

    calculate_piece_difference(pieces, color) + calculate_piece_score(pieces)
  end

  def calculate_piece_difference(pieces, color)
    opponent_color = color == :white ? :black : :white
    opponent_pieces = find_pieces(opponent_color)
    (pieces.size - opponent_pieces.size) * 1.5
  end

  def calculate_piece_score(pieces)
    scores = pieces.map { |p| p.score_map[p.location[0]][p.location[1]] + p.value }

    scores.sum
  end
end
