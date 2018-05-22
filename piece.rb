class Piece
  attr_accessor :pos, :board, :color, :name, :can_castle
  def initialize(name,board,pos,color)
    @color=color
    @board= board #current board
    @pos = pos #current pos
    @name = name
    @can_castle = true
  end

  def to_s

  end

  def get_moves

  end

  def dup(board)

  end

  def valid_moves
    valid_moves_arr = []
    all_moves = get_moves
    all_moves.each do |move|
      unless move_into_check?(move)
        valid_moves_arr << move
      end
    end
    valid_moves_arr
  end

  def move_into_check?(end_pos)
    duped = board.dup
    duped.move_piece!(pos, end_pos)
    duped.in_check?(color)
  end
end
