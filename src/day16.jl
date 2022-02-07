module Day16

using AdventOfCode2020
using SIMD: Vec

const FIELDS = 20

function solve(input::InputBuffer)
    part1, part2 = 0, 1

    @inbounds begin
        masks = zeros(Int32, 1000)
        for i ∈ 1:FIELDS
            iscolon = unsafe_peek(input, Vec{32, UInt8}) == ':' % UInt8
            len = trailing_zeros(bitmask(UInt32, iscolon))
            skip(input, len+2)

            mask = (1 << i) % Int32
            masks[unsafe_parse(Int, input)+1] += mask
            masks[unsafe_parse(Int, input)+2] -= mask
            skip(input, 3)
            masks[unsafe_parse(Int, input)+1] += mask
            masks[unsafe_parse(Int, input)+2] -= mask
        end
        cumsum!(masks, masks)

        skip(input, 14)

        ticket = Vector{Int}(undef, FIELDS)
        for i ∈ 1:FIELDS
            ticket[i] = unsafe_parse(Int, input)
        end

        skip(input, 17)

        valid = fill(-1 % Int32, FIELDS)
        nearby = Vector{Int}(undef, FIELDS)
        while !eof(input)
            for i ∈ 1:FIELDS
                nearby[i] = unsafe_parse(Int, input)
            end

            invalid = false

            for i ∈ 1:FIELDS
                n = nearby[i]
                invalid |= iszero(masks[n+1])
                part1 += n & -iszero(masks[n+1])
            end

            invalid && continue

            @simd for i ∈ 1:FIELDS
                n = nearby[i]
                valid[i] &= masks[n+1]
            end
        end

        mask = 0 % Int32
        for i ∈ sortperm(valid, by=count_ones)
            valid[i], mask = valid[i] ⊻ mask, valid[i]
            part2 *= trailing_zeros(valid[i]) ≤ 6 ? ticket[i] : 1
        end
    end

    return part1, part2
end

end # module
