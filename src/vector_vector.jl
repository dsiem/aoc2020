export VectorVector

struct VectorVector{N, M, T}
    data::Matrix{T}
    len::Vector{Int}

    VectorVector{N, M, T}() where {N, M, T} = new(Matrix{T}(undef, N, M), zeros(Int, M))
end

@propagate_inbounds function Base.push!(vv::VectorVector{N, M, T}, i::Integer, x::T) where {N, M, T}
    @inbounds vv.len[i] += 1
    @inbounds vv.data[vv.len[i], i] = x

    return vv
end
