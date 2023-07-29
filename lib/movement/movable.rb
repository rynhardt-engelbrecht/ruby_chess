# frozen_string_literal: true

# handles sliding pieces' movement
module Movable
  def horizontal_movement(board, rank, file)
    backwards_horizontal.concat(forwards_horizontal)
  end

  def vertical_movement(board, rank, file)
    downwards_vertical.concat(upwards_vertical)
  end

  def diagonal_movement(board, rank, file)
    downwards_diagonal.concat(upwards_diagonal)
  end

  private

  def backwards_horizontal(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      new_rank -= 1
      new_file -= 1
      break unless valid_move?(board, new_rank, new_file)

      moves << [new_rank, new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end

  def forwards_horizontal(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      new_rank += 1
      new_file += 1
      break unless valid_move?(board, new_rank, new_file)

      moves << [new_rank, new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end

  def downwards_vertical(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      new_rank += 1
      new_file += 1
      break unless valid_move?(board, new_rank, new_file)

      moves << [new_rank, new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end

  def upwards_vertical(board, rank, file)
    moves = []
    new_rank = rank
    new_file = file

    loop do
      new_rank -= 1
      new_file -= 1
      break unless valid_move?(board, new_rank, new_file)

      moves << [new_rank, new_file]

      break if board.data[new_rank][new_file]&.color != color
      # when path is blocked off by an enemy piece
    end
  end
end
