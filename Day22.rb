require 'openssl'

# I stole code for part 2

class Deck
    def initialize(test)
        @p2size = 119315717514047
        @shuffles = 101741582076661
        if test
            f = File.open("./inputs/test.txt").readlines
        else
            f = File.open("./inputs/22.txt").readlines
        end
        num_cards = test ? 9 : 10006
        @instructions = []
        for line in f
            array = line.strip.split(" ")
            if array.include?("cut")
                @instructions.push(["cut", array[1].to_i])
            elsif array.include?("increment")
                @instructions.push(["inc", array[3].to_i])
            elsif
                @instructions.push(["stack"])
            end
        end
        @cards = []
        for i in 0..num_cards
            @cards.push(i)
        end
    end

    def shuffle()
        for inst in @instructions
            case inst[0]
            when "cut"
                @cards = @cards.rotate(inst[1])
            when "inc"
                inc(inst[1])
            when "stack"
                @cards = @cards.reverse()
            end
        end
        return @cards
    end

    def inc(n)
        deck_size = @cards.length
        inc_deck, ptr = [@cards.shift()], 0
        inc_deck[deck_size-1] = nil
        until !inc_deck.include?(nil)
            ptr += n
            if ptr >= deck_size
                ptr -= deck_size
            end
            inc_deck[ptr] = @cards.shift()
        end
        @cards = inc_deck.clone()
    end

    def beeg_shuffle()
        @inc_mul = 1
        @offset_diff = 0
        for inst in @instructions
            case inst[0]
            when "stack"
                @inc_mul *= -1
                @inc_mul %= @p2size
                @offset_diff += @inc_mul
                @offset_diff %= @p2size
            when "cut"
                @offset_diff += inst[1] * @inc_mul
                @offset_diff %= @p2size
            when "inc"
                @inc_mul *= ivn(inst[1])
                @inc_mul %= @p2size
            end
        end
    end

    def get_sequence()
        increment = @inc_mul.to_bn.mod_exp(@shuffles, @p2size)
        offset = @offset_diff * (1 - increment) * ivn((1 - @inc_mul) % @p2size)
        offset %= @p2size
        return increment, offset
    end

    def ivn(n)
        return n.to_bn.mod_exp(@p2size-2, @p2size)
    end

    def get_card(offset, increment, i)
        return (offset + i * increment) % @p2size
    end
end

d = Deck.new(false)
# d.shuffle().each_with_index do |card, idx|
#     if card == 2019
#         puts idx
#     end
# end
d.beeg_shuffle()
increment, offset = d.get_sequence()
print d.get_card(offset, increment, 2020)