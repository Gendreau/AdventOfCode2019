class Factory
    def initialize()
        f = File.open("./inputs/14.txt").readlines
        @formulae = {}
        for line in f
            array = line.strip.split(/[ -,]+/)
            formula = {}
            i = 0
            until array[i] == '=>'
                formula[array[i+1]] = array[i].to_f
                i += 2
            end
            @formulae[array[-1]] = [array[-2].to_f, formula]
        end
        @totals = {"ORE" => 0}
        for k in @formulae.keys
            @totals[k] = 0
        end
    end

    def produce(key)
        if @formulae[key][1].key?("ORE")
            @totals[key] += @formulae[key][0]
            @totals["ORE"] += @formulae[key][1]["ORE"]
        elsif @formulae[key][1].keys.all?{|x| @totals[x] >= @formulae[key][1][x]}
            for k in @formulae[key][1].keys
                @totals[k] -= @formulae[key][1][k]
            end
            @totals[key] += @formulae[key][0]
            return
        else
            for k in @formulae[key][1].keys
                if @formulae[key][1][k] > @totals[k]
                    until @totals[k] >= @formulae[key][1][k]
                        produce(k)
                    end
                end
            end
            produce(key)
        end
    end

    def produce_exact(key, amt)
        if @formulae[key][1].key?("ORE")
            @totals[key] += amt
            @totals["ORE"] += @formulae[key][1]["ORE"]/@formulae[key][0]*amt
        elsif @formulae[key][1].keys.all?{|x| @totals[x] >= @formulae[key][1][x]/@formulae[key][0]*amt}
            for k in @formulae[key][1].keys
                @totals[k] -= @formulae[key][1][k]/@formulae[key][0]*amt
            end
            @totals[key] += amt
            return
        else
            for k in @formulae[key][1].keys
                if @formulae[key][1][k]/@formulae[key][0]*amt > @totals[k]
                    until @totals[k] >= @formulae[key][1][k]/@formulae[key][0]*amt
                        produce_exact(k, @formulae[key][1][k]/@formulae[key][0]*amt-totals[k])
                    end
                end
            end
            produce_exact(key, amt)
        end
    end

    def totals
        @totals
    end
end

p1 = Factory.new()
p2 = Factory.new()
p1.produce("FUEL")
p2.produce_exact("FUEL",1.0)
puts p1.totals["ORE"].floor
#I'm one away from the answer by luck I guess
puts (1000000000000/p2.totals["ORE"]).floor-1