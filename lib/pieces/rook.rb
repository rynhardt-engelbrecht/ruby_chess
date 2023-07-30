# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Rook < Piece chess piece
class Rook < Piece
  include Movable
end
