function day05(file="05.input")
    input = map(line -> parse(Int, map(c -> c ∈ ['B', 'R'] ? '1' : '0', line), base=2), eachline(file))

    # Part 1
    maximum(input) |> println

    # Part 2
    setdiff(minimum(input):maximum(input), input) |> first |> println
end
