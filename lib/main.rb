# frozen_string_literal: true

require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'player/player'
require_relative 'game'
require_relative 'serializer'

game = Game.new(0)
game.setup_game(Board, Player, Player)
game.play

# def main_menu
