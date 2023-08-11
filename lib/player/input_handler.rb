# frozen_string_literal: true

require_relative 'input_error'

# contains logic to handle all input from the player
module InputHandler
  KEYWORDS = %w[q quit exit back].freeze

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

  def handle_control(input)
    raise SaveQuitError if %w[q quit exit].include?(input)
    raise InputBackError if input == 'back'
  end

  def valid_input?(input)
    input.match?(/^[a-h][1-8]$/) || KEYWORDS.include?(input)
  end
end
