module Day11

using AdventOfCode2020
using SIMD: Vec, VecRange, shufflevector

mutable struct Room
    seats::Matrix{UInt8}
    floor::Matrix{UInt8}
    occupied::Matrix{UInt8}
    neighbours::Matrix{UInt8}
    height::Int
    width::Int

    Room(height, width) = new(
        Matrix{UInt8}(undef, 128, height+2),
        Matrix{UInt8}(undef, 128, height+2),
        Matrix{UInt8}(undef, 128, height+2),
        Matrix{UInt8}(undef, 128, height+2),
        height, width
    )
end

const Row = Vec{128, UInt8}

# TODO: handle case n > 8; generate code automatically
const SHUFFLE_R = ((Val((128:127+n..., 0:127-n...)) for n ∈ 1:8)...,)
@inline function shuffle_right(row::Row, n::Integer=1)
    n == 1 && return shufflevector(row, Row(0), SHUFFLE_R[ 1])
    n == 2 && return shufflevector(row, Row(0), SHUFFLE_R[ 2])
    n == 3 && return shufflevector(row, Row(0), SHUFFLE_R[ 3])
    n == 4 && return shufflevector(row, Row(0), SHUFFLE_R[ 4])
    n == 5 && return shufflevector(row, Row(0), SHUFFLE_R[ 5])
    n == 6 && return shufflevector(row, Row(0), SHUFFLE_R[ 6])
    n == 7 && return shufflevector(row, Row(0), SHUFFLE_R[ 7])
    n == 8 && return shufflevector(row, Row(0), SHUFFLE_R[ 8])
    return row #shufflevector(row, Row(0), SHUFFLE_R[n])
end

const SHUFFLE_L = ((Val((n:127..., 128:127+n...)) for n ∈ 1:8)...,)
@inline function shuffle_left(row::Row, n::Integer=1)
    n == 1 && return shufflevector(row, Row(0), SHUFFLE_L[1])
    n == 2 && return shufflevector(row, Row(0), SHUFFLE_L[2])
    n == 3 && return shufflevector(row, Row(0), SHUFFLE_L[3])
    n == 4 && return shufflevector(row, Row(0), SHUFFLE_L[4])
    n == 5 && return shufflevector(row, Row(0), SHUFFLE_L[5])
    n == 6 && return shufflevector(row, Row(0), SHUFFLE_L[6])
    n == 7 && return shufflevector(row, Row(0), SHUFFLE_L[7])
    n == 8 && return shufflevector(row, Row(0), SHUFFLE_L[8])
    return row #shufflevector(row, Row(0), SHUFFLE_L[n])
end

@inline function furnish!(room::Room, input::InputBuffer)
    lane = VecRange{128}(129)

    @inbounds room.seats[128] = 0
    @inbounds for _ ∈ 1:room.height
        seats = unsafe_peek(input, Row) == 'L' % UInt8
        room.seats[lane] = convert(Row, seats)
        room.floor[lane] = room.seats[lane] - 1
        room.seats[lane + room.width] = Row(0)
        lane += 128
        skip(input, room.width)
    end
    copy!(room.occupied, room.seats)

    return room
end

empty!(room::Room) = copy!(room.occupied, room.seats)

@inline function neighbours_near!(room::Room)
    @inbounds begin
        lane = VecRange{128}(129)

        row = room.occupied[lane - 1] + room.occupied[lane] + room.occupied[lane + 1]
        room.neighbours[lane] = row
        for _ ∈ 2:room.height
            lane += 128
            row′, row = row, room.occupied[lane - 1] + room.occupied[lane] + room.occupied[lane + 1]
            room.neighbours[lane - 128] += row
            room.neighbours[lane] = row + row′
        end
    end

    return room
end

@inline function horizontal_shift(seats::Row, shifted::Row)
    shifted = shuffle_left(shifted)
    overlap = seats & shifted

    return seats & ~overlap, shifted & ~overlap, any(overlap ≠ 0)
end

@inline function horizontal_shifts(room::Room)
    shifts = Int[]
    sizehint!(shifts, 256)

    lane = VecRange{128}(129)
    @inbounds for _ ∈ 1:room.height
        seats = shifted = room.seats[lane]

        seats, shifted, _ = horizontal_shift(seats, shifted)
        seats, shifted, _ = horizontal_shift(seats, shifted)

        shift = 0
        while any(shifted ≠ 0)
            shift += 1
            seats, shifted, hasoverlap = horizontal_shift(seats, shifted)
            !hasoverlap && continue
            push!(shifts, shift)
            shift = 0
        end
        push!(shifts, 0)

        lane += 128
    end

    return shifts
end

@inline function vertical_neighbours(left::Row, middle::Row, right::Row, occupied::Row, floor::Row)
    left  = shuffle_left(left)
    right = shuffle_right(right)

    neighbours = left + middle + right

    left   = occupied | (floor & left)
    middle = occupied | (floor & middle)
    right  = occupied | (floor & right)

    return left, middle, right, neighbours
end

@inline function horizontal_neighbours(left::Row, right::Row, floor::Row, shift::Integer=1)
    left  = shuffle_left(left, shift)
    right = shuffle_right(right, shift)

    neighbours = left + right

    left  &= floor
    right &= floor

    return left, right, neighbours
end

@inline function neighbours_far!(room::Room, shifts::Vector{<:Integer})
    @inbounds begin
        lane = VecRange{128}(129)

        # vertical, down
        room.neighbours[lane] = Row(0)
        l = m = r = room.occupied[lane]
        for _ ∈ 2:room.height
            lane += 128
            l, r, m, n = vertical_neighbours(l, r, m, room.occupied[lane], room.floor[lane])
            room.neighbours[lane] = n
        end

        # vertical, up
        l = m = r = room.occupied[lane]
        for _ ∈ 2:room.height
            lane -= 128
            l, r, m, n = vertical_neighbours(l, r, m, room.occupied[lane], room.floor[lane])
            room.neighbours[lane] += n
        end

        # horizontal
        i = 0
        for _ ∈ 1:room.height
            l = r = room.occupied[lane]

            l, r, n = horizontal_neighbours(l, r, room.floor[lane])
            l, r, ñ = horizontal_neighbours(l, r, room.floor[lane])
            n += ñ

            i += 1
            while (shift = shifts[i]) ≠ 0
                l, r, ñ = horizontal_neighbours(l, r, room.floor[lane], shift)
                n += ñ
                i += 1
            end

            room.neighbours[lane] += n

            lane += 128
        end
    end

    return room
end

@inline function occupy!(room::Room)
    lane = VecRange{128}(129)

    same = Vec{128, Bool}(true)
    @inbounds for _ ∈ 1:room.height
        row  = select(room.neighbours[lane] == 0, room.seats[lane], room.occupied[lane])
        row  = select(room.neighbours[lane] < 5, row, Row(0))
        same = select(room.occupied[lane] == row, same, Vec{128, Bool}(false))
        room.occupied[lane] = row
        lane += 128
    end

    return !all(same)
end

@inline function count(room::Room)
    lane = VecRange{128}(129)

    total = 0
    @inbounds for _ ∈ 1:room.height
        total += sum(room.occupied[lane])
        lane += 128
    end

    return total
end

function solve(input::InputBuffer)
    pad!(input, 128)

    skip(input, 90)
    eol = unsafe_read(input, Vec{16, UInt8}) ≍ '\n'
    width = position(input) - leading_zeros(eol) - 1
    height = length(input) ÷ width
    seekstart(input)

    room = Room(height, width)
    furnish!(room, input)

    neighbours_near!(room)
    while occupy!(room)
        neighbours_near!(room)
    end
    part1 = count(room)

    empty!(room)

    shifts = horizontal_shifts(room)
    neighbours_far!(room, shifts)
    while occupy!(room)
        neighbours_far!(room, shifts)
    end
    part2 = count(room)

    return part1, part2
end

end # module
