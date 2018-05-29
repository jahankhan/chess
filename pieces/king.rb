require_relative 'stepping_piece'

class King < Piece

  include SteppingPiece

  def move_dirs
    return [[1,1],[-1,-1],[1,-1],[-1,1],[0,1],[0,-1],[1,0],[-1,0]]
  end

  def to_s
    color == :W ? "\u2654" : "\u265A"
  end

  def get_moves
    moves(move_dirs)
  end

  def dup(board)
    return King.new(name,board,pos,color)
  end
end
