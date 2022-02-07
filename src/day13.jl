module Day13

using AdventOfCode2020

# Equivalent to mod(-n, m)
function negmod(n, m)
    r = n % m

    r == 0 && return r
    return m - r
end

# Computes the modular multiplicative inverse
function modinv(a, n)
    t, t′ = 0, 1
    r, r′ = n, a % n

    while r′ ≠ 0
        q = r ÷ r′
        t, t′ = t′, t - q * t′
        r, r′ = r′, r - q * r′
    end

    t < 0 && return t + n
    return t
end

function solve(input::InputBuffer)
    t₀, tₘᵢₙ, Δt = unsafe_parse(Int, input), typemax(Int), 1
    part1 = part2 = 0

    offset = -1
    while !eof(input)
        offset += 1

        if unsafe_peek(input, UInt8) == 'x' % UInt8
            skip(input, 2)
            continue
        end

        bus = unsafe_parse(Int, input)

        t = negmod(t₀, bus)
        if t < tₘᵢₙ
            part1 = bus
            tₘᵢₙ = t
        end

        part2 += negmod(part2 + offset, bus) * modinv(Δt, bus) * Δt
        Δt *= bus
    end

    part1 *= tₘᵢₙ
	part2 %= Δt

    return part1, part2
end

end # module
