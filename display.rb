require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_accessor :cursor, :board, :start_pos, :end_pos, :current_player
  def initialize(current_player)
    @board = Board.new
    @cursor = Cursor.new([7,0], @board)
    @start_pos = nil
    @end_pos = nil
    @current_player = current_player
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
      return -1 if board[input.reverse].is_a?(NullPiece) || board[input.reverse].color != @current_player.name.to_sym
      @start_pos = @cursor.cursor_pos
    elsif input == @cursor.cursor_pos && !start_pos.nil?
      @end_pos = @cursor.cursor_pos
      board.move_piece(@start_pos.reverse, @end_pos.reverse)
      reset_pos
      return 0
    end
    1
  end

  def get_computer_moves(board, color)
    computer_pieces = []
    board.grid.each do |row|
      row.each do |square|
          if !square.is_a?(NullPiece) && square.color == color
            computer_pieces << square
          end
      end
    end
    moves = []
    computer_pieces.each do |piece|
      piece_moves = piece.valid_moves
      piece_moves.each do |move|
        moves << [piece.pos, move]
      end
    end
    moves
  end

  def receive_computer_input()
    best_move = negamax(@board, 3, -100000, 100000, -1)
    @board.move_piece(best_move[0][0], best_move[0][1])
  end

  def negamax(board, depth, a, b, color)
    if depth == 0
      return color * board.evaluate()
    end
    get_color = color == 1 ? :W : :BLK
    moves = get_computer_moves(board, get_color)
    best_val = -100000
    best_move = nil
    moves.each do |move|
      new_board = board.dup
      new_board.move_piece(move[0], move[1])
      value = -negamax(new_board, depth - 1, -b, -a, -color)
      if value.is_a?(Array)
        a = [a, value.last].max
      else
        a = [a, value].max
      end
      return a if a >= b
      if value > best_val
        best_move = move
        best_val = value
      end
    end
    if depth == 3
      return [best_move, best_val]
    end
    return best_val
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
              print " #{square.to_s.encode('utf-8')} ".blue.colorize(background: bg_color)
            else
              print " #{square.to_s.encode('utf-8')} ".black.colorize(background: bg_color)
            end
          end
        else
          if @cursor.cursor_pos == [i,j]
            print " _ ".red.blink.colorize(background: bg_color)
          else
            print "   ".colorize(background: bg_color)
          end
        end
      end
      puts ""
    end
    @current_player.name.to_sym == :W ? puts("White to play") : puts("Black to play")
  end

  def get_bg_color(i, j)
    (i+j) % 2 == 0 ? :light_white : :green
  end
end
