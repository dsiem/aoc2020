using Combinatorics

function day01(file="01.input")
    input = parse.(Int, readlines(file))

    # Part 1 & 2
    for n in [2,3]
        Iterators.filter(xs -> sum(xs) == 2020, combinations(input, n)) |> first |> prod |> println
    end
end
