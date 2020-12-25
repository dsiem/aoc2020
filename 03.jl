function day03(file="03.input")
    input = readlines(file)

    part1 = impacts(input, 3)
    part2 = part1 * prod(slope -> impacts(input, slope...), [1, 5, 7, [1, 2]])

    return part1, part2
end

function impacts(input, Δx, Δy=1)
    sum(enumerate(input[1:Δy:end])) do (i, line)
        line[mod1(1+Δx*(i-1), length(line))] == '#'
    end
end
