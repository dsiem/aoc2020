module Day15

using AdventOfCode2020
using Base: @propagate_inbounds

const YEAR  = 2020
const BREAK = 100_000
const LIMIT = 30_000_000

@propagate_inbounds function update!(mem::Vector{T}, n::Integer, i::Integer) where {T<:Integer}
    m = mem[n+1] == 0 ? 0 : i - mem[n+1]
    mem[n+1] = i % T

    return m
end

@propagate_inbounds function update!(mem::Vector{T}, bit::BitVector, n::Integer, i::Integer) where {T<:Integer}
    if bit[n+1]
        m = i - mem[n+1]
    else
        m = 0
        bit[n+1] = true
    end
    mem[n+1] = i % T

    return m
end

function solve(input::InputBuffer)
    mem = zeros(Int32, LIMIT)
    bit = falses(LIMIT)
    n = 0

    @inbounds begin
        len = 0
        while !eof(input)
            len += 1
            n = unsafe_parse(Int, input)
            mem[n+1] = len % Int32
        end

        for i ∈ len:YEAR-1
            n = update!(mem, n, i)
        end
        part1 = n

        for i ∈ YEAR:BREAK-1
            n = update!(mem, n, i)
        end

        for i ∈ BREAK:LIMIT-1
            if n < BREAK
                n = update!(mem, n, i)
            else
                n = update!(mem, bit, n, i)
            end
        end
        part2 = n
    end

    return part1, part2
end

end # module
