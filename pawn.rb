require 'byebug'

class Pawn < Piece

  DIAGONALS = [[1,1],[-1,1],[-1,-1],[1,-1]]

  def move_dirs
    white_full_arr = [[0,-1],[0,-2],[-1,-1], [1,-1]]
    white_small_arr = [[0,-1],[-1,-1], [1,-1]]
    if color == :W
      if pos[1]==6
        return white_full_arr
      end
      return white_small_arr
    elsif color == :BLK
      if pos[1]==1
        return negation_array(white_full_arr)
      end
      return negation_array(white_small_arr)
    end
  end

  def negation_array(arr)
    arr.map{|array| [array.first*-1,array.last*-1]}
  end

  def to_s
    color == :W ? "\u2659" : "\u265F"
  end


  def get_moves
    output = []
    starting_pos = pos
    move_dirs_arr = move_dirs
    move_dirs_arr.each do |move|
      # debugger
      newpos= starting_pos.map.with_index do |el, i|
        el + move[i]
      end
      if board.validate!(starting_pos,newpos) && !DIAGONALS.include?(move)
        output.push(newpos)
      else
        # debugger
        if valid_capture(move, newpos)
          output.push(newpos)
        end
      end
    end
    return output
  end

  def valid_capture(move, newpos)
    DIAGONALS.include?(move) &&
      board.valid_pos?(newpos) &&
        !board[newpos].is_a?(NullPiece) &&
          board[newpos].color != color
  end

  def dup(board)
    return Pawn.new(name,board,pos,color)
  end

end
