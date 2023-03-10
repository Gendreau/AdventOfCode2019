f = open("./inputs/6.txt", "r")
orbits = [split(line, ")") for line in readlines(f)]
orbits_dict = Dict()
for i in orbits
    if i[1] in keys(orbits_dict)
        push!(orbits_dict[i[1]], i[2])
    else
        orbits_dict[i[1]] = [i[2]]
    end
end

function traverse(orbits_dict, key, level, total)
    if key in keys(orbits_dict)
        total += level
        level += 1
        for k in orbits_dict[key]
            total = traverse(orbits_dict, k, level, total)
        end
    else
        total += level
    end
    return total
end

function find_santa(orbits_dict, key1, key2, path1, path2)
    for k in keys(orbits_dict)
        if key1 in orbits_dict[k]
            push!(path1, k)
        end
        if key2 in orbits_dict[k]
            push!(path2, k)
        end
    end
    if length(findall(x-> x in path1, path2)) > 0
        return ((findall(in(path1),path2)+findall(in(path2),path1))[1]-2)
    else
        find_santa(orbits_dict, last(path1), last(path2), path1, path2)
    end
end    

println(traverse(orbits_dict, "COM",0,0))
println(find_santa(orbits_dict, "YOU", "SAN", [], []))
