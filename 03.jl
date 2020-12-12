function day03(file="03.input")
    input = readlines(file)

    part1 = impacts(input, 3)
    part2 = prod(slope -> impacts(input, slope...), [1, 3, 5, 7, [1, 2]])

    return part1, part2
end

function impacts(input, right, down=1)
    sum(((i, line),) -> line[mod(right*(i-1), length(line)) + 1] == '#', enumerate(input[1:down:end]))
end
