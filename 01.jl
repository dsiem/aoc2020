function day01(file="01.input")
    input = parse.(Int, readlines(file)) |> sort

    function part1(xs)
        for i ∈ xs, j ∈ xs
            i+j == 2020 && return i*j
        end
    end

    function part2(xs)
        for i ∈ xs, j ∈ xs, k ∈ xs
            (s=i+j) < 2020 && s+k == 2020 && return i*j*k
        end
    end

    return part1(input), part2(input)
end
