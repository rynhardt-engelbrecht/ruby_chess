# frozen_string_literal: true

# handles sliding pieces' movement
module Movable
  def horizontal_movement(board, rank, file)
    backwards_horizontal.concat(forwards_horizontal)
  end

  private

  def backwards_horizontal(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      break unless valid_move?(board, new_rank, new_file)

      new_rank -= 1
      new_file -= 1

      moves << [new_rank, new_file] if board.data[new_rank][new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end

  def forwards_horizontal(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      break unless valid_move?(board, new_rank, new_file)

      new_rank += 1
      new_file += 1

      moves << [new_rank, new_file] if board.data[new_rank][new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end
end
