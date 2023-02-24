using Meshes

f = open("./inputs/3.txt", "r")
array = []
for line in readlines(f)
    subarray = split(line, ",")
    modsubarray = []
    for mov in subarray
        subsubarray = [mov[1],parse(Int32,mov[2:end])]
        push!(modsubarray, subsubarray)
    end
    push!(array,modsubarray)
end

dir = Dict('L'=>(-1,0),'R'=>(1,0),'U'=>(0,1),'D'=>(0,-1))
wires = []

for line in array
    loc = (0,0)
    lines = []
    for mov in line
        newcoords = (loc[1]+(mov[2]*dir[mov[1]][1]),loc[2]+(mov[2]*dir[mov[1]][2]))
        push!(lines,Segment(loc,newcoords))
        loc = newcoords
    end
    push!(wires,lines)
end

intersections = []
intersection_dist = []
len_one = 0

for (i, line) in enumerate(wires[1])
    len_two = 0
    for (j, otherline) in enumerate(wires[2])
        if hasintersect(line, otherline) && line ∩ otherline != Point(0.0,0.0)
            push!(intersections,line ∩ otherline)
            seg_one = length(Segment(line ∩ otherline,line.vertices[1]))
            seg_two = length(Segment(line ∩ otherline,otherline.vertices[1]))
            push!(intersection_dist,len_one + len_two + seg_one + seg_two)
        end
        len_two += array[2][j][2]
    end
    global len_one += array[1][i][2]
end

min_dist = 999999
for point in intersections
    global min_dist = min(min_dist, abs(coordinates(point)[1])+abs(coordinates(point)[2]))
end

println("Minimum distance to intersection: ", min_dist)
println("Minimum steps to intersection: ", minimum(intersection_dist))
close(f)