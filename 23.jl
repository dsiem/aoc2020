function day23(input="137826495")
    seed = Vector{Int}(undef, length(input))
    fst = prev = parse(Int, input[1])
    for c ∈ input[2:end]
        seed[prev] = parse(Int, c)
        prev = seed[prev]
    end

    cups1 = copy(seed)
    cups1[prev] = curr = fst
    for _ ∈ 1:100
        curr = move!(cups1, curr)
    end

    part1 = 0
    n = 1
    for _ ∈ 2:length(cups1)
        n = cups1[n]
        part1 = 10*part1 + n
    end

    cups2 = vcat(seed, [n+1 for n ∈ 10:1_000_000])
    cups2[prev] = 10
    cups2[end] = curr = fst
    for _ ∈ 1:10_000_000
        curr = move!(cups2, curr)
    end
    part2 = cups2[1] * cups2[cups2[1]]

    return part1, part2
end

function move!(cups, curr)
    fst = cups[curr]
    snd = cups[fst]
    trd = cups[snd]
    cups[curr] = cups[trd]

    dest = curr
    while dest ∈ (curr, fst, snd, trd) # don't use [curr, fst, snd, trd] here!
        dest -= 1
        if dest == 0
            dest = length(cups)
        end
    end

    cups[trd] = cups[dest]
    cups[dest] = fst

    return cups[curr]
end
