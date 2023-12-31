# frozen_string_literal: true

# handles sliding pieces' movement
module Slideable
  def horizontal_movement(board, rank, file)
    moves_in_direction(board, rank, file, 0, -1).concat(moves_in_direction(board, rank, file, 0, 1))
  end

  def vertical_movement(board, rank, file)
    moves_in_direction(board, rank, file, -1, 0).concat(moves_in_direction(board, rank, file, 1, 0))
  end

  def diagonal_movement(board, rank, file)
    moves_in_direction(board, rank, file, -1, -1).concat(
      moves_in_direction(board, rank, file, -1, 1),
      moves_in_direction(board, rank, file, 1, -1),
      moves_in_direction(board, rank, file, 1, 1)
    )
  end

  private

  def moves_in_direction(board, rank, file, rank_direction, file_direction)
    moves = []

    loop do
      rank += rank_direction
      file += file_direction
      break unless valid_move?(board, rank, file)

      moves << [rank, file]

      break if opponent_piece?(board, rank, file)
      # when path is blocked off by an enemy piece, add enemy piece to the move list, then break the loop
    end

    moves
  end
end
