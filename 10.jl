using IterTools

function day10(file="10.input")
    input = parse.(Int, readlines(file)) |> sort
    prepend!(input, 0)
    append!(input, input[end]+3)
    diffs = diff(input)
    
    part1 = count(diffs .== 1) * count(diffs .== 3)
    part2 = prod(first(g) ≠ 1 || trib(length(g)+2) for g ∈ groupby(first, diffs)) # uses that differences are 1 or 3, never 2

    return part1, part2
end

# Tribonacci numbers
# trib(n+2) = number of compositions of n with parts 1, 2 and 3
function trib(n::Integer)
    n < 2  && return 0
    n == 2 && return 1 
    return trib(n-3) + trib(n-2) + trib(n-1)
end
