# frozen_string_literal: true

module TextOutput
  def turn_message(message, color = nil)
    {
      'which color' => " #{color}'s turn \n==============",
      'square' => 'Enter coordinates of the piece you want to move (Eg. b2)>>',
      'move' => 'Enter the coordinates of the square you want to move the selected piece to (Eg. c2)>>'
    }[message]
  end
end
