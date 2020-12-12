using Combinatorics

function day01(file="01.input")
    input = parse.(Int, readlines(file))

    part1 = Iterators.filter(xs -> sum(xs) == 2020, combinations(input, 2)) |> first |> prod
    part2 = Iterators.filter(xs -> sum(xs) == 2020, combinations(input, 3)) |> first |> prod

    return part1, part2
end
