# frozen_string_literal: true

require_relative 'piece'

# contains logic for the Knight chess piece
class Knight < Piece
  def generate_moves(board, rank, file)
    moves = []

    moveset.each do |move|
      new_rank = rank + move[0]
      new_file = file + move[1]

      moves << [new_rank, new_file] if valid_move?(board, new_rank, new_file)
    end

    moves
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
