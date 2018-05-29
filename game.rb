require_relative "game/display"
require_relative "game/human_player"
require_relative "game/computer_player"

class Game

  def initialize(type)
    @player1 = HumanPlayer.new("W")
    if type == '1'
      @player2 = ComputerPlayer.new("BLK")
    else
      @player2 = HumanPlayer.new("BLK")
    end
    @current_player = @player1
    @display = Display.new(@current_player)
  end

  def play
    until game_over?
      begin
        @current_player.make_move(@display)
      rescue
        puts "Invalid move"
        sleep(1)
        @display.start_pos = nil
        @display.end_pos = nil
        retry
      end
      swap_current_player
    end
    @display.render(false)
    puts "#{@current_player.name} lost haha loser"
  end

  def game_over?
    @display.board.checkmate?(:W) || @display.board.checkmate?(:BLK)
  end

  def swap_current_player
    @current_player = @current_player == @player1 ? @player2 : @player1
    @display.current_player = @current_player
    if @current_player == @player2
      @display.cursor.cursor_pos = [0,0]
    else
      @display.cursor.cursor_pos = [7,0]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  p 'Input 0 for singleplayer or 1 for multiplayer'
  input = gets.chomp
  g = Game.new(input)
  g.play
end
