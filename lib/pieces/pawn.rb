# frozen_string_literal: true

require_relative 'piece'

# contains logic for the Pawn < Piece chess piece
class Pawn < Piece
  def initialize(board, location, color, moved: false)
    super
    @direction = @color == :white ? -1 : 1
    @symbol = "\u265F "

    @pending_promotion = false
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

  def en_passant_capture(board, rank, file)
    capture_target = en_passant_target(board, rank, file)
    board.data[capture_target.location[0]][capture_target.location[1]] = nil
  end

  def en_passant?(board, rank, file)
    board.last_move &&
      pawn_move?(board) &&
      moved_two_squares?(board) &&
      en_passant_rank?(board, rank) &&
      same_file?(board, file)
  end

  def pending_promotion?
    @pending_promotion
  end

  def update(board)
    @valid_moves = []
    if eligible_promotion?
      @pending_promotion = true
    else
      legal_moves(board, @location[0], @location[1])
    end
  end

  # rubocop:disable Metrics/MethodLength
  def score_map
    map = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [-1, -1, -1, -1, -1, -1, -1, -1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [2, 2, 1, 1, 1, 1, 2, 2],
      [2, 2, 1, 1, 1, 1, 2, 2],
      [4, 4, 2, 0, 0, 2, 4, 4]
    ]

    color == :white ? map.reverse : map
  end
  # rubocop:enable Metrics/MethodLength

  private

  def check_captures(board, rank, file)
    # checking if there is an opponent piece diagonally across from the pawn
    capture_moves.each do |move|
      capture_rank = rank + move[0]
      capture_file = file + move[1]

      @valid_moves << [capture_rank, capture_file] if eligible_capture?(board, capture_rank, capture_file)
    end
  end

  def eligible_capture?(board, rank, file)
    opponent_piece?(board, rank, file) || en_passant?(board, rank, file)
  end

  def moveset
    return [[@direction, 0], [@direction * 2, 0]] unless @moved

    [[@direction, 0]] if @moved
  end

  def capture_moves
    [[@direction, 1], [@direction, -1]]
  end

  def en_passant_target(board, rank, file)
    board.last_move[0] if en_passant?(board, rank, file)
  end

  def en_passant_rank?(board, rank)
    (rank == 2 && board.last_move[0].color == :black) || (rank == 5 && board.last_move[0].color == :white)
  end

  def eligible_promotion?(rank = location[0])
    (color == :white && rank.zero?) || (color == :black && rank == 7)
  end

  def same_file?(board, file)
    file == board.last_move[2][1]
  end

  def moved_two_squares?(board)
    (board.last_move[2][0] - board.last_move[1][0]).abs == 2
  end

  def pawn_move?(board)
    board.last_move[0].instance_of?(self.class)
  end
end
