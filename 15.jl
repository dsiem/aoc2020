function day15(input=[6,4,12,1,20,0,16])
    part1 = age(input, 2020)
    part2 = age(input, 30000000)

    return part1, part2
end

function age(input, turns)
    prev = last(input)
    turn = Dict(n => i for (i,n) ∈ enumerate(input[1:end-1]))
    for i ∈ length(input):turns-1
        turn[prev], prev = i, i-get(turn, prev, i)
    end
    prev
end
