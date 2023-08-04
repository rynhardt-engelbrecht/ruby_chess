# frozen_string_literal: true

require_relative 'text/text_output'

# contains main logic to run the game
class Game
  include TextOutput

  attr_reader :players, :board, :mode

  def initialize(mode)
    @mode = mode
    @active = true
    @last_move = nil
  end

  def play
    halfmove until @active == false
  end

  def setup_game(board_obj, first_player_obj, second_player_obj)
    create_board(board_obj)
    @players = create_players(@board, first_player_obj, second_player_obj)
  end

  private

  def halfmove
    active_player = players.find { |player| player.color == @board.active_color }
    @board.print_board(active_player.color)

    active_player.turn
    @board.print_board(active_player.color)

    perform_pending_promotions

    @board.active_color = @board.active_color == :white ? :black : :white
  end

  def perform_pending_promotions
    @board.data.each do |rank|
      rank.each do |piece|
        next unless piece.instance_of?(Pawn) && piece.pending_promotion?

        promotion = prompt_promotion
        promoted_piece = Object.const_get(promotion)
        @board.data[piece.location[0]][piece.location[1]] = promoted_piece.new(@board, piece.location, piece.color)
      end
    end
  end

  def prompt_promotion(input = nil)
    print game_message('promotion')
    expected_input = %w[Rook Knight Bishop Queen]

    until expected_input.include?(input)
      input = gets.chomp.capitalize

      puts error_message('promotion') unless expected_input.include?(input)
    end

    input.to_sym
  end

  def create_board(board_obj)
    @board = board_obj.new
    @board.piece_setup
  end

  def create_players(board, first_player_obj, second_player_obj)
    [
      first_player_obj.new(board, :white),
      second_player_obj.new(board, :black)
    ]
  end
end
