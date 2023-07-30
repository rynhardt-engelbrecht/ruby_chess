# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Bishop chess piece
class Bishop < Piece
  include Movable

  def generate_moves(board, rank, file)
    traverse_move_array(board, 0, 0, diagonal_movement(board, rank, file))
  end
end
