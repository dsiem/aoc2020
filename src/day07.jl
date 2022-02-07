module Day07

using AdventOfCode2020
using Base: @propagate_inbounds
using SIMD: Vec

const SHINY_GOLD = 13 | 54 << 5

@propagate_inbounds function count_gold(bags_reverse, gold, bag=SHINY_GOLD)
    count = 0

    @inbounds len = bags_reverse.len[bag]
    @inbounds for i ∈ 1:len
        outer_bag = bags_reverse.data[i, bag] % Int

        gold[outer_bag] && continue
        gold[outer_bag] = true

        count += 1 + count_gold(bags_reverse, gold, outer_bag)
    end

    return count
end

@propagate_inbounds function count_bags(bags, bag=SHINY_GOLD)
    count = 1

    @inbounds len = bags.len[bag]
    @inbounds for i ∈ 1:len
        inner = bags.data[i, bag] % Int

        inner_bag = inner & (1 << 11 - 1)
        amount = inner >> 11

        count += amount * count_bags(bags, inner_bag)
    end

    return count
end

@inline function parse_bag(input::InputBuffer)::UInt16
    vec = unsafe_peek(input, Vec{32, UInt8})
    isspace = vec ≍ ' '

    attribute = unsafe_peek(input, UInt16) % 489 & 31 # TODO: improve hashing & use vec?

    len = trailing_zeros(isspace) + 1
    skip(input, len)

    color = unsafe_peek(input, UInt32) % 58739 & 63 # TODO: improve hashing & use vec?

    len = trailing_zeros(isspace >> len)
    skip(input, len)

    return attribute | color << 5 # TODO: leads to unsafe array access because it can be zero
end

function solve(input::InputBuffer)
    pad!(input, 0) # FIXME

    bags = VectorVector{4, 2048, UInt16}() # TODO: 2048 limit can be unsafely reduced to something close to 1850
    bags_reverse = VectorVector{24, 2048, UInt16}() # TODO: 24 limit is unsafe

    @inbounds while !eof(input) # TODO: unsafe @inbounds
        bag = parse_bag(input)

        skip(input, 14) # " bags contain "

        if unsafe_peek(input, UInt8) == 'n' % UInt8
            skip(input, 15) # "no other bags.\n"
        else
            while true
                amount = unsafe_peek(input, UInt8) & 0x000f

                skip(input, 2)

                inner_bag = parse_bag(input)
                push!(bags_reverse, inner_bag % Int, bag)
                inner_bag |= amount << 11
                push!(bags, bag % Int, inner_bag)

                skip(input, 4 | (amount > 1)) # " bag" or " bags"

                unsafe_read(input, UInt16) == 0x0a2e && break # ".\n"
            end
        end
    end

    gold = fill(false, 2048)
    @inbounds gold[SHINY_GOLD] = true

    part1 = count_gold(bags_reverse, gold)
    part2 = count_bags(bags) - 1

    return part1, part2
end

end # module
