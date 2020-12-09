function day08(file="08.input")
    code = map(eachline(file)) do line
        op, n = split(line)
        [op, parse(Int, n)]
    end

    # Part 1
    execute(code) |> first |> println

    # Part 2
    for line ∈ 1:length(code)
        code[line][1] == "acc" && continue
        code[line][1] = code[line][1] == "jmp" ? "nop" : "jmp"
        acc, lastline = execute(code)
        code[line][1] = code[line][1] == "jmp" ? "nop" : "jmp"
        if lastline == length(code)+1
            println(acc)
            break
        end
    end
end

function execute(code)
    acc, line, exec = 0, 1, falses(length(code))
    while line ≤ length(code) && exec[line] == false
        exec[line] = true
        if code[line][1] == "acc"
            acc += code[line][2]
            line += 1
        elseif code[line][1] == "jmp"
            line += code[line][2]
        else # nop
            line += 1
        end
    end
    return acc, line
end
