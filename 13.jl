function day13(file="13.input")
    input = readlines(file)
    t = part2 = parse(Int, input[1])
    Δt = 1
    w = (typemax(Int), 0)
    for (i, b) ∈ enumerate(split(input[2], ','))
        b == "x" && continue
        n = parse(Int, b)
        m = mod(-t, n)
        if w[1] > m
            w = m, n
        end
        while mod(part2+i, n) ≠ 0
            part2 += Δt
        end
        Δt *= n
    end
    part1 = prod(w)
    part2 += 1

    return part1, part2
end
