# frozen_string_literal: true

# contains logic to handle sending messages to the player
module TextOutput
  def turn_message(message, color = nil)
    {
      'which color' => "==============\n #{color}'s turn \n==============",
      'square' => 'Enter coordinates of the piece you want to move>>',
      'move' => 'Enter the coordinates of the square you want to move the selected piece to>>'
    }[message]
  end
end
