# frozen_string_literal: true

require_relative 'piece'

# contains logic for the Pawn < Piece chess piece
class Pawn < Piece
  def initialize(board, location, color)
    super
    @direction = @color == :white ? -1 : 1
    @symbol = "\u265F"
  end

  def generate_moves(board, rank, file)
    moveset.each do |move|
      new_rank = rank + move[0]
      new_file = file + move[1]

      break unless board[new_rank][new_file].nil?

      @valid_moves << [new_rank, new_file] if valid_move?(board, new_rank, new_file)
    end

    check_captures(board, rank, file)
  end

  private

  def check_captures(board, rank, file)
    # checking if there is an opponent piece diagonally across from the pawn
    capture_moves.each do |move|
      capture_rank = rank + move[0]
      capture_file = file + move[1]

      @valid_captures << [capture_rank, capture_file] if opponent_piece?(board, capture_rank, capture_file)
    end
  end

  def moveset
    return [[@direction, 0], [@direction * 2, 0]] unless @moved

    [[@direction, 0]] if @moved
  end

  def capture_moves
    [[@direction, 1], [@direction, -1]]
  end
end
