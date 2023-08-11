# frozen_string_literal: true

require 'pry-byebug'
require_relative 'piece'

# contains logic for the King chess piece
class King < Piece
  def initialize(board, location, color, moved: false)
    super
    @symbol = "\u265A "
  end

  def generate_moves(board, rank, file)
    traverse_move_array(board, rank, file, moveset)
    @valid_moves += castling_moves(board)
  end

  def king_side_castling?(board)
    king_side_pass = 5
    empty_files = [6]
    king_side_rook = 7
    unmoved_king_rook?(board, king_side_rook) &&
      empty_files?(board, empty_files) &&
      !board.in_check?(@color) &&
      king_pass_through_safe?(board, king_side_pass)
  end

  def queen_side_castling?(board)
    queen_side_pass = 3
    empty_files = [1, 2]
    queen_side_rook = 0
    unmoved_king_rook?(board, queen_side_rook) &&
      empty_files?(board, empty_files) &&
      !board.in_check?(@color) &&
      king_pass_through_safe?(board, queen_side_pass)
  end

  # rubocop:disable Metrics/MethodLength
  def score_map
    map = [
      [1, 4, 3, 2, 2, 3, 4, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [-1, 0, 0, 0, 0, 0, 0, -1],
      [-2, -1, 0, 0, 0, 0, -1, -2]
    ]

    color == :white ? map.reverse : map
  end
  # rubocop:enable Metrics/MethodLength

  def value
    0
  end

  private

  def moveset
    [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1]
    ]
  end

  def castling_moves(board)
    castling_moves = []
    castling_moves << [location[0], 6] if king_side_castling?(board)
    castling_moves << [location[0], 2] if queen_side_castling?(board)
    castling_moves
  end

  def unmoved_king_rook?(board, file)
    rank = location[0]

    piece = board.data[rank][file]
    return false unless piece

    moved == false && piece.instance_of?(Rook) && !piece.moved
  end

  def king_pass_through_safe?(board, file)
    rank = location[0]
    board.data[rank][file].nil? && safe_passage?(board, [rank, file])
  end

  def safe_passage?(board, location)
    opponent_pieces = board.find_pieces(@color == :white ? :black : :white)
    opponent_pieces.none? do |piece|
      piece.valid_moves.include?(location)
    end
  end

  def empty_files?(board, files)
    rank = location[0]
    files.none? { |file| board.data[rank][file] }
  end
end
