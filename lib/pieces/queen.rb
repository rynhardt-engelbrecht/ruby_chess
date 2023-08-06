# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/slideable'

# contains logic for the Queen < Piece chess piece
class Queen < Piece
  def initialize(board, location, color)
    super
    @symbol = "\u265B "
  end

  include Slideable

  def generate_moves(board, rank, file)
    move_array = horizontal_movement(board, rank, file).concat(
      vertical_movement(board, rank, file),
      diagonal_movement(board, rank, file)
    )

    traverse_move_array(board, 0, 0, move_array)
  end
end
