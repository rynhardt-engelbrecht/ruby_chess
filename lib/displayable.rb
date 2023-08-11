# frozen_string_literal: true

require_relative 'text/text_output'

# contains logic handle any visual output
module Displayable
  include TextOutput

  COLORS = {
    white: ';97',
    black: ';30',
    beige: '48;2;187;149;100',
    brown: '48;2;181;101;29',
    green: '102',
    red: '41',
    blue: '46'
  }.freeze

  def print_board(color)
    system 'clear'
    puts
    puts "\e[38;2;181;101;29m   a b c d e f g h \e[0m"
    print_squares
    puts "\e[38;2;181;101;29m   a b c d e f g h \e[0m"
    puts
    puts turn_message('which color', color)
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
      background_color = determine_background(rank_index, file_index)
      print_square(square, background_color)
    end
  end

  def determine_background(rank, file)
    if @active_piece&.location == [rank, file]
      return COLORS[:green]
    # elsif capturing_square?(rank, file)
    #   return COLORS[:red]
    # elsif valid_move_square?(rank, file)
    #   return COLORS[:blue]
    elsif (rank + file).even?
      return COLORS[:brown]
    end

    COLORS[:beige]
  end

  def capturing_square?(rank, file)
    @active_piece&.safe_moves(self)&.include?([rank, file]) &&
      @data[rank][file]&.color != @active_color &&
      !@data[rank][file].nil?
  end

  def print_square(square, background)
    text_color = square.color == :white ? COLORS[:white] : COLORS[:black] if square
    text = square&.symbol || '  '

    color_square(background, text, text_color)
  end

  def valid_move_square?(rank, file)
    @active_piece&.safe_moves(self)&.include?([rank, file])
  end

  def color_square(background, string, string_color)
    print "\e[#{background}#{string_color}m#{string}\e[0m"
  end
end
