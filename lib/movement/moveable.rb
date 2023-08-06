# frozen_string_literal: true

# contains logic to move pieces on the board
module Moveable
  def move_piece(origin, destination)
    piece = data[origin[0]][origin[1]]

    if castling?(piece, destination)
      castle(piece, destination)
    else
      make_move(piece, destination)
    end

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  private

  def castle(piece, destination)
    king_rank = piece.location[0]

    if piece.queen_side_castling?(self)
      castle_queen_side(piece, destination, king_rank)
    elsif piece.king_side_castling?(self)
      castle_king_side(piece, destination, king_rank)
    end
  end

  def castle_king_side(piece, destination, king_rank)
    king_side_rook = data[king_rank][7]
    make_move(piece, destination)
    make_move(king_side_rook, [king_rank, 5])
  end

  def castle_queen_side(piece, destination, king_rank)
    queen_side_rook = data[king_rank][0]
    make_move(piece, destination)
    make_move(queen_side_rook, [king_rank, 3])
  end

  def castling?(piece, destination)
    piece.instance_of?(King) && piece.send(:castling_moves, self).include?(destination)
  end

  def make_move(piece, destination)
    piece.en_passant_capture(self, destination[0], destination[1]) if can_en_passant?(piece, destination)
    data[destination[0]][destination[1]] = piece
    remove_piece(piece.location)
    @last_move = [piece, piece.location, destination]
    update_location(piece, destination)

    piece.moved = true
  end

  def can_en_passant?(piece, destination)
    piece.instance_of?(Pawn) && piece.en_passant?(self, destination[0], destination[1])
  end

  def update_location(piece, new_location)
    piece.location = [new_location[0], new_location[1]]
  end

  def remove_piece(location)
    data[location[0]][location[1]] = nil
  end
end
