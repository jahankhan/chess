require_relative 'sliding_piece'
require_relative 'piece'

class Bishop < Piece

  include SlidingPiece


  def to_s
    color == :W ? "\u2657" : "\u265D"
  end

  def move_dirs
    return [[1,1],[-1,-1],[1,-1],[-1,1]]
  end

  def get_moves
    moves(move_dirs)
  end

  def dup(board)
    return Bishop.new(name,board,pos,color)
  end

end
