# frozen_string_literal: true

require_relative 'piece'

# contains logic for the Pawn < Piece chess piece
class Pawn < Piece
  attr_reader :en_passant

  def initialize(board, location, color)
    super
    @direction = @color == :white ? -1 : 1
    @symbol = "\u265F "
    @en_passant = false
  end

  def generate_moves(board, rank, file)
    moveset.each do |move|
      new_rank = rank + move[0]
      new_file = file + move[1]

      break unless board.data[new_rank][new_file].nil?

      @valid_moves << [new_rank, new_file] if valid_move?(board, new_rank, new_file)
    end

    check_captures(board, rank, file)
  end

  def en_passant_capture(board)
    capture_target = en_passant_target(board)
    board.data[capture_target.location[0]][capture_target.location[1]] = nil
  end

  def en_passant?(board, rank)
    board.last_move &&
      board.last_move[0].instance_of?(self.class) &&
      (board.last_move[2][0] - board.last_move[1][0]).abs == 2 &&
      en_passant_rank?(board, rank)
  end

  private

  def check_captures(board, rank, file)
    # checking if there is an opponent piece diagonally across from the pawn
    capture_moves.each do |move|
      capture_rank = rank + move[0]
      capture_file = file + move[1]

      @valid_captures << [capture_rank, capture_file] if eligible_capture?(board, capture_rank, capture_file)
    end
  end

  def eligible_capture?(board, rank, file)
    update_en_passant(board, rank)

    opponent_piece?(board, rank, file) || en_passant?(board, rank)
  end

  def moveset
    return [[@direction, 0], [@direction * 2, 0]] unless @moved

    [[@direction, 0]] if @moved
  end

  def capture_moves
    [[@direction, 1], [@direction, -1]]
  end

  def en_passant_target(board)
    board.last_move[0] if @en_passant
  end

  def en_passant_rank?(board, rank)
    (rank == 2 && board.last_move[0].color == :black) || (rank == 5 && board.last_move[0].color == :white)
  end

  def update_en_passant(board, rank)
    @en_passant = en_passant?(board, rank)
  end
end
