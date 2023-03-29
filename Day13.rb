nums = File.open("./inputs/13.txt").read.split(",").map(&:to_i)

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
output = []
outputs = []
total_blocks = 0
until output.any?{|x| x.nil?} do
    output.clear
    for i in 1..3
        output.push(m.eval(nil))
    end
    total_blocks += 1 if output[2] == 2
    outputs.push(output.clone)
end
puts(total_blocks)