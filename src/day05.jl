module Day05

using AdventOfCode2020
using SIMD: Vec

#=
Calculates the cumulative XOR of the numbers 1 to n, based on the observation that

    cumxor(0)    = 0
    cumxor(4n+1) = 1
    cumxor(4n+2) = 4n+3
    cumxor(4n+3) = 0
    cumxor(4n+4) = 4n+4
=#
cumxor(n) = (n & ((n << 1 & 2) - 1)) ⊻ (n >> 1 & 1)

function solve(input::InputBuffer)
    allmin = -1 % UInt
    allmax =  0 % UInt
    allxor =  0 % UInt

    while !eof(input)
        # Read 3 lines at the same time as each line contains 10 characters.
        # Bytes 11 and 22 are newline characters.
        three = unsafe_read(input, Vec{32, UInt8})
        skip(input, 1)

        mask = ((three ≍ 'B') | (three ≍ 'R')) % UInt32 |> bitreverse

        seat₁ = mask       & 0x03ff # bits  1-10 -> 1st line
        seat₂ = mask >> 11 & 0x03ff # bits 12-21 -> 2nd line
        seat₃ = mask >> 22          # bits 23-32 -> 3rd line

        allmin = min(allmin, seat₁, seat₂, seat₃)
        allmax = max(allmax, seat₁, seat₂, seat₃)
        allxor = xor(allxor, seat₁, seat₂, seat₃)
    end

    part1 = allmax                                       % Int
    part2 = (allxor ⊻ cumxor(allmin-1) ⊻ cumxor(allmax)) % Int

    return part1, part2
end

end # module
