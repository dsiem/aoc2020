function day05(file="05.input")
    input = map(line -> parse(Int, map(c -> c ∈ ['B', 'R'] ? '1' : '0', line), base=2), eachline(file))

    part1 = maximum(input)
    part2 = setdiff(minimum(input):maximum(input), input) |> first
    
    return part1, part2
end
