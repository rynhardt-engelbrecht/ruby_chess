# frozen_string_literal: true

require_relative 'piece'
require_relative '../movement/movable'

# contains logic for the Bishop chess piece
class Bishop < Piece
  include Movable
end
