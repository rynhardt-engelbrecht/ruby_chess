# frozen_string_literal: true

require_relative '../board'

# abstract class containing shared logic between chess pieces
class Piece
  attr_accessor :location
  attr_reader :color

  def initialize(board, location, color)
    board.add_observer(self)

    @location = location
    @color = color
    @moved = false
    @valid_moves = []
    @valid_captures = []
  end

  def update(board)
    legal_moves(board.data, @location[0], @location[1])
  end

  def legal_moves(board, rank, file)
    generate_moves(board, rank, file)
  rescue RuntimeError => e
    puts "Error occured: #{e.message}"
  end

  private

  def add_move(board, move)
    rank = move[0]
    file = move[1]

    if opponent_piece?(board, rank, file)
      @valid_captures << move
    else
      @valid_moves << move
    end
  end

  def generate_moves(_board, _rank, _file)
    raise RuntimeError.new, 'Abstract method called'
  end

  def valid_move?(board, rank, file)
    on_board?(board, rank, file) && !ally_piece?(board, rank, file)
    # this method checks whether a given move is within the bounds of the board, and that there isn't an ally piece
    # present on that square on the board.
  end

  def on_board?(board, rank, file)
    [rank, file].all? { |pos| pos.between?(0, board.size - 1) }
  end

  def ally_piece?(board, rank, file)
    !board[rank][file].nil? && board[rank][file].color == color
  end

  def opponent_piece?(board, rank, file)
    !board[rank][file].nil? && board[rank][file].color != color
  end
end
