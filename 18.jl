⊙, ⊕ = +, *

function day18(file="18.input")
    part1 = part2 = 0
    for line ∈ eachline(file)
        part1 += Meta.parse(map(c -> c == '*' ? '⊕' : c, line)) |> eval
        part2 += Meta.parse(map(c -> c == '*' ? '⊕' : c == '+' ? '⊙' : c, line)) |> eval
    end
    return part1, part2
end
