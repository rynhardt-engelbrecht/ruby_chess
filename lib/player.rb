# frozen_string_literal: true

require_relative 'text/text_output'

# contains the logic to handle player input
class Player
  attr_reader :color, :pieces

  include TextOutput

  def initialize(board, color)
    board.add_observer(self)

    @board = board
    @color = color
    @pieces = []
  end

  def turn
    puts turn_message('which color', color)
    # should input the piece to move
    piece_to_move = choose_piece
    # verify that there's actually an ally piece there
    # then input the square to move the chosen piece to
    # verify that the given input is a valid move
    # by checking @valid_moves and @valid_captures of the piece
    # finally call the Board#move_piece method
    make_move(piece_to_move, choose_move(piece_to_move))
  end

  def update(board)
    @pieces = find_pieces(board.data)
  end

  private

  def coordinates_input(input = gets.chomp.downcase)
    coordinates_input unless input.match?(/^[a-h][1-8]$/) # check for correct format and correct range

    rank_letter_index = input[1]
    rank_integer_index = rank_letter_index.ord - 97
    file_index = input[0].to_i - 1

    [rank_integer_index, file_index]
  end

  def choose_piece
    print turn_message('square') + ' '
    piece_location = coordinates_input
    piece = @board.data[piece_location[0]][piece_location[1]]

    choose_piece unless own_movable_piece?(piece)

    piece
  end

  def own_movable_piece?(piece)
    piece&.color == color && !piece.valid_moves.concat(piece.valid_captures).empty?
    # we check that the piece the user is trying to move, is their own piece, but also that the piece
    # can actually move from it's current position.
  end

  def choose_move(piece)
    print turn_message('move') + ' '
    move = coordinates_input

    choose_move(piece) unless valid_move?(piece, move)

    move
  end

  def valid_move?(piece, move)
    piece.valid_moves.include?(move) || piece.valid_captures.include?(move)
    # checks that the given move exists within the piece's valid_moves and valid_captures instance variables.
    # Which are used to store what moves the specified piece can make. So if the given move does not exist in either
    # array, the user has entered an invalid move. And they are an idiot (I am only half-joking).
  end

  def make_move(piece, move)
    @board.move_piece(piece, move)
  end

  def find_pieces(board)
    pieces = []

    board.each_with_index do |rank, rank_index|
      rank.each_index do |file_index|
        square = board[rank_index][file_index]
        pieces << board[rank_index][file_index] if square&.color == color
      end
    end

    pieces
  end
end
