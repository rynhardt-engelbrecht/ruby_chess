# frozen_string_literal: true

# contains logic for the computer player
class Computer
  attr_reader :color, :pieces

  def initialize(board, _game, color)
    board.add_observer(self)

    @board = board
    @color = color
    @pieces = @board.find_pieces(@color)
  end

  def turn(piece = nil)
    sleep(0.25)
    piece = choose_random_piece until own_movable_piece?(piece)

    move = choose_random_move(piece)
    make_move(piece, move)
  end

  def update(board)
    @pieces = board.find_pieces(@color)
  end

  private

  def own_movable_piece?(piece)
    piece&.color == color && !piece.safe_moves(@board).empty?
    # we check that the piece the user is trying to move, is their own piece, but also that the piece
    # can actually move from it's current position.
  end

  def make_move(piece, move)
    @board.move_piece(piece.location, move)
  end

  def choose_random_piece
    @pieces.sample
  end

  def choose_random_move(piece)
    piece.safe_moves(@board).sample
  end
end
