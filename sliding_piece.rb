require 'byebug'
require_relative "stepping_piece"
module SlidingPiece

  include SteppingPiece


  def moves(move_dirs_arr)
    # debugger
    output = []
    starting_pos = pos
    move_dirs_arr.each do |dir|
      while true
        newpos= get_new_pos(starting_pos, dir)

        if board.validate!(starting_pos,newpos)
          output.push(newpos)
          starting_pos = newpos
        else
          if is_enemy?(newpos)
            output.push(newpos)
          end
          starting_pos=pos
          break
        end
      end
    end
    return output
  end



end
