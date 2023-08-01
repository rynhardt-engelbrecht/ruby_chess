# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Rook < Piece chess piece
class Rook < Piece
  def initialize(board, location, color)
    super
    @symbol = "\u265C "
  end

  include Movable

  def generate_moves(board, rank, file)
    move_array = horizontal_movement(board, rank, file).concat(vertical_movement(board, rank, file))

    traverse_move_array(board, 0, 0, move_array)
  end
end
