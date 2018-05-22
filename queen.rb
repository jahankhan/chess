require_relative 'sliding_piece'
require_relative 'piece'

class Queen < Piece

  include SlidingPiece


  def to_s
    color == :W ? "\u2655" : "\u265B"
  end

  def move_dirs
    return [[1,1],[-1,-1],[1,-1],[-1,1],[0,1],[0,-1],[1,0],[-1,0]]
  end

  def get_moves
    moves(move_dirs)
  end

  def dup(board)
    return Queen.new(name,board,pos,color)
  end

end
