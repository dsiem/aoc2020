using Combinatorics

function day14(file="14.input")
    input = readlines(file)

    mem = Dict{Int,Int}()
    mask1 = maskX = 0
    for line ∈ input
        if startswith(line, "mask = ")
            maskX = parse(Int, map(c -> c == 'X' ? '1' : '0', line[8:end]), base=2)
            mask1 = parse(Int, map(c -> c == '1' ? '1' : '0', line[8:end]), base=2)
        else
            addr, val = split(line, ']') |> s -> (parse(Int, s[1][5:end]), parse(Int, s[2][4:end]))
            mem[addr] = mask1 | maskX & val
        end
    end
    part1 = mem |> values |> sum

    mem = Dict{Int,Int}()
    mask0 = 0
    masks = Array{Int,1}()
    for line ∈ input
        if startswith(line, "mask = ")
            mask0 = parse(Int, map(c -> c == '0' ? '1' : '0', line[8:end]), base=2)
            mask1 = parse(Int, map(c -> c == '1' ? '1' : '0', line[8:end]), base=2)
            masks = map(n -> 2^(36-n), findall(isequal('X'), line[8:end])) |> combinations .|> sum
            masks = masks .|  mask1
            push!(masks, mask1)
        else
            addr, val = split(line, ']') |> s -> (parse(Int, s[1][5:end]), parse(Int, s[2][4:end]))
            for mask ∈ masks
                mem[mask | mask0 & addr] = val
            end
        end
    end
    part2 = mem |> values |> sum

    return part1, part2
end
