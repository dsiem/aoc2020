function day15(seed=[6,4,12,1,20,0,16])
    part1 = vaneck(seed, 2020)
    part2 = vaneck(seed, 30000000)

    return part1, part2
end

function vaneck(seed, stop)
    n = last(seed)
    mem = fill(0, stop-1)
    for i ∈ 1:length(seed)-1
        mem[seed[i]+1] = i
    end
    for i ∈ length(seed):stop-1
        mem[n+1], n = i, mem[n+1] == 0 ? 0 : i-mem[n+1]
    end
    return n
end
