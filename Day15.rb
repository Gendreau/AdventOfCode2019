class Machine
    def initialize()
        @code = File.open("./inputs/15.txt").read.split(",").map(&:to_i)
        @index = 0
        @rel_base = 0
    end
    def eval(input)
        while true do
            opcode = @code[@index] % 100

            if opcode == 99
                return nil
            end

            case opcode
            when 1..2
                num_params = 3
            when 3..4
                num_params = 1
            when 5..6
                num_params = 2
            when 7..8
                num_params = 3
            when 9
                num_params = 1
            else
                num_params = -1
            end

            param_mods = get_params(@code[@index].div(100), num_params)
            
            case opcode
            when 1
                @code[get_index(@index+3,param_mods[2])] = @code[get_index(@index+1,param_mods[0])] + @code[get_index(@index+2,param_mods[1])]
            when 2
                @code[get_index(@index+3,param_mods[2])] = @code[get_index(@index+1,param_mods[0])] * @code[get_index(@index+2,param_mods[1])]
            when 3
                @code[get_index(@index+1,param_mods[0])] = input.pop
            when 4
                @index += 2
                return @code[get_index(@index-1,param_mods[0])]
            when 5
                if @code[get_index(@index+1,param_mods[0])] != 0
                   @index = @code[get_index(@index+2,param_mods[1])]
                   redo 
                end
            when 6
                if @code[get_index(@index+1,param_mods[0])] == 0
                    @index = @code[get_index(@index+2,param_mods[1])]
                    redo
                end
            when 7
                @code[get_index(@index+3,param_mods[2])] = @code[get_index(@index+1, param_mods[0])] < @code[get_index(@index+2, param_mods[1])] ? 1 : 0
            when 8
                @code[get_index(@index+3,param_mods[2])] = @code[get_index(@index+1, param_mods[0])] == @code[get_index(@index+2, param_mods[1])] ? 1 : 0
            when 9
                @rel_base += @code[get_index(@index+1,param_mods[0])]
            end

            if @code[@index] % 100 == opcode
                @index += num_params+1
            end
        end
    end

    def get_params(num, num_params)
        params = num.digits
        while params.length < num_params
            params.push(0)
        end
        return params
    end

    def get_index(idx, param)
        case param
        when 0
            return @code[idx]
        when 1
            return idx
        when 2
            return @code[idx] + @rel_base
        end
    end
end

class Graph
    def initialize()
        @m = Machine.new()
        @walls, @visited = [], []
        @xs, @ys = [0,0,-1,1], [1,-1,0,0]
        @bws = [2,1,4,3]
    end
    
    def traverse(pos, prev)
        @visited.push(pos)
        for dir in 1..4
            next_pos = [pos[0]+@xs[dir-1],pos[1]+@ys[dir-1]]
            if !@visited.include?(next_pos)
                case @m.eval([dir])
                when 0
                    @walls.push(next_pos)
                    @visited.push(next_pos)
                    next
                when 2
                    @oxy = next_pos
                end
                traverse(next_pos, dir)
            end
        end
        @m.eval([@bws[prev-1]])
        return
    end

    def gen_maze()
        xoff, yoff = 21, 19
        @grid, gridlet = [], [], []
        for i in 0..40
            gridlet.push('.')
        end
        for i in 0..40
            @grid.push(gridlet.clone)
        end
        for loc in @walls
            @grid[loc[1]+yoff][loc[0]+xoff] = '#'
        end
        @grid[@oxy[1]+yoff][@oxy[0]+xoff] = 'E'
        @grid[yoff][xoff] = 'S'
        @dest = [@oxy[0]+xoff,@oxy[1]+yoff]
        @src = [xoff,yoff]
    end

    def print_maze()
        for line in @grid
            for unit in line
                print(unit)
            end
            print("\n")
        end
    end

    def shortest_path(part)
        start = part == 1 ? @src.clone : @dest.clone
        @dist = 0
        @visited = [start]
        queue = [[start[0], start[1], 0]]
        while queue.any?
            pos = queue.pop
            if part == 1 and pos[0,2] == @dest
                @dist = pos[2]
                break
            elsif part == 2
                @dist = [pos[2], @dist].max
            end

            for dir in 0..3
                next_pos = [pos[0]+@xs[dir],pos[1]+@ys[dir]]
                if !(@visited.include?(next_pos)) and @grid[next_pos[1]][next_pos[0]] != '#'
                    @visited.push(next_pos.clone)
                    next_pos.push(pos[2]+1)
                    queue.push(next_pos.clone)
                end
            end
        end
    end

    def dist
        @dist
    end

    def time
        @time
    end
end

g = Graph.new()
g.traverse([0,0],1)
g.gen_maze()
g.shortest_path(1)
puts g.dist
g.shortest_path(2)
puts g.dist