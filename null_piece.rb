require "singleton"

class NullPiece
  include Singleton

  def dup(board)
    return NullPiece.instance
  end
end
