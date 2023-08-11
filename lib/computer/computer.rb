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

  def turn
    # piece = choose_random_piece until own_movable_piece?(piece)

    # move = choose_random_move(piece)
    # make_move(piece, move)
    best_move = determine_best_move(@board)
    piece = best_move[:piece]
    move = best_move[:move]
    make_move(piece, move)
  end

  def update(board)
    @pieces = board.find_pieces(@color)
  end

  private

  def find_valid_moves(board)
    pieces = board.find_pieces(@color)
    pieces.map { |p| { piece: p, moves: p.safe_moves(board) } }
  end

  def find_highest_scoring_moves(board)
    find_valid_moves(board).map do |move|
      piece = move[:piece]
      piece_moves = move[:moves]
      {
        piece: piece,
        move: piece_moves.shuffle.max { |a, b| test_move(board, piece.location, a) <=> test_move(board, piece.location, b) }
      }
    end
  end

  def make_move(piece, move)
    @board.move_piece(piece.location, move)
  end

  def determine_best_move(board)
    moves = find_highest_scoring_moves(board)

    moves.reject! { |move| move[:move].nil? }
    moves.max(3) do |a, b|
      a_score = test_move(board, a[:piece].location, a[:move])
      b_score = test_move(board, b[:piece].location, b[:move])

      a_score <=> b_score
    end.sample
  end

  def test_move(board, original_location, move)
    board_temp = Marshal.load(Marshal.dump(board))

    board_temp.move_piece(original_location, move)
    determine_move_score(board_temp)
  end

  def determine_move_score(board)
    opponent_color = @color == :white ? :black : :white
    board.score(@color) - board.score(opponent_color)
  end
end
