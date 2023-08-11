# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/slideable'

# contains logic for the Rook < Piece chess piece
class Rook < Piece
  def initialize(board, location, color, moved: false)
    super
    @symbol = "\u265C "
  end

  include Slideable

  def generate_moves(board, rank, file)
    move_array = horizontal_movement(board, rank, file).concat(vertical_movement(board, rank, file))

    traverse_move_array(board, 0, 0, move_array)
  end

  # rubocop:disable Metrics/MethodLength
  def score_map
    map = [
      [3, 0, 0, 0, 0, 0, 0, 3],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [1, 2, 2, 3, 3, 2, 2, 1],
      [1, 2, 3, 3, 3, 3, 2, 1],
      [2, 3, 3, 3, 3, 3, 3, 2],
      [1, 2, 3, 3, 3, 3, 2, 1],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [-1, 0, 0, 0, 0, 0, 0, -1]
    ]

    color == :white ? map.reverse : map
  end
  # rubocop:enable Metrics/MethodLength

  def value
    2
  end
end
