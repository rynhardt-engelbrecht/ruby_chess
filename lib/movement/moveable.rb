# frozen_string_literal: true

# contains logic to move pieces on the board
module Moveable
  def move_piece(origin, destination)
    piece = data[origin[0]][origin[1]]

    make_move(piece, destination)
    piece.moved = true

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  private

  def make_move(piece, destination)
    piece.en_passant_capture(self, destination[0], destination[1]) if can_en_passant?(piece, destination)

    data[destination[0]][destination[1]] = piece
    remove_piece(piece.location)
    @last_move = [piece, piece.location, destination]
    update_location(piece, destination)
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
