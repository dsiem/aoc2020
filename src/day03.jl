module Day03

using AdventOfCode2020
using SIMD: Vec

function impacts(trees, Δx, Δy=1)
    hits = 0
    shift = 0 % UInt # better for >> to use unsigned integers

    @inbounds for i ∈ 1:Δy:length(trees)
        hits += 1 & (trees[i] >> shift)
        shift += Δx
        if shift ≥ 31 # wrap around after 31 characters, 32nd is \n
            shift -= 31
        end
    end

    return hits
end

# TODO: too slow
function solve(input::InputBuffer)
    trees = [unsafe_read(input, Vec{32, UInt8}) ≍ '#' for _ ∈ 1:32:length(input)]

    #= slightly faster alternative
    trees = Vector{UInt32}(undef, length(input) >> 5)
    for i ∈ eachindex(trees)
        @inbounds trees[i] = unsafe_read(input, Vec{32, UInt8}) ≍ '#'
    end
    =#

    part1 = impacts(trees, 3)
    part2 = part1 * impacts(trees, 1) * impacts(trees, 5) * impacts(trees, 7) *
        impacts(trees, 1, 2)

    return part1, part2
end

end # module
