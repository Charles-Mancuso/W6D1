require_relative '00_tree_node'
require "byebug"

class KnightPathFinder

    attr_reader :start_pos, :root
    def self.valid_moves(pos)
        x = pos[0]
        y = pos[1]
        moves = []

        moves << [x - 1, y - 2]
        moves << [x - 1, y + 2]
        moves << [x + 1, y - 2]
        moves << [x + 1, y + 2]
        moves << [x - 2, y - 1]
        moves << [x - 2, y + 1]
        moves << [x + 2, y - 1]
        moves << [x + 2, y + 1]
        moves.reject { |x,y| x < 0 || y < 0 || x > 7 || y > 7 }
    end

    def initialize(start_pos)
        @start_pos = start_pos
        @considered_pos = [start_pos]
    end

    def new_move_positions(pos)
        positions = KnightPathFinder.valid_moves(pos)
        positions.reject! {|array| @considered_pos.include?(array)}
        @considered_pos += positions
        positions
    end
    
    def build_move_tree #define all relationships
        @root = PolyTreeNode.new(start_pos)
        queue = [@root]
        until queue.empty?
            new_move_positions(queue.first.position).each do |position|
                child = PolyTreeNode.new(position)
                child.parent = queue.first
                queue << child
            end
            queue.shift
        end
    end

#---------------W2 D1 Work

    def trace_path_back(target_node)
        arr = [target_node]
        until arr.first.position == @start_pos
           arr.unshift(arr.first.parent) 
        end
        arr
    end

    def bfs_find_path(target_pos)
        @considered_pos = [@start_pos]
        build_move_tree
        trace_path_back(@root.bfs(target_pos))
    end

    def dfs_find_path(target_pos) # [5,5]
        @considered_pos = [@start_pos]
        build_move_tree
        trace_path_back(@root.dfs(target_pos))
    end

end

#k = KnightPathFinder.new([0,0])
#p k.new_move_positions([1,2])
#p k.build_move_tree()

kpf2 = KnightPathFinder.new([0, 0])
p kpf2.dfs_find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf2.bfs_find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]