# frozen_string_literal: true

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
      'saved' => "\e[92mGame has been saved as #{file_name}\e[0m"
    }[message]
  end
end
