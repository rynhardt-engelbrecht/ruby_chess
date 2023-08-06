# frozen_string_literal: true

require_relative 'text/text_output'

# contains logic handle any visual output
module Displayable
  include TextOutput

  def print_board
    system 'clear'
    puts
    puts "\e[38;2;181;101;29m   a b c d e f g h \e[0m"
    print_squares
    puts "\e[38;2;181;101;29m   a b c d e f g h \e[0m"
    puts
  end

  private

  def print_squares
    @data.each_with_index do |rank, index|
      print "\e[38;2;181;101;29m #{8 - index} \e[0m"
      print_row(rank, index)
      print "\e[38;2;181;101;29m #{8 - index} \e[0m"
      puts
    end
  end

  def print_row(rank, rank_index)
    rank.each_with_index do |square, file_index|
      background_color = (rank_index + file_index).even? ? '48;2;181;101;29' : '48;2;187;149;100'
      print_square(square, background_color)
    end
  end

  def print_square(square, background)
    text_color = square.color == :white ? ';97' : ';30' if square
    text = square&.symbol || '  '

    color_square(background, text, text_color)
  end

  def color_square(background, string, string_color)
    print "\e[#{background}#{string_color}m#{string}\e[0m"
  end
end
