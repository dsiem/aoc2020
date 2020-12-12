function day11(file="11.input")
    input = hcat(collect.(readlines(file))...)
    
    map((false, true)) do isparttwo
        seats = input
        while true
            seats, tmp = step(seats, isparttwo), seats
            seats == tmp && break
        end
        count(seats .== '#')
    end
end

function step(seats, isparttwo)
    map(Iterators.product(axes(seats)...)) do (i,j)
        if seats[i,j] == 'L' && occupied(seats, i, j, isparttwo) == 0
            '#'
        elseif seats[i,j] == '#' && occupied(seats, i, j, isparttwo) ≥ 5
            'L'
        else
            seats[i,j]
        end
    end
end

function occupied(seats, x, y, isparttwo)
    n = 0
    for dx ∈ -1:1, dy ∈ -1:1
        i, j = x+dx, y+dy
        if isparttwo
            dx == 0 && dy == 0 && continue
            while checkbounds(Bool, seats, i, j) && seats[i,j] == '.'
                i += dx; j += dy
            end
        end
        if checkbounds(Bool, seats, i, j) && seats[i,j] == '#'
            n += 1
        end
    end
    return n
end
