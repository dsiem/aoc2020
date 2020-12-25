function day25(card=9717666, door=20089533)
    n = 1
    for p in Iterators.countfrom()
        n = n * 7 % 20201227
        n == card && return powermod(door, p, 20201227)
    end
end
