class AsteroidBelt
    def initialize()
        f = File.open("./inputs/10.txt").readlines
        ast_map, @asts = for line in f do line.split("\S") end, []
        for i in 0..ast_map.length-1
            for j in 0..ast_map[0].length-1
                if ast_map[i][j] == "#" then @asts.push([j,i]) end
            end
        end
        @vaporized = []
        @map_length = ast_map.length
    end
    
    def seek()
        @max_visible = [0, [nil, nil]]
        @ms_covers = {}
        for ms in @asts
            covers = {}
            visible = 0
            for ast in @asts
                if ms != ast
                    origin = [ast[0]-ms[0],ast[1]-ms[1]]
                    angle = Math.atan2(origin[0],origin[1])
                    if !covers.keys.include?(angle)
                        visible += 1
                        covers[angle] = [ast]
                    else
                        covers[angle].push(ast)
                    end
                end
            end
            if visible > @max_visible[0]
                @max_visible = [visible, ms]
                @ms_covers = covers
            end
        end
        return @max_visible
    end

    def vaporizer()
        until @vaporized.length >= 200
            vaporize()
        end
        return @vaporized[199]
    end

    def vaporize()
        for cover in @ms_covers.keys.sort_by{|x| -x}
            to_vaporize = @ms_covers[cover].delete(@ms_covers[cover].max)
            @vaporized.push(to_vaporize)
            if @ms_covers[cover].length == 0 then @ms_covers.delete(cover) end
        end
    end
end

ab = AsteroidBelt.new()
puts ab.seek()[0]
print ab.vaporizer()