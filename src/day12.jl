module Day12

using AdventOfCode2020
using SIMD: Vec, shufflevector

const OPS = (0,
             0,
             270, # R
             5,   # S
             0,
             2,   # E
             0,   # F
             3,   # W
             0,
             0,
             0,
             0,
             90,  # L
             0,
             4,   # N
             0)

function solve(input::InputBuffer)
    pos = Vec{4, Int}((0, 0, 0, 0))
    dir = Vec{4, Int}((1, 0, 10, 1))

    while !eof(input)
        @inbounds m = OPS[1 + unsafe_read(input, UInt8) & 15]
        n = unsafe_parse(Int, input)

        if m == 0 # if moving 'F'
            pos += n * dir
        elseif m < 8 # if moving 'E', 'W', 'N' or 'S'
            if m & 1 == 1 # if moving 'W' or 'S'
                n = -n
            end
            if m & 2 == 2 # if moving 'E' or 'W'
                pos += Vec{4, Int}((n, 0, 0, 0))
                dir += Vec{4, Int}((0, 0, n, 0))
            else # if moving 'N' or 'S'
                pos += Vec{4, Int}((0, n, 0, 0))
                dir += Vec{4, Int}((0, 0, 0, n))
            end
        else # if rotating 'L' or 'R'
            if n == 180
                dir = -dir
            else
                if m == n # if rotating 'L' by 90° or 'R' by 270°
                    dir = shufflevector(dir, -dir, Val((5, 0, 7, 2)))
                else # if rotating 'L' by 270° or 'R' by 90°
                    dir = shufflevector(dir, -dir, Val((1, 4, 3, 6)))
                end
            end
        end
    end

    pos = abs(pos)
    part1 = pos[1] + pos[2]
    part2 = pos[3] + pos[4]

    return part1, part2
end


const LEFT  = (0+1im, -1+0im, 0+0im, 0-1im)
const RIGHT = (0-1im, -1+0im, 0+0im, 0+1im)

function solve_complex(input::InputBuffer)
    pos1 = pos2 = 0 + 0im
    dir1 =  1 + 0im
    dir2 = 10 + 1im

    while !eof(input)
        op = unsafe_read(input, UInt8) |> Char
        n = unsafe_parse(Int, input)

        @inbounds if op == 'F'
            pos1 += n*dir1
            pos2 += n*dir2
        elseif op == 'E'
            pos1 += n
            dir2 += n
        elseif op == 'W'
            pos1 -= n
            dir2 -= n
        elseif op == 'N'
            pos1 += n*im
            dir2 += n*im
        elseif op == 'S'
            pos1 -= n*im
            dir2 -= n*im
        elseif op == 'L'
            # 90 >> 6 = 1, 180 >> 6 = 2, 270 >> 6 = 4
            dir1 *= LEFT[n >> 6]
            dir2 *= LEFT[n >> 6]
        else#if op == 'R'
            dir1 *= RIGHT[n >> 6]
            dir2 *= RIGHT[n >> 6]
        end
    end

    part1 = abs(pos1.re) + abs(pos1.im)
    part2 = abs(pos2.re) + abs(pos2.im)

    return part1, part2
end

end # module
