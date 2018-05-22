require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_accessor :cursor, :board, :start_pos, :end_pos
  def initialize
    @board = Board.new
    @cursor = Cursor.new([7,0], @board)
    @start_pos = nil
    @end_pos = nil

  end

  def render(playing=true)
    while true
      system("clear")
      print_board
      if playing
        case receive_input
        when -1
          next
        when 0
          break
        end
      else
        break
      end
    end
  end

  def receive_input
    input = @cursor.get_input

    if input == @cursor.cursor_pos && start_pos.nil?
      return -1 if board[input.reverse].is_a?(NullPiece)
      @start_pos = @cursor.cursor_pos
    elsif input == @cursor.cursor_pos && !start_pos.nil?
      @end_pos = @cursor.cursor_pos
      board.move_piece(@start_pos.reverse, @end_pos.reverse)
      reset_pos
      return 0
    end
    1
  end

  def reset_pos
    @start_pos = nil
    @end_pos = nil
  end

  def print_board
    @board.grid.transpose.each_with_index do |row, i|
      row.each_with_index do |square, j|
        bg_color = get_bg_color(i,j)
        unless square.is_a?(NullPiece)
          if @cursor.cursor_pos == [i,j]
            print " #{square.to_s.encode('utf-8')} ".red.colorize(background: bg_color)
          else
            if square.color == :W
              print " #{square.to_s.encode('utf-8')} ".white.colorize(background: bg_color)
            else
              print " #{square.to_s.encode('utf-8')} ".colorize(background: bg_color)
            end
          end
        else
          if @cursor.cursor_pos == [i,j]
            print " _ ".red.colorize(background: bg_color)
          else
            print "   ".colorize(background: bg_color)
          end
        end
      end
      puts ""
    end
  end

  def get_bg_color(i, j)
    (i+j) % 2 == 0 ? :cyan : :yellow
  end
end
