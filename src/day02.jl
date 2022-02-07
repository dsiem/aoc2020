module Day02

using AdventOfCode2020
using SIMD: Vec

function solve(input::InputBuffer)
    pad!(input, 31)

    part1, part2 = 0, 0

    while !eof(input)
        lo = unsafe_parse(UInt8, input)
        hi = unsafe_parse(UInt8, input)

        char = unsafe_peek(input, UInt8)
        skip(input, 2)
        pass = unsafe_peek(input, Vec{32, UInt8})

        len = trailing_zeros(pass ≍ '\n')
        skip(input, len + 1)

        matches = (pass ≍ char) & (1 << len - 1)

        part1 += count_ones(matches) % UInt8 ∈ lo:hi
        part2 += 1 & ((matches >> lo) ⊻ (matches >> hi))
    end

    return part1, part2
end

end # module
