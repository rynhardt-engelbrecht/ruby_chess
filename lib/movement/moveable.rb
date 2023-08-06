# frozen_string_literal: true

# contains logic to move pieces on the board
module Moveable
  def move_piece(piece, new_location)
    piece.en_passant_capture(self) if piece.instance_of?(Pawn) &&
                                      piece.en_passant?(self, new_location[0], new_location[1])
    @last_move = [piece, piece.location, new_location]
    temp_piece = piece # create a copy of the piece so we can remove the original piece from it's original location
    remove_old_piece(piece)
    data[new_location[0]][new_location[1]] = temp_piece # insert the copied piece at the specified location
    temp_piece.moved = true
    update_location(temp_piece, new_location)

    changed_and_notify # notifies pieces to update valid_moves and valid_captures
  end

  def update_location(piece, new_location)
    piece.location = [new_location[0], new_location[1]]
  end

  def remove_old_piece(piece)
    rank = piece.location[0]
    file = piece.location[1]

    data[rank][file] = nil
  end
end
