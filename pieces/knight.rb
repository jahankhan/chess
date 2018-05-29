require_relative 'stepping_piece'

class Knight < Piece

  include SteppingPiece

  def to_s
    color == :W ? "\u2658" : "\u265E"
  end

  def move_dirs
    return [[2,1],[2,-1],[-1,2],[1,2],[-1,-2],[1,-2],[-2,1],[-2,-1]]
  end

  def get_moves
    moves(move_dirs)
  end

  def dup(board)
    return Knight.new(name,board,pos,color)
  end
end
