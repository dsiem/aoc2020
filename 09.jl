function day09(file="09.input", range=25)
    input = parse.(Int, readlines(file))

    # Part 1
    (n = part1(input, range)) |> println

    # Part 2
    println(part2(input, n))
end

function part1(input, range)
    Iterators.filter(enumerate(input)) do (i,v)
        i > range && !any(x -> v-x ∈ input[i-range:i-1], input[i-range:i-2])
    end |> first |> last
end

function part2(input, n)
    i, j, s = 1, 0, 0
    while s != n
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
