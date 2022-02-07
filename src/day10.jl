module Day10

using AdventOfCode2020

# First few `tribonacci' numbers
const TRIB8 = (1, 1, 2, 4, 7, 13, 24, 44) # TODO: generate this dynamically

function solve(input::InputBuffer)
    len = 0 % UInt
    jolts = Vector{Int}(undef, length(input) ÷ 2)

    @inbounds while !eof(input) # TODO: refactor
        len += 1
        jolts[len] = unsafe_parse(Int, input)
    end

    resize!(jolts, len)

    push!(jolts, 0)
    sort!(jolts)
    push!(jolts, jolts[end])

    part2, consec, ones, threes = 1, 1, 0, 0

    for i ∈ 2:length(jolts)
        if jolts[i] - jolts[i-1] == 1
            ones += 1
            consec += 1
        else # all jolt differences are either 1 or 3
            part2 *= TRIB8[consec]
            threes += 1
            consec = 1
        end
    end

    part1 = ones * threes

    return part1, part2
end

end # module
