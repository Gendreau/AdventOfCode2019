class Graph
    def initialize()   
        @maze = File.open("./inputs/20.txt").map{|ln| ln.chomp.split(//)}
        @start_end = {}
        test_mod = 36
        @score_mod = 7500
        @other_thing = false
        for i in 0..@maze.length-1
            for j in 0..@maze[i].length-1
                begin
                    if @maze[i][j] != "#" and @maze[i][j] != "." and @maze[i][j] != " " and @maze[i][j].length == 1
                        second = [[i,j+1],[i+1,j+1],[i+1,j],[i+1,j-1],[i,j-1],[i-1,j-1],[i-1,j],[i-1,j+1]]
                        for pair in second
                            if @maze[pair[0]][pair[1]] != "#" and @maze[pair[0]][pair[1]] != "." and @maze[pair[0]][pair[1]] != " " and @maze[pair[0]][pair[1]].length == 1
                                combined = @maze[i][j] > @maze[pair[0]][pair[1]] ? (@maze[i][j]+@maze[pair[0]][pair[1]]) : (@maze[pair[0]][pair[1]]+@maze[i][j])
                                if i < 3 or (@maze.length-test_mod < i and i < @maze.length-3) or j < 3 or (@maze[0].length-test_mod < j and j < @maze[0].length-3)
                                    @maze[i][j] = " "
                                    @maze[pair[0]][pair[1]] = combined
                                    if @maze[pair[0]][pair[1]] == "AA" or @maze[pair[0]][pair[1]] == "ZZ"
                                        @start_end[@maze[pair[0]][pair[1]]] = find_adjacent(pair[0],pair[1])
                                    end
                                else
                                    @maze[i][j] = combined
                                    @maze[pair[0]][pair[1]] = " "
                                    if @maze[i][j] == "AA" or @maze[i][j] == "ZZ"
                                        @start_end[@maze[pair[0]][pair[1]]] = find_adjacent(combined[k][0],combined[k][1])
                                    end
                                end
                                break
                            end
                        end
                    end
                rescue
                end
            # print(@maze[i][j])
            end
            # puts("")
        end
        if @other_thing
            init_paths()
        else
            cache()
        end
    end

    def traverse()
        xs, ys = [0,0,-1,1], [1,-1,0,0]
        visited = [@start_end["AA"]]
        steps = 0
        queue = [[@start_end["AA"][0],@start_end["AA"][1],0]]
        while queue.any?
            pos = queue.pop
            escape = false
            if pos[0,2] == @start_end["ZZ"]
                steps = pos[2]
                break
            end
            for dir in 0..3
                next_pos = [pos[0]+ys[dir],pos[1]+xs[dir]].clone
                if !visited.include?(next_pos) and @maze[next_pos[0]][next_pos[1]] != "#" and @maze[next_pos[0]][next_pos[1]] != " " and @maze[next_pos[0]][next_pos[1]] != "AA" and @maze[next_pos[0]][next_pos[1]] != "ZZ"
                    if @maze[next_pos[0]][next_pos[1]] != "."
                        visited.push(next_pos.clone)
                        for i in 0..@maze.length-1
                            for j in 0..@maze[i].length-1
                                if @maze[i][j] == @maze[next_pos[0]][next_pos[1]] and (i != next_pos[0] or j != next_pos[1])
                                    visited.push([i,j])
                                    next_pos = find_adjacent(i,j)
                                    escape = true
                                    break
                                end
                            end
                            break if escape
                        end
                    end
                    visited.push(next_pos.clone)
                    next_pos.push(pos[2]+1)
                    queue.push(next_pos.clone)
                end
            end
        end
        return steps
    end

    def traverse_nw(start, end_)
        xs, ys = [0,0,-1,1], [1,-1,0,0]
        visited = [@warp_locs[start]]
        steps = 0
        queue = [[@warp_locs[start][0],@warp_locs[start][1],0]]
        while queue.any?
            pos = queue.pop
            escape = false
            if pos[0,2] == @warp_locs[end_]
                steps = pos[2]
                break
            end
            for dir in 0..3
                next_pos = [pos[0]+ys[dir],pos[1]+xs[dir]]
                if !visited.include?(next_pos) and @maze[next_pos[0]][next_pos[1]] == "."
                    visited.push(next_pos.clone)
                    next_pos.push(pos[2]+1)
                    queue.push(next_pos.clone)
                end
            end
        end
        return steps
    end

    def traverse_recursive()
        queue = [["AA", 0, 0]]
        @shortest = 999999
        while queue.any?
            pos = queue.pop
            pos[2] += 1
            if pos[1] == 0 and @warp_connections[pos[0]].include?("ZZ")
                @shortest = [@shortest, pos[2] + @connector_lengths[[pos[0],"ZZ"]]].min
            end
            for connector in @warp_connections[pos[0]]
                if connector[2] == 'O' and pos[1] > 0 and pos[2] < @score_mod
                    rep = connector[0,2] + "I"
                    queue.push([rep, pos[1]-1, pos[2] + @connector_lengths[[pos[0],connector]]])
                elsif connector[2] == "I" and pos[1] < 100 and pos[2] < @score_mod
                    rep = connector[0,2] + "O"
                    queue.push([rep, pos[1]+1, pos[2] + @connector_lengths[[pos[0],connector]]])
                end
            end
        end 
        return @shortest - 1
    end

    def cache()
        @warp_connections = {"AA"=>["XPO", "TAI"], "ZMO"=>["NMO", "ZWI", "CAI"], "NMO"=>["ZMO", "ZWI", "CAI"], "SOO"=>["XPI"], "KIO"=>["VPI"], "XPO"=>["TAI"], "YNO"=>["ZZ", "HHI"], "TEO"=>["XQI"], "ZWI"=>["ZMO", "NMO", "CAI"], "CAI"=>["ZMO", "NMO", "ZWI"], "XPI"=>["SOO"], "VPI"=>["KIO"], "TAI"=>["XPO"], "HHI"=>["ZZ", "YNO"], "XQI"=>["TEO"], "VEI"=>["VIO"], "WQI"=>["HHO"], "VIO"=>["VEI"], "HHO"=>["WQI"], "NAO"=>["UCI"], "UCI"=>["NAO"], "TAO"=>["WNI"], "WNI"=>["TAO"], "CAO"=>["KII"], "KII"=>["CAO"], "WQO"=>["SHI"], "SHI"=>["WQO"], "KGO"=>["VII"], "VII"=>["KGO"], "SHO"=>["XSI"], "XSI"=>["SHO"], "ZUO"=>["KGI"], "PEI"=>["ZXO"], "KGI"=>["ZUO"], "WRO"=>["ZUI"], "ZXO"=>["PEI"], "ZUI"=>["WRO"], "NAI"=>["XQO"], "XQO"=>["NAI"], "ZMI"=>["WNO"], "WNO"=>["ZMI"], "TEI"=>["ZWO"], "YNI"=>["MHO"], "WRI"=>["XSO"], "SOI"=>["VPO"], "MHI"=>["UCO"], "ZXI"=>["VEO"], "NMI"=>["PEO"], "ZWO"=>["TEI"], "MHO"=>["YNI"], "XSO"=>["WRI"], "VPO"=>["SOI"], "UCO"=>["MHI"], "VEO"=>["ZXI"], "PEO"=>["NMI"]}
        @connector_lengths = {["AA", "XPO"]=>4, ["YNO", "ZZ"]=>16, ["AA", "TAI"]=>48, ["HHI", "ZZ"]=>60, ["ZMO", "NMO"]=>8, ["NMO", "ZMO"]=>8, ["ZMO", "ZWI"]=>44, ["ZWI", "ZMO"]=>44, ["ZMO", "CAI"]=>46, ["CAI", "ZMO"]=>46, ["NMO", "ZWI"]=>46, ["ZWI", "NMO"]=>46, ["NMO", "CAI"]=>48, ["CAI", "NMO"]=>48, ["SOO", "XPI"]=>48, ["XPI", "SOO"]=>48, ["KIO", "VPI"]=>62, ["VPI", "KIO"]=>62, ["XPO", "TAI"]=>50, ["TAI", "XPO"]=>50, ["YNO", "HHI"]=>46, ["HHI", "YNO"]=>46, ["TEO", "XQI"]=>54, ["XQI", "TEO"]=>54, ["ZWI", "CAI"]=>8, ["CAI", "ZWI"]=>8, ["VEI", "VIO"]=>54, ["VIO", "VEI"]=>54, ["WQI", "HHO"]=>58, ["HHO", "WQI"]=>58, ["NAO", "UCI"]=>52, ["UCI", "NAO"]=>52, ["TAO", "WNI"]=>58, ["WNI", "TAO"]=>58, ["CAO", "KII"]=>42, ["KII", "CAO"]=>42, ["WQO", "SHI"]=>74, ["SHI", "WQO"]=>74, ["KGO", "VII"]=>48, ["VII", "KGO"]=>48, ["SHO", "XSI"]=>46, ["XSI", "SHO"]=>46, ["ZUO", "KGI"]=>54, ["KGI", "ZUO"]=>54, ["PEI", "ZXO"]=>66, ["ZXO", "PEI"]=>66, ["WRO", "ZUI"]=>48, ["ZUI", "WRO"]=>48, ["NAI", "XQO"]=>72, ["XQO", "NAI"]=>72, ["ZMI", "WNO"]=>52, ["WNO", "ZMI"]=>52, ["TEI", "ZWO"]=>62, ["ZWO", "TEI"]=>62, ["YNI", "MHO"]=>40, ["MHO", "YNI"]=>40, ["WRI", "XSO"]=>62, ["XSO", "WRI"]=>62, ["SOI", "VPO"]=>36, ["VPO", "SOI"]=>36, ["MHI", "UCO"]=>72, ["UCO", "MHI"]=>72, ["ZXI", "VEO"]=>60, ["VEO", "ZXI"]=>60, ["NMI", "PEO"]=>48, ["PEO", "NMI"]=>48}
    end

    def init_paths()
        @warp_locs = {}
        @warp_coords = {}
        @connector_lengths = {}
        @warp_connections = {}
        for i in 0..@maze.length-1
            for j in 0..@maze[i].length-1
                if @maze[i][j] != "." and @maze[i][j] != " " and @maze[i][j] != "#" and @maze[i][j] != "AA" and @maze[i][j] != "ZZ"
                    if in_out(i,j) == true
                        str = @maze[i][j] + "O"
                        @warp_locs[str] = find_adjacent(i,j)
                        if @warp_locs.keys.include?(@maze[i][j] + "I")
                            @warp_coords[str] = find_adjacent(@warp_locs[@maze[i][j]+"I"][0], @warp_locs[@maze[i][j]+"I"][1])
                            @warp_coords[@maze[i][j]+"I"] = find_adjacent(@warp_locs[str][0],@warp_locs[str][1])
                        end
                        @maze[i][j] = str
                    else
                        str = @maze[i][j] + "I"
                        @warp_locs[str] = find_adjacent(i,j)
                        if @warp_locs.keys.include?(@maze[i][j]+"O")
                            @warp_coords[str] = find_adjacent(@warp_locs[@maze[i][j]+"O"][0],@warp_locs[@maze[i][j]+"O"][1])
                            @warp_coords[@maze[i][j]+"O"] = find_adjacent(@warp_locs[str][0],@warp_locs[str][1])
                        end
                        @maze[i][j] = str
                    end
                elsif @maze[i][j] == "AA" or @maze[i][j] == "ZZ"
                    @warp_locs[@maze[i][j]] = find_adjacent(i,j)
                end
            end
        end
        @warp_connections["AA"] = []
        for key in @warp_locs.keys
            if key != "AA" and key != "ZZ"
                @warp_connections[key] = []
                dist1 = traverse_nw("AA", key)
                dist2 = traverse_nw("ZZ", key)
                if dist1 > 0
                    @warp_connections["AA"].push(key)
                    @connector_lengths[["AA",key]] = dist1
                end
                if dist2 > 0 
                    @warp_connections[key].push("ZZ")
                    @connector_lengths[[key,"ZZ"]] = dist2
                end
            end
        end
        for start in @warp_locs.keys
            for end_ in @warp_locs.keys
                if  start != "AA" and start != "ZZ" and end_ != "AA" and end_ != "ZZ" and start != end_ and !@warp_connections[start].include?(end_)
                    dist = traverse_nw(start, end_)
                    if dist > 0
                        @warp_connections[start].push(end_)
                        @warp_connections[end_].push(start)
                        @connector_lengths[[start,end_]] = dist
                        @connector_lengths[[end_,start]] = dist
                    end
                end
            end
        end
    end

    def find_adjacent(i, j)
        adj = [[i,j+1],[i,j-1],[i+1,j],[i-1,j]]
        for a in adj
            if @maze[a[0]][a[1]] == "."
                return a
                break
            end
        end
    end

    def in_out(i, j)
        return (i < 3 or i > @maze.length-3 or j < 3 or j > @maze[0].length-3)
    end
end

g = Graph.new()
puts g.traverse()
puts g.traverse_recursive()
