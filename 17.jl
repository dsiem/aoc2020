function neighbours3d(active)
    dirs = NTuple{3,Int8}[(x,y,z) for x ∈ -1:1, y ∈ -1:1, z ∈ -1:1 if !(x == y == z == 0)]
    neigh = Dict{NTuple{3,Int8},Int8}()
    for coord ∈ active
        for dir ∈ dirs
            neigh[coord .+ dir] = get(neigh, coord .+ dir, 0) + 1
        end
    end
    neigh
end

function neighbours4d(active)
    dirs = NTuple{4,Int8}[(x,y,z,w) for x ∈ -1:1, y ∈ -1:1, z ∈ -1:1, w ∈ -1:1 if !(x == y == z == w == 0)]
    neigh = Dict{NTuple{4,Int8},Int8}()
    for coord ∈ active
        for dir ∈ dirs
            neigh[coord .+ dir] = get(neigh, coord .+ dir, 0) + 1
        end
    end
    neigh
end

function day17b(file="17.input")
    active3d = [(x,y,0) for (y,l) ∈ (enumerate ∘ readlines)(file) for (x,c) ∈ enumerate(l) if c == '#']
    active4d = [(x,y,0,0) for (x,y,_) ∈ active3d]
    for _ ∈ 1:6
        active3d = filter(((coord, n),) -> (coord ∈ active3d && n == 2) || n == 3, (pairs ∘ neighbours3d)(active3d)) |> keys
        active4d = filter(((coord, n),) -> (coord ∈ active4d && n == 2) || n == 3, (pairs ∘ neighbours4d)(active4d)) |> keys
    end
    part1, part2 = length(active3d), length(active4d)

    return part1, part2
end
