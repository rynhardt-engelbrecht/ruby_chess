# frozen_string_literal: true

# contains the logic to handle player input
class Player
  def initialize(color)
    @color = color
  end

  def turn
    # should input the piece to move
    coordinates_input
    # verify that there's actually an ally piece there
    # then input the square to move the chosen piece to
    coordinates_input
    # verify that the given input is a valid move
    # by checking @valid_moves and @valid_captures of the piece
    # finally call the Board#move_piece method
  end

  private

  def coordinates_input(input = gets.chomp.downcase)
    coordinates_input unless input.match?(/^[a-h][1-8]$/) # check for correct format and correct range

    rank_letter_index = input[0]
    rank_integer_index = rank_letter_index.ord - 97
    file_index = input[1].to_i - 1

    [rank_integer_index, file_index]
  end
end
