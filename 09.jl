function day09(file="09.input", preamble=25)
    input = parse.(Int, readlines(file))

    part1 = findinvalid(input, preamble)
    part2 = weakness(input, part1)

    return part1, part2
end

function findinvalid(input, preamble)
    Iterators.filter(enumerate(input)) do (i,v)
        i > preamble && !any(x -> v-x ∈ input[i-preamble:i-1], input[i-preamble:i-2])
    end |> first |> last
end

function weakness(input, n)
    i, j, s = 1, 0, 0
    while s ≠ n
        if s < n
            j += 1
            s += input[j]
        else
            s -= input[i]
            i += 1
        end
    end
    minimum(input[i:j]) + maximum(input[i:j])
end
