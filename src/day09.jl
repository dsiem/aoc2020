module Day09

using AdventOfCode2020
using Base: @propagate_inbounds

@propagate_inbounds function firstinvalid(nums, len)
    for i ∈ 26:len
        window = view(nums, UnitRange(i-25 % UInt, i-1 % UInt))
        !any(n -> nums[i] - n ∈ window, window) && return nums[i]
    end

    return 0
end

@propagate_inbounds function weakness(nums, invalid)
    low, high = 1, 2
    @inbounds Σ = nums[low] + nums[high]

    @inbounds while Σ ≠ invalid
        if Σ < invalid
            high += 1
            Σ += nums[high]
        else
            Σ -= nums[low]
            low += 1
        end
    end # TODO: doesn't check that low < high

    @inbounds view(nums, UnitRange(low % UInt, high % UInt)) |> extrema |> sum
end

function solve(input::InputBuffer)
    len = 0
    nums = Vector{Int}(undef, 1000)

    @inbounds while !eof(input)
        len += 1
        nums[len] = unsafe_parse(Int, input)
    end

    part1 = @inbounds firstinvalid(nums, len)
    part2 = @inbounds weakness(nums, part1)

    return part1, part2
end

end # module
