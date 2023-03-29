nums = File.open("./inputs/11.txt").read.split(",").map(&:to_i)
isPartOne = false

class Machine
    def initialize(code)
        @code = code
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

m = Machine.new(nums.clone)
pos = [0,0]
white_panels, painted_panels = [], []
if not isPartOne 
    white_panels.push(pos.clone)
end
xs, ys, dir = [0,1,0,-1], [1,0,-1,0], 0
output = white_panels.include?(pos) ? m.eval([1]) : m.eval([0])
until output.nil? do
    if output == 0
        white_panels.delete(pos)
    elsif output == 1
        white_panels.push(pos.clone) unless white_panels.include?(pos)
        painted_panels.push(pos.clone)
    end
    output = m.eval(nil)
    if output == 0
        dir = dir != 0 ? dir-1 : 3
    elsif output == 1
        dir = dir != 3 ? dir+1 : 0
    end
    pos[0] += xs[dir]
    pos[1] += ys[dir]
    output = white_panels.include?(pos) ? m.eval([1]) : m.eval([0])
end
if isPartOne
    puts painted_panels.uniq.length
else
    grid, gridlet = [], []
    for i in 0..40
        gridlet.push('⬛')
    end
    for i in 0..5
        grid.push(gridlet.clone)
    end
    for loc in white_panels
        grid[-loc[1]][loc[0]] = '⬜'
    end
    for line in grid
        for unit in line
            print(unit)
        end
        print("\n")
    end
end