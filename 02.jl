function day02(file="02.input")
    input = map(eachline(file)) do line
        a, b, c, _, d = split(line, ['-', ' ', ':'])
        (parse(Int, a), parse(Int, b), first(c), d)
    end

    part1 = count(((a,b,c,d),) -> count(x -> x == c, d) ∈ a:b, input)
    part2 = count(((a,b,c,d),) -> (c == d[a]) ⊻ (c == d[b]), input)

    return part1, part2
end
