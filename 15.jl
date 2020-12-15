function day15(seed=[6,4,12,1,20,0,16])
    part1 = vaneck(seed, 2020)
    part2 = vaneck(seed, 30000000)

    return part1, part2
end

function vaneck(seed, turns)
    n = last(seed)
    turn = Dict(s => i for (i,s) ∈ enumerate(seed[1:end-1]))
    for i ∈ length(seed):turns-1
        turn[n], n = i, i-get(turn, n, i)
    end
    return n
end
