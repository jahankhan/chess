module SteppingPiece

  def moves(move_dirs_arr)
    output = []
    starting_pos = pos
    move_dirs_arr.each do |dir|
      newpos= get_new_pos(starting_pos, dir)
      if board.validate!(starting_pos,newpos)
        output.push(newpos)
      else
        if is_enemy?(newpos)
          output.push(newpos)
        end
      end
    end
    output
  end

  def get_new_pos(pos, dir)
    pos.map.with_index do |el, i|
      el + dir[i]
    end
  end

  def is_enemy?(pos)
    board.valid_pos?(pos) && board[pos].color != self.color
  end
end
