# frozen_string_literal: true

require 'observer'

# contains logic for a chess board, mainly to keep track of the state of the game and all pieces present in the game.
class Board
  include Observable

  attr_accessor :data, :active_color
  attr_reader :en_passant_target, :castling_avail, :halfmove_clock

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data # board represented using a 2-Dimensional array.
    @active_color = params[:active_color]
    @en_passant_target = params[:en_passant_target]
    @castling_avail = params[:castling_avail]
    @halfmove_clock = params[:halfmove_clock]
  end
end
