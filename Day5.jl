using Match

nums = [parse(Int, x) for x in split(read(open("./inputs/5.txt", "r"), String), ",")]

function eval(nums, index, input)
    opcode = nums[index] % 100
    if opcode == 99
        return nums
    end
    num_params = @match opcode begin
        1:2 => 3
        3:4 => 1
        5:6 => 2
        7:8 => 3
        _ => -1
    end
    param_mods = get_params(div(nums[index],100), num_params)
    if opcode == 1
        nums[nums[index+3]+1] = nums[get_index(nums,index+1,param_mods[1])] + nums[get_index(nums,index+2,param_mods[2])]
    elseif opcode == 2
        nums[nums[index+3]+1] = nums[get_index(nums,index+1,param_mods[1])] * nums[get_index(nums,index+2,param_mods[2])]
    elseif opcode == 3
        nums[nums[index+1]+1] = input
    elseif opcode == 4
        print(nums[get_index(nums,index+1,param_mods[1])])
    elseif opcode == 5 && nums[get_index(nums,index+1,param_mods[1])] != 0
        tmp = param_mods[2] == 0 ? nums[nums[index+2]+1] : nums[index+2]
        return eval(nums,tmp+1,input)
    elseif opcode == 6 && nums[get_index(nums,index+1,param_mods[1])] == 0
        tmp = param_mods[2] == 0 ? nums[nums[index+2]+1] : nums[index+2]
        return eval(nums,tmp+1,input) 
    elseif opcode == 7
        nums[nums[index+3]+1] = nums[get_index(nums,index+1,param_mods[1])] < nums[get_index(nums,index+2,param_mods[2])] ? 1 : 0
    elseif opcode == 8
        nums[nums[index+3]+1] = nums[get_index(nums,index+1,param_mods[1])] == nums[get_index(nums,index+2,param_mods[2])] ? 1 : 0
    end
    
    if nums[index] % 100 == opcode
        return eval(nums, index+num_params+1, input)
    else
        return eval(nums, index, input)
    end
end

function get_params(num, num_params)
    params = digits(num)
    while length(params) < num_params
        push!(params, 0)
    end
    return params
end

function get_index(nums, index, param)
    if param == 0
        return nums[index]+1
    else
        return index
    end
end

eval(copy(nums),1,5)
