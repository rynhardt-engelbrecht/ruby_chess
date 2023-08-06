# frozen_string_literal: true

# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/MethodLength

# contains logic to handle sending messages to the player
module TextOutput
  def turn_message(message, color = '')
    {
      'which color' => "==============\n #{color}'s turn \n==============",
      'square' => 'Enter coordinates of the piece you want to move>>',
      'move' => 'Enter the coordinates of the square you want to move the selected piece to>>'
    }[message]
  end

  def error_message(message)
    {
      'unmovable piece' => "\e[91mYou can not move this piece.\nPlease re-enter coordinates of the piece you want to move (Eg. a4).\e[0m",
      'invalid move' => "\e[91mThat is not a valid move.\nPlease re-enter coordinates of the square you want to move the selected piece to.(Eg. d6).\e[0m",
      'promotion' => "\e[91mThat is not a real chess piece. Make sure you spelt correctly,\n type only 'rook', 'knight', 'bishop', or 'queen'.\e[0m",
      'no saves' => "\e[91mNo saves to load from.\e[0m",
      'no file' => "\e[91mFile at given index does not exist. Please try again.\e[0m"
    }[message]
  end

  def game_message(message, color = '', file_name = '')
    {
      'promotion' => "\e[96mWhat piece do you want to promote your pawn to?\nEnter 'Rook', 'Knight', 'Bishop', or 'Queen'>>\e[0m",
      'win' => "\e[96m#{color.capitalize} wins by checkmate!\e[0m",
      'draw' => 'The game ended in a stalemate.',
      'check' => "\e[91mYour king is in check.\e[0m",
      'saved' => "\e[92mGame has been saved as #{file_name}\e[0m",
      'quit' => "\e[33mExiting the game...\e[0m",
      'save prompt' => "\e[96mWould you like to save the game to be able to load it again another time? (y/n)\n>>\e[0m"
    }[message]
  end

  def starting_text
    system 'clear'
    <<~HEREDOC


      \e[91m██████╗░██╗░░░██╗██████╗░██╗░░░██╗░░░░░░░█████╗░██╗░░██╗███████╗░██████╗░██████╗\e[0m
      \e[91m██╔══██╗██║░░░██║██╔══██╗╚██╗░██╔╝░░░░░░██╔══██╗██║░░██║██╔════╝██╔════╝██╔════╝\e[0m
      \e[91m██████╔╝██║░░░██║██████╦╝░╚████╔╝░█████╗██║░░╚═╝███████║█████╗░░╚█████╗░╚█████╗░\e[0m
      \e[91m██╔══██╗██║░░░██║██╔══██╗░░╚██╔╝░░╚════╝██║░░██╗██╔══██║██╔══╝░░░╚═══██╗░╚═══██╗\e[0m
      \e[91m██║░░██║╚██████╔╝██████╦╝░░░██║░░░░░░░░░╚█████╔╝██║░░██║███████╗██████╔╝██████╔╝\e[0m
      \e[91m╚═╝░░╚═╝░╚═════╝░╚═════╝░░░░╚═╝░░░░░░░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░\e[0m

        Welcome to my Command-line Chess Game! Built completely with \e[91mRuby.\e[0m
        (This project is part of the Ruby Course from The Odin Project's Curriculum: https://www.theodinproject.com/lessons/ruby-ruby-final-project)

        My game follows classic chess rules: \e[92mhttps://musketeerchess.net/p/games/classic/rules/rules.php\e[0m

          To play the game, you will be prompted to enter the coordinates of a piece you want to move. Then,
          to enter the coordinates of the square you want to move your selected piece to.

          During the game, you can also enter 'q', 'quit', or 'exit'. When asked to make a move,
          to quit the game. You will then be prompted to type 'y' or 'n' to save your game to allow
          you to load it again later.

          You can also type 'back' after selecting a piece to move, in case you change your mind.

        To get started, just select one of the options below,
        by typing their corresponding number:

          \e[92m[0] >> Player (White) vs. Player (Black)\e[0m
          \e[93m[1] >> Player (White) vs. Computer (Black)\e[0m
          \e[94m[2] >> Player (Black) vs. Computer (White)\e[0m
          \e[95m[3] >> Computer (White) vs. Computer (Black)\e[0m

          [4] >> Load saved game.



    HEREDOC
  end
end

# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/MethodLength
