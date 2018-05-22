class ComputerPlayer
  attr_accessor :name
  def initialize(name)
    @name = name
  end


  def make_move(display)
    # display.render
    display.receive_computer_input
  end
end
