function day12(file="12.input")
    input = map(eachline(file)) do line
        (line[1], parse(Int, line[2:end]))
    end

    dirs = Dict('E' => 1, 'N' => 1im, 'W' => -1, 'S' => -1im)
    rot = Dict('L' => 1im, 'R' => -1im)

    # Part 1
    pos = 0 + 0im
    dir = 1 + 0im
    for (op, n) in input
        if op ∈ keys(dirs)
            pos += n*dirs[op]
        elseif op ∈ keys(rot)
            dir *= rot[op]^(n÷90)
        else # op == 'F'
            pos += n*dir
        end
    end
    part1 = abs(real(pos)) + abs(imag(pos))

    # Part 2
    pos = 0 + 0im
    way = 10 + 1im
    for (op, n) in input
        if op ∈ keys(dirs)
            way += n*dirs[op]
        elseif op ∈ keys(rot)
            way *= rot[op]^(n÷90)
        else # op == 'F'
            pos += n*way
        end
    end
    part2 = abs(real(pos)) + abs(imag(pos))

    return part1, part2
end
