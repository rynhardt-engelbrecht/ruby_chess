# frozen_string_literal: true
require 'pry-byebug'
require_relative 'input_error'

# contains logic to handle all input from the player
module InputHandler
  KEYWORDS = %w[q quit exit s save]

  def coordinates_input(input = gets.chomp.downcase)
    # check for correct format and correct range
    coordinates_input unless valid_input?(input)

    if KEYWORDS.include?(input)
      handle_control(input)
      raise InputError
    end

    rank_index = 8 - input[1].to_i

    file_index = input[0]
    file_integer_index = file_index.ord - 97

    [rank_index, file_integer_index]
  end

  private

  def quit_game
    print game_message('save prompt')
    input = gets.chomp.downcase

    save_game if %w[y yes].include?(input)

    puts game_message('quit')
    sleep(1)
    exit
  end

  def save_game
    @game.save_game
    sleep(1)
  end

  def handle_control(input)
    quit_game if %w[q quit exit].include?(input)
    save_game if %w[s save].include?(input)
  end

  def valid_input?(input)
    input.match?(/^[a-h][1-8]$/) || KEYWORDS.include?(input)
  end
end
