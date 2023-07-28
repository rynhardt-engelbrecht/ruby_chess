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

  def update; end
end
