# frozen_string_literal: true

require_relative 'text/text_output'
require_relative 'serializer'

# contains main logic to run the game
class Game
  include TextOutput
  include Serializer

  attr_reader :players, :board, :mode

  def initialize(mode)
    @mode = mode
    @last_move = nil
  end

  def play
    iterate_game

    puts game_message('draw') unless board.checkmate?(board.active_color)
  end

  def setup_game(board_obj)
    create_board(board_obj)
    players = determine_mode
    @players = create_players(@board, players[0], players[1])

    board.send(:changed_and_notify)
  end

  private

  def iterate_game
    loop do
      if board.checkmate?(board.active_color)
        puts game_message('win', board.active_color == :white ? :black : :white)
        break
      end

      halfmove
    # rescue StopSaveError
    #   return 'save start again'
    rescue SaveQuitError
      quit
    end
  end

  def quit
    print game_message('save prompt')
    input = gets.chomp.downcase

    save_game if %w[y yes].include?(input)

    puts game_message('quit')
    exit
  end

  def determine_mode
    case @mode
    when 0
      [Player, Player]
    when 1
      [Player, Computer]
    when 2
      [Computer, Player]
    when 3
      [Computer, Computer]
    end
  end

  def halfmove
    active_player = players.find { |player| player.color == @board.active_color }
    @board.print_board(board.active_color)

    result = active_player.turn
    return if result == 'try again'

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
      first_player_obj.new(board, self, :white),
      second_player_obj.new(board, self, :black)
    ]
  end
end
