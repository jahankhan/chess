require_relative 'piece'
require_relative 'display'
require_relative 'cursor'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
require_relative 'knight'
require_relative 'null_piece'
require_relative 'pawn'
# require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    initial_setup
    @w_kings_pos = [4,7]
    @b_kings_pos = [4,0]
  end

  def initial_setup
    @grid.each_with_index do |row,row_idx|
      return if row_idx > 1 #return after making pawns
      row.each_with_index do |square,col_idx|
        #Rooks, knights, bishops being created
        if row_idx == 0
          if col_idx == 0
            self.create_piece(:R, [col_idx,row_idx], :BLK)
            self.create_piece(:R, [@grid.length-1-col_idx,row_idx], :BLK)
            self.create_piece(:R, [col_idx, @grid.length-1-row_idx], :W)
            self.create_piece(:R, [@grid.length-1-col_idx, @grid.length-1-row_idx], :W)
          elsif col_idx == 1
            self.create_piece(:N, [col_idx,row_idx], :BLK)
            self.create_piece(:N, [@grid.length-1-col_idx,row_idx], :BLK)
            self.create_piece(:N, [col_idx, @grid.length-1-row_idx], :W)
            self.create_piece(:N, [@grid.length-1-col_idx, @grid.length-1-row_idx], :W)
          elsif col_idx==2
            self.create_piece(:B, [col_idx,row_idx], :BLK)
            self.create_piece(:B, [@grid.length-1-col_idx,row_idx], :BLK)
            self.create_piece(:B, [col_idx, @grid.length-1-row_idx], :W)
            self.create_piece(:B, [@grid.length-1-col_idx, @grid.length-1-row_idx], :W)
          elsif col_idx == 3 #Create queen
            self.create_piece(:Q, [col_idx,row_idx], :BLK)
            self.create_piece(:Q, [col_idx, @grid.length-1-row_idx], :W)
          elsif col_idx == 4 #create king
            self.create_piece(:K, [col_idx,row_idx], :BLK)
            self.create_piece(:K, [col_idx, @grid.length-1-row_idx], :W)
          end
        elsif row_idx == 1 #Create pawns
          self.create_piece(:P, [col_idx,row_idx], :BLK)
          self.create_piece(:P, [col_idx, @grid.length-1-row_idx], :W)
        end
      end
    end

  end

  def create_piece(name, pos, color)
    case name
    when :R
      self[pos] = Rook.new(:R, self, pos, color)
    when :B
      self[pos] = Bishop.new(:B, self, pos, color)
    when :Q
      self[pos] = Queen.new(:Q, self, pos, color)
    when :K
      self[pos] = King.new(:K, self, pos, color)
    when :N
      self[pos] = Knight.new(:N, self, pos, color)
    when :P
      self[pos] = Pawn.new(:P, self, pos, color)
    end
  end


  def [](pos)
    x,y=pos
    @grid[x][y]
  end

  def []=(pos,value)
    x,y=pos
    @grid[x][y] = value
  end

  def move_piece(start_pos, end_pos)
    # debugger
    validate!(start_pos,end_pos)
    valid_moves_arr = self[start_pos].valid_moves
    if valid_moves_arr.include?(end_pos)
      self[end_pos] = self[start_pos]
      self[end_pos].pos = end_pos
      self[start_pos] = NullPiece.instance
      if self[end_pos].is_a?(King)
        self[end_pos].color == :W ? @w_kings_pos=end_pos : @b_kings_pos=end_pos
      end
    else

      raise 'Invalid move'

    end
  end

  def move_piece!(start_pos, end_pos)

    validate!(start_pos,end_pos)
    self[end_pos] = self[start_pos]
    self[end_pos].pos = end_pos
    self[start_pos] = NullPiece.instance
    if self[end_pos].is_a?(King)
      self[end_pos].color == :W ? @w_kings_pos=end_pos : @b_kings_pos=end_pos
    end
  end

  def validate!(start_pos,end_pos)
    unless valid_pos?(start_pos) && valid_pos?(end_pos)
      begin
        raise ArgumentError.new("Invalid coordinates given")
      rescue ArgumentError => e
        return false
      end
    end
    !piece_exists?(end_pos)
  end

  def valid_pos?(pos)
    return pos[0].between?(0,7) && pos[1].between?(0,7)
  end

  def piece_exists?(pos)
    if self[pos].is_a?(Piece)
      begin
        raise ArgumentError.new("PIECE AT STARTING LOCATION")
      rescue ArgumentError => e
        return true
      end
    end
    false
  end

  def in_check?(color) #whether COLOR is in check
    #find the king of color
    king_pos = get_king_pos(color)
    @grid.each_with_index do |row,row_idx|
      row.each_with_index do |square,col_idx|
        if square.is_a?(Piece) && square.color!=color
          return true if square.get_moves.any?{ |move| move==king_pos}
        end
      end
    end
    return false
  end

  def checkmate?(color)
    king_pos = get_king_pos(color)
    @grid.each_with_index do |row,row_idx|
      row.each_with_index do |square,col_idx|
        #grab square if not nil
        if square.is_a?(Piece) && square.color==color
          #get all valid moves of square
          return false unless square.valid_moves.empty?
        end
      end
    end
    #iterate through all valid moves and find one where in_check? false
    if in_check?(color) && self[king_pos].valid_moves.empty?
      return true
    end
    false
  end

  def get_king_pos(color)
    color == :BLK ? @b_kings_pos : @w_kings_pos
  end

  def dup
    duped_board = Board.new
    duped_board.grid.each_with_index do |row,row_idx|
      row.each_with_index do |square,col_idx|
        duped_board[[row_idx,col_idx]] = self[[row_idx,col_idx]].dup(duped_board)
      end
    end
    return duped_board
  end
end
