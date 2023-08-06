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
