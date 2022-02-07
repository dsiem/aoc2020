module Day01

using AdventOfCode2020

function sum2(nums::AbstractVector{T}, target::T, start=1, stop=length(nums)) where T<:Number
    j = start
    k = stop
    @inbounds while j < k
        n = nums[j] + nums[k] - target
        iszero(n) && return nums[j] * nums[k]
        isless = n < zero(T)
        j +=  isless
        k -= !isless
    end
    return zero(T)
end

function sum3(nums::AbstractVector{T}, target::T) where T<:Number
    len = length(nums)
    @inbounds for i ∈ 1:len-2
        ret = sum2(nums, target-nums[i], i+1, len)
        !iszero(ret) && return ret * nums[i]
    end
    return zero(T)
end

function solve(input::InputBuffer)
    nums = unsafe_parse!(Vector{Int}(undef, 200), input) |> sort!

    part1 = sum2(nums, 2020)
    part2 = sum3(nums, 2020)

    return part1, part2
end

end # module
