# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Queen < Piece chess piece
class Queen < Piece
  include Movable
end
