# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Queen < Piece chess piece
class Queen < Piece
  include Movable

  def generate_moves(board, rank, file)
    move_array = horizontal_movement(board, rank, file).concat(
      vertical_movement(board, rank, file),
      diagonal_movement(board, rank, file)
    )

    move_array.each do |move|
      new_rank = move[0]
      new_file = move[1]

      add_move(board, [new_rank, new_file]) if valid_move?(board, new_rank, new_file)
    end
  end
end
