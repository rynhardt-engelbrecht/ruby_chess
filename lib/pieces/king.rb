# frozen_string_literal: true

require_relative 'piece'

# contains logic for the King chess piece
class King < Piece
  def initialize(board, location, color)
    super
    @symbol = " \u265A "
  end

  def generate_moves(board, rank, file)
    traverse_move_array(board, rank, file, moveset)
  end

  private

  def moveset
    [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]
  end
end
