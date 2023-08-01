# frozen_string_literal: true

# contains main logic to run the game
class Game
  def initialize(mode)
    @mode = mode
  end

  def setup_game(board_obj, first_player_obj, second_player_obj)
    @board = create_board(board_obj)
    @players = create_players(@board, first_player_obj, second_player_obj)
  end

  private

  def create_board(board_obj)
    @board = board_obj.new
  end

  def create_players(board, first_player_obj, second_player_obj)
    [
      first_player_obj.new(board, :white),
      second_player_obj.new(board, :black)
    ]
  end
end
