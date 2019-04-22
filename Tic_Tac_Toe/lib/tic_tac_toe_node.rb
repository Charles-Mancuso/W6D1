require_relative 'tic_tac_toe'
require "byebug"

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos && prev_move_pos || []
  end

  def losing_node?(evaluator) #is evaluator :x or :o?
    if @board.over?
      return !(@board.winner == evaluator || @board.winner == nil)
    else  #board isn't full/over
      if @next_mover_mark == evaluator  #if it's our turn
        return self.children.all? do |e|  #check to see if all our children are losers
          e.losing_node?(evaluator)
        end
      else  #if not our turn
        return self.children.any? do |e|  #check to see if any our children are losers
          e.losing_node?(evaluator)
        end
      end
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      return @board.winner == evaluator
    else
      if @next_mover_mark == evaluator
        return self.children.any? do |e|
          e.winning_node?(evaluator)
        end
      else
        return self.children.all? do |e|
          e.winning_node?(evaluator)
        end
      end
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    node_arr = []
    (0..2).each do |row|
      (0..2).each do |col|
        if @board.empty?([row, col])
          updated_board = @board.dup
          updated_board[[row, col]] = @next_mover_mark
          updated_positions = @prev_move_pos.dup
          updated_positions += [row, col]
          node_arr << TicTacToeNode.new(updated_board, @next_mover_mark == :o && :x || :o, updated_positions) 
        end
      end
    end
    node_arr
  end

  # def inspect
  #   string = ""
  #   @board.rows.each do |row|
  #     string += "#{row}\n"
  #   end
  #   string + "\n"
  # end
end

# board = Board.new
# board.[]=([1,1],:x)

# node = TicTacToeNode.new(board, :o)
# p node.children

