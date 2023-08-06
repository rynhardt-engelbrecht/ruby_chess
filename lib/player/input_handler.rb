# frozen_string_literal: true
require_relative 'input_error'

# contains logic to handle all input from the player
module InputHandler
  KEYWORDS = %w[q quit exit s save back].freeze

  def coordinates_input(input = gets.chomp.downcase)
    # check for correct format and correct range
    coordinates_input unless valid_input?(input)

    return handle_control(input) if KEYWORDS.include?(input)

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
    if %w[s save].include?(input)
      save_game
      raise InputSaveError
    elsif input == 'back'
      raise InputBackError
    end
  end

  def valid_input?(input)
    input.match?(/^[a-h][1-8]$/) || KEYWORDS.include?(input)
  end
end
