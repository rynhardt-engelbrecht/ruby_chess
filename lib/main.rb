# frozen_string_literal: true

require_relative 'pieces/pieces'
require_relative 'player/player'
require_relative 'computer/computer'
require_relative 'game'
require_relative 'serializer'
require_relative 'text/text_output'

# game = Game.new(0)
# game.setup_game(Board, Player, Player)
# game.play

include TextOutput

# rubocop:disable Metrics/MethodLength
def main_menu
  print starting_text

  print "\e[96m>> \e[0m"
  input = gets.chomp.to_i
  if input == 4
    game = Game.new(0)
    game = game.load_game
  else
    game = Game.new(input)
    game.setup_game(Board)
  end

  game.play
end
# rubocop:enable Metrics/MethodLength

main_menu
