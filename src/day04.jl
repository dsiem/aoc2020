module Day04

using AdventOfCode2020
using SIMD: Vec, shufflevector

function solve(input::InputBuffer)
    pad!(input, 16)

    part1 = part2 = 0

    fields = 0 % UInt8
    valid  = 1 % UInt8

    while !eof(input)
        if unsafe_peek(input, UInt8) == '\n' % UInt8
            complete = (fields | 0x02) == 0xff # Recall that CID is optional
            part1 += complete
            part2 += complete & valid

            fields = 0 % UInt8
            valid  = 1 % UInt8

            skip(input, 1)
        else
            field = unsafe_read(input, UInt32)

            # Generates a minimal perfect hash from the field name
            hash = (((25field >> 10) ⊻ field) & 7) % UInt8
            fields |= 0x01 << hash

            val = unsafe_peek(input, Vec{16, UInt8})
            len = trailing_zeros(bitmask(UInt16, val < '!' % UInt8))

            valid &= isvalid(hash, val, len)

            skip(input, len+1)
        end
    end

    complete = (fields | 0x02) == 0xff
    part1 += complete
    part2 += complete & valid

    return part1, part2
end

@inline function isvalid(hash::Integer, value::Vec{16, UInt8}, len::Integer)
    (hash == 1)                              || # CID
    (hash == 5 && len == 7)                  || # HCL
    (hash == 2 && len == 9)                  || # PID
    (hash == 4 && parse4(value) ∈ 1920:2002) || # BYR
    (hash == 3 && parse4(value) ∈ 2020:2030) || # EYR
    (hash == 7 && parse4(value) ∈ 2010:2020) || # IYR
    (hash == 0 && len == 3 && isecl(value))  || # ECL
    (hash == 6 && len >  3 && ishgt(value))  || # HGT
    false
end

function parse4(value::Vec{16, UInt8})
    digits  = convert(Vec{4, UInt16}, shufflevector(value, Val((0, 1, 2, 3)))) # TODO
    digits &= 0x0f

    return sum(digits * Vec{4, UInt16}((1000, 100, 10, 1)))
end

#=
Due to peculiarities of the input, it is actually sufficient to just check the
length of PID and HGT. Here is an efficient way to to check the PID:

    function ispid(value::Vec{16, UInt8})
        notdigits = bitmask(UInt16, (value - '0' % UInt8) > 9)
        return notdigits & 0x01ff == 0
    end

=#

function ishgt(value::Vec{16, UInt8})
    digits = value & 0x0f

    if value[4] == 'c' % UInt8
        return digits[2]*10 + digits[3] ∈ 50:93
    elseif value[3] == 'i' % UInt8
        return digits[1]*10 + digits[2] ∈ 59:76
    end

    return false
end

function isecl(value::Vec{16, UInt8})
    # encoded valid eye colors
    valid = Vec{8, UInt16}((0x6261, 0x7562, 0x6e62, 0x7967, 0x6e67, 0x6c68, 0x686f, 0x0000))

    enc = value[1] | UInt16(value[3]) << 8

    return bitmask(UInt8, valid == enc) ≠ 0
end

end # module
