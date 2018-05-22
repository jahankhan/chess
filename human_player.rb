class HumanPlayer
  attr_accessor :name
  def initialize(name)
    @name = name
  end


  def make_move(display)
    display.render
  end
end
