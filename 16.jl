function day16(file="16.input")
    input = readlines(file)
    rules = input[1:20] .|> line -> parse.(Int, match(r"^[\w ]+: (\d+)-(\d+) or (\d+)-(\d+)$", line).captures)
    mine = parse.(Int, split(input[23], ','))
    nearby = input[26:end] .|> line -> parse.(Int, split(line, ','))

    part1 = sum(ticket -> sum(n -> n * !any(((a₋,a₊,b₋,b₊),) -> a₋ ≤ n ≤ a₊ || b₋ ≤ n ≤ b₊, rules), ticket), nearby)

    possible = fill(Set(1:length(mine)), length(rules))
    for ticket ∈ filter(ticket -> all(n -> any(((a₋,a₊,b₋,b₊),) -> a₋ ≤ n ≤ a₊ || b₋ ≤ n ≤ b₊, rules), ticket), nearby)
        for (i, n) ∈ enumerate(ticket), (j, (a₋,a₊,b₋,b₊)) ∈ enumerate(rules)
            if !(a₋ ≤ n ≤ a₊ || b₋ ≤ n ≤ b₊)
                possible[j] = setdiff(possible[j], i)
            end
        end
    end
    certain = Vector{Int}(undef, 20)
    for _ ∈ 1:length(possible)
        for (i, is) ∈ enumerate(possible)
            if length(is) == 1
                certain[i] = first(is)
            else
                possible[i] = setdiff(is, certain)
            end
        end
    end
    part2 = prod(mine[certain[1:6]])

    return part1, part2
end
