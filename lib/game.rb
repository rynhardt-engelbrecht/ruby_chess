# frozen_string_literal: true

# contains main logic to run the game
class Game
  attr_reader :players, :board, :mode

  def initialize(mode)
    @mode = mode
    @active = true
  end

  def play
    fullmove until @active == false
  end

  def setup_game(board_obj, first_player_obj, second_player_obj)
    create_board(board_obj)
    @players = create_players(@board, first_player_obj, second_player_obj)
  end

  private

  def fullmove
    halfmove
    halfmove
  end

  def halfmove
    @board.print_board

    active_player = players.find { |player| player.color == @board.active_color }
    active_player.turn
    @board.print_board

    @board.active_color = @board.active_color == :white ? :black : :white
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
