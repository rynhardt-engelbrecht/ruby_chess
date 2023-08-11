# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/slideable'

# contains logic for the Bishop chess piece
class Bishop < Piece
  def initialize(board, location, color, moved: false)
    super
    @symbol = "\u265D "
  end

  include Slideable

  def generate_moves(board, rank, file)
    traverse_move_array(board, 0, 0, diagonal_movement(board, rank, file))
  end

  # rubocop:disable Metrics/MethodLength
  # we disable this rubocop cop here because this method is over 10 lines, but is
  # only so because I am returning a 2D array, and the method isn't complex enough to
  # warrant splitting it into several different methods.
  def score_map
    map = [
      [-1, 0, -1, -2, -2, -1, 0, -1],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [1, 2, 2, 3, 3, 2, 2, 1],
      [2, 2, 3, 4, 4, 3, 2, 2],
      [3, 3, 4, 4, 4, 4, 3, 3],
      [1, 2, 2, 3, 3, 2, 2, 1],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]

    color == :white ? map.reverse : map
  end
  # rubocop:enable Metrics/MethodLength

  def value
    3
  end
end
