require_relative 'sliding_piece'
require_relative 'piece'

class Rook < Piece

  include SlidingPiece

  def to_s
    color == :W ? "\u2656" : "\u265C"
  end

  def move_dirs
    return [[0,1],[0,-1],[1,0],[-1,0]]
  end

  def get_moves
    moves(move_dirs)
  end

  def dup(board)
    return Rook.new(name,board,pos,color)
  end
end
