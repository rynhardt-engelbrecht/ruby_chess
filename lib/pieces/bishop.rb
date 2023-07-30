# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Bishop chess piece
class Bishop < Piece
  include Movable

  def generate_moves(board, rank, file)
    diagonal_movement(board, rank, file).each do |move|
      new_rank = move[0]
      new_file = move[1]

      add_move(board, [new_rank, new_file]) if valid_move?(board, new_rank, new_file)
    end
  end
end
