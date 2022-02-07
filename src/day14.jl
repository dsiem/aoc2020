module Day14

using AdventOfCode2020
using SIMD: Vec

@inline function update!(mem, idxₗ, mask₁, maskₕ, val)
    addr = idxₗ | mask₁
    xor  = maskₕ
    for _ ∈ 0:(1 << count_ones(maskₕ))
        mem[addr ⊻ xor] = val
        xor -= 1
        xor &= maskₕ
    end
end

function solve(input::InputBuffer)
    mask₁ = maskₓ = maskₕ = 0 % UInt64
    maskₗ = 0 % UInt16

    mem1 = Dict{UInt16, UInt64}()
    sizehint!(mem1, 512)

    mem2 = Dict{UInt64, UInt64}()

    cells = Dict{UInt16, NTuple{3, UInt64}}()

    skip(input, 1)
    while !eof(input)
        if unsafe_read(input, UInt8) == 'a' % UInt8
            skip(input, 5)
            mask = unsafe_read(input, Vec{36, UInt8})
            skip(input, 2)

            mask₁ = bitmask(UInt64, mask == '1' % UInt8) << 28 |> bitreverse
            maskₓ = bitmask(UInt64, mask == 'X' % UInt8) << 28 |> bitreverse
            maskₗ = maskₓ % UInt16
            maskₕ = maskₓ & 0xfffff0000
        else
            skip(input, 2)
            addr = unsafe_parse(UInt64, input) % UInt16
            skip(input, 3)
            val  = unsafe_parse(UInt64, input)
            skip(input, 1)

            mem1[addr] = mask₁ | maskₓ & val

            addrₗ = addr | mask₁ % UInt16
            xorₗ = maskₗ
            for _ ∈ 0:(1 << count_ones(maskₗ))
                idxₗ = addrₗ ⊻ xorₗ
                cell = get(cells, idxₗ, nothing)
                if cell ≡ nothing
                    cells[idxₗ] = (mask₁, maskₕ, val)
                else
                    if cell ≠ (0, 0, 0)
                        update!(mem2, idxₗ, cell...)
                        cells[idxₗ] = (0, 0, 0)
                    end
                    update!(mem2, idxₗ, mask₁, maskₕ, val)
                end
                xorₗ -= 1 % UInt16
                xorₗ &= maskₗ
            end
        end
    end

    part1 = sum(last, mem1) % Int
    part2 = sum(last, mem2) % Int
    for (_, maskₕ, val) ∈ values(cells)
        part2 += val * (1 << count_ones(maskₕ)) % Int
    end

    return part1, part2
end

end # module
