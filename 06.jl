function day06(file="06.input")
    input = split(read(file, String), "\n\n")

    part1 = sum(length ∘ unique ∘ join ∘ split, input)
    part2 = sum(length ∘ (x -> intersect(x...)) ∘ split, input)

    return part1, part2
end
