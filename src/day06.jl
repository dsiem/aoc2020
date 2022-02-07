module Day06

using AdventOfCode2020

function solve(input::InputBuffer)
    part1, part2 = 0, 0

    allor  =  0 % UInt
    alland = -1 % UInt

    while !eof(input)
        start = position(input)
        mask = 0 % UInt

        # TODO: isolate this into a bitmask function?
        # Is it possible to do this without an explicit loop and vectorize this? need 32 byte operations
        while true
            byte = unsafe_read(input, UInt8)
            if byte == '\n' % UInt8
                break
            else
                mask |= 1 << (byte & 0x1f) # fast version of: byte - 'a' % UInt8
            end
        end

        if start == position(input)-1 # happens at end of group
            part1 += count_ones(allor)
            part2 += count_ones(alland)
            allor  =  0 % UInt
            alland = -1 % UInt
        else
            allor  |= mask
            alland &= mask
        end
    end

    # count the last group
    part1 += count_ones(allor)
    part2 += count_ones(alland)

    return part1, part2
end

end # module
