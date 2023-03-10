nums = split(read(open("./inputs/8.txt", "r"), String), "\n")
width, height = 25, 6
layers, sublayer = [], []
for (index, num) in enumerate(nums[1])
    push!(sublayer, parse(Int, num))
    if index % (width*height) == 0
        push!(layers, copy(sublayer))
        empty!(sublayer)
    end
end

zero_ct = []
for layer in layers
    push!(zero_ct, count(i -> (i==0), layer))
end
min_zeros = minimum(zero_ct)
min_index = findall(x -> x == min_zeros, zero_ct)[1]
println((count(i->(i==1), layers[min_index]))*((count(i->(i==2),layers[min_index]))))

display = []
for pixel in 1:width*height
    for layer in layers
        if layer[pixel] != 2
            push!(display, layer[pixel])
            break
        end
    end
end

for h in 0:height-1
    for w in 1:width
        print(display[width*h+w] == 0 ? " " : "■")
    end
    println()
end