# frozen_string_literal: true

require_relative '../text/text_output'
require_relative 'input_handler'
# contains the logic to handle player input
class Player
  attr_reader :color, :pieces

  include TextOutput
  include InputHandler

  def initialize(board, game, color)
    board.add_observer(self)

    @board = board
    @game = game
    @color = color
    @pieces = []
  end

  def turn(piece = nil, move = nil)
    @board.active_piece = nil
    # should input the piece to move
    piece = choose_piece until own_movable_piece?(piece)
    @board.active_piece = piece
    # verify that there's actually an ally piece there
    # then input the square to move the chosen piece to
    # verify that the given input is a valid move
    # by checking @valid_moves and @valid_captures of the piece
    # finally call the Board#move_piece method
    move = choose_move(piece) until valid_move?(piece, move)
    make_move(piece, move)
    @board.active_piece = nil
  rescue InputBackError
    'try again'
  end

  def update(board)
    @pieces = find_pieces(board.data)
  end

  private

  def choose_piece
    puts game_message('check') if @board.in_check?(@board.active_color)
    @board.print_board(@board.active_color)
    print "#{turn_message('square')} "
    piece = piece_from_input
    @board.print_board(@board.active_color)
    puts error_message('unmovable piece') unless own_movable_piece?(piece)

    piece
  rescue InputSaveError
    choose_piece
  end

  def piece_from_input
    piece_location = coordinates_input
    piece = @board.data[piece_location[0]][piece_location[1]]
    @board.active_piece = piece if own_movable_piece?(piece)

    piece
  end

  def own_movable_piece?(piece)
    piece&.color == color && !piece.safe_moves(@board).empty?
    # we check that the piece the user is trying to move, is their own piece, but also that the piece
    # can actually move from it's current position.
  end

  def choose_move(piece)
    print "#{turn_message('move')} "
    move = coordinates_input
    @board.print_board(@board.active_color)
    puts error_message('invalid move') unless valid_move?(piece, move)

    move
  rescue InputSaveError
    choose_move(piece)
  end

  def valid_move?(piece, move)
    piece.safe_moves(@board).include?(move)
    # checks that the given move exists within the piece's valid_moves and valid_captures instance variables.
    # Which are used to store what moves the specified piece can make. So if the given move does not exist in either
    # array, the user has entered an invalid move. And they are an idiot (I am only half-joking).
  end

  def make_move(piece, move)
    @board.move_piece(piece.location, move)
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
