function day06(file="06.input")
    input = split(read(file, String), "\n\n")

    # Part 1
    mapreduce(length ∘ unique ∘ join ∘ split, +, input) |> println

    # Part 2
    mapreduce(length ∘ (x -> intersect(x...)) ∘ split, +, input) |> println
end
