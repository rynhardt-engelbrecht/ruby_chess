# frozen_string_literal: true

require_relative '../board'

# abstract class containing shared logic between chess pieces
class Piece
  def initialize(board, location, color)
    board.add_observer(self)

    @location = location
    @color = color
    @moved = false
    @valid_moves = []
    @valid_captures = []
  end

  def update(board)
    legal_moves(board)
  end

  def legal_moves(board)
    generate_moves(board)
  end

  private

  def valid_move?(board, rank, file)
    on_board?(board, rank, file) && not_ally_piece?(board, rank, file)
    # this method checks whether a given move is within the bounds of the board, and that there isn't an ally piece
    # present on the board.
  end

  def on_board?(board, rank, file)
    [rank, file].all? { |pos| pos.between?(0, board.data.size - 1) }
  end

  def not_ally_piece?(board, rank, file)
    board.data[rank][file]&.color != color
  end
end
