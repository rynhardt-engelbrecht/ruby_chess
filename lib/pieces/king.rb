# frozen_string_literal: true

require 'pry-byebug'
require_relative 'piece'

# contains logic for the King chess piece
class King < Piece
  def initialize(board, location, color)
    super
    @symbol = "\u265A "
  end

  def generate_moves(board, rank, file)
    moveset.concat([[0, -2], [0, 2]]) if castling_eligible?(board)

    traverse_move_array(board, rank, file, moveset)
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

  def castling_eligible?(board)
    return false if moved

    rooks = find_rooks(board.data, location[0])
    eligible_rooks = unmoved_rooks(rooks).select do |rook|
      validate_castling_side(board, rook)
    end

    !eligible_rooks.empty? && safe_path?(board, location[0])
  end

  def validate_castling_side(board, rook)
    empty_path?(board.data[location[0]][[rook.location[1], location[1]].min + 1...[rook.location[1], location[1]].max])
  end

  def find_rooks(data, rank)
    data[rank].select { |piece| piece.instance_of?(Rook) }
  end

  def unmoved_rooks(rooks)
    rooks.reject(&:moved)
  end

  def empty_path?(rank)
    rank.all?(&:nil?)
  end

  def safe_path?(board, rank)
    # checks that the castling path doesn't cross over any checked squares
    castling_path(board.data, rank).each_index do |file|
      # return false if checked_squares(board).include?([rank, file])
    end

    true
  end

  def opponent_pieces(data)
    data.flatten.compact.reject { |piece| piece.color == color }
  end

  def castling_path(data, rank)
    # the squares the king moves over when castling
    start_index = location[1] - 2
    end_index = location[1] + 2

    data[rank][start_index..end_index]
  end
end
