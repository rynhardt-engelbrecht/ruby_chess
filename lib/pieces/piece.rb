# frozen_string_literal: true

require_relative '../board'

# abstract class containing shared logic between chess pieces
class Piece
  attr_accessor :location, :moved
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
    @valid_moves = []
    @valid_captures = []
    legal_moves(board.data, @location[0], @location[1])
  end

  def legal_moves(board, rank, file)
    generate_moves(board, rank, file)
  rescue RuntimeError => e
    puts "Error occured: #{e.message}"
  end

  private

  def traverse_move_array(board, rank_increment, file_increment, array)
    array.each do |move|
      new_rank = move[0] + rank_increment
      new_file = move[1] + file_increment

      add_move(board, [new_rank, new_file]) if valid_move?(board, new_rank, new_file)
    end
    # traverses an array of possible moves generated by each piece's respective generate_moves method
    # and using the add_move method to sort between moves and captures.
  end

  def add_move(board, move)
    rank = move[0]
    file = move[1]

    if opponent_piece?(board, rank, file)
      @valid_captures << move
    else
      @valid_moves << move
    end
    # sorts between moves and captures
  end

  def generate_moves(_board, _rank, _file)
    raise RuntimeError.new, 'Abstract method called'
    # this method should never get called
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
