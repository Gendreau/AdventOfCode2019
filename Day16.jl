nums = [parse(Int, x) for x in (readuntil(open("./inputs/16.txt"),"\n"))]
isPartOne = false
phases = 100
if isPartOne
    pattern = [0,1,0,-1]
    for phase in 1:phases
        output = copy(nums)
        for i in eachindex(nums)
            output[i] = abs(sum(nums[k] for k in 1:length(nums) if i <= k%(4*i) < 2*i; init=0) - sum(nums[k] for k in 1:length(nums) if 3*i <= k%(4*i) < 4*i; init=0))%10
        end
        global nums = copy(output)
    end
    print(nums)
else
    offset = sum(nums[i]*10^(7-i) for i in 1:7)
    start = offset % length(nums) + 1
    nums_mod = copy(nums[start:end])
    magic_number = ((10000 * length(nums) - offset) ÷ length(nums))
    for i in 1:magic_number
       global nums_mod = [nums_mod;copy(nums)]
    end
    for phase in 1:phases
        for i in reverse(1:length(nums_mod)-1)
            nums_mod[i] = (nums_mod[i]+nums_mod[i+1])%10
        end
    end
    print(sum(nums_mod[i]*10^(8-i) for i in 1:8))
end
