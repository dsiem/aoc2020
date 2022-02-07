module Day08

using AdventOfCode2020

struct Instruction
    acc::Int
    jmp::Int
    nop::Int
end

function run(program, length)
    visited = zeros(Bool, length)
    alternates = Vector{Tuple{Int, Int}}(undef, length)

    acc, idx, alt = 0, 1, 1

    @inbounds while idx ∈ 1:length && !visited[idx]
        visited[idx] = true

        acc += program[idx].acc
        idx = program[idx].jmp

        if program[idx].acc == 0
            alternates[alt] = (program[idx].nop, acc)
            alt += 1
        end
    end

    resize!(alternates, alt)

    return acc, visited, alternates
end

function repair(program, visited, alternates, length)
    function runfrom(idx, acc)
        @inbounds while idx ∈ 1:length
            visited[idx] && return 0
            visited[idx] = true

            acc += program[idx].acc
            idx = program[idx].jmp
        end

        return acc
    end

    for alternate ∈ alternates
        acc = runfrom(alternate...)
        acc ≠ 0 && return acc
    end

    return 0
end

function solve(input::InputBuffer)
    # each line contains at least 7 characters (including '\n')
    program = Vector{Instruction}(undef, length(input) ÷ 7)

    len = 0

    @inbounds while !eof(input)
        len += 1

        op = unsafe_read(input, UInt8)
        skip(input, 3)
        neg = unsafe_read(input, UInt8) == '-' % UInt8
        acc = unsafe_parse(Int, input)
        acc = (acc ⊻ -neg) + neg

        if op == 'a' % UInt8
            jmp = nop = len + 1
        else
            jmp = len + 1
            nop = len + acc
            if op == 'j' % UInt8
                jmp, nop = nop, jmp
             end
            acc = 0
        end

        program[len] = Instruction(acc, jmp, nop)
    end

    part1, visited, alternates = run(program, len)
    part2 = repair(program, visited, alternates, len)

    return part1, part2
end

end # module
