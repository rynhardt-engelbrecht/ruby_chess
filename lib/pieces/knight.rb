# frozen_string_literal: true

require_relative 'piece'

# contains logic for the Knight chess piece
class Knight < Piece
  def initialize(board, location, color, moved: false)
    super
    @symbol = "\u265E "
  end

  def generate_moves(board, rank, file)
    traverse_move_array(board, rank, file, moveset)
  end

  def score_map
    [
      [-2, -1, 0, 0, 0, 0, -1, -2],
      [-1, 0, 0, 0, 0, 0, 0, -1],
      [0, 0, 0, 3, 3, 0, 0, 0],
      [0, 2, 3, 4, 4, 3, 2, 0],
      [0, 2, 3, 4, 4, 3, 2, 0],
      [0, 0, 0, 3, 3, 0, 0, 0],
      [-1, 0, 0, 0, 0, 0, 0, -1],
      [-2, -1, 0, 0, 0, 0, -1, -2]
    ]
  end

  private

  def moveset
    [
      [-2, -1],
      [-2, 1],
      [-1, -2],
      [-1, 2],
      [1, -2],
      [1, 2],
      [2, -1],
      [2, 1]
    ]
  end
end
