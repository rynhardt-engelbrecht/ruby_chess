# frozen_string_literal: true

require_relative 'text/text_output'

# contains main logic to run the game
class Game
  include TextOutput

  attr_reader :players, :board, :mode

  def initialize(mode)
    @mode = mode
    @last_move = nil
  end

  def play
    loop do
      if board.checkmate?(board.active_color)
        puts game_message('win', board.active_color == :white ? :black : :white)
        break
      end

      halfmove
    end

    puts game_message('draw') unless board.checkmate?(board.active_color)
  end

  def setup_game(board_obj, first_player_obj, second_player_obj)
    create_board(board_obj)
    @players = create_players(@board, first_player_obj, second_player_obj)
  end

  private

  def halfmove
    active_player = players.find { |player| player.color == @board.active_color }
    @board.print_board(board.active_color)

    active_player.turn
    @board.print_board(board.active_color)

    perform_pending_promotions

    @board.active_color = @board.active_color == :white ? :black : :white
  end

  def perform_pending_promotions
    @board.data.each do |rank|
      rank.each do |piece|
        next unless piece.instance_of?(Pawn) && piece.pending_promotion?

        promote_pawn(piece)
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

  def promote_pawn(pawn)
    promotion = prompt_promotion
    piece_to_promote = Object.const_get(promotion)
    @board.data[pawn.location[0]][pawn.location[1]] = piece_to_promote.new(
      @board,
      pawn.location,
      pawn.color,
      moved: true
    )
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
