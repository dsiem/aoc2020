export InputBuffer, pad!, unsafe_parse, unsafe_parse!, unsafe_peek

mutable struct InputBuffer
    data::Vector{UInt8}
    ptr::Int
    size::Int
    padding::Int

    function InputBuffer(data::Vector{UInt8}, padding::Integer=0)
        len = length(data)
        resize!(data, len+padding)
        new(data, 1, len, padding)
    end
end

Base.length(input::InputBuffer) = input.size
Base.eof(input::InputBuffer) = input.ptr ≥ input.size
Base.position(input::InputBuffer) = input.ptr

function Base.seek(input::InputBuffer, n::Integer)
    input.ptr = n
    input
end

Base.seekstart(input::InputBuffer) = seek(input, 1)
Base.skip(input::InputBuffer, n::Integer) = seek(input, input.ptr + n)

function unsafe_peek(from::InputBuffer, ::Type{UInt8})
    @inbounds from.data[from.ptr]
end

function unsafe_peek(from::InputBuffer, T::Union{Type{Int16},Type{UInt16},Type{Int32},Type{UInt32},Type{Int64},Type{UInt64},Type{Int128},Type{UInt128}})
    GC.@preserve from begin
        ptr::Ptr{T} = pointer(from.data, from.ptr)
        ret = unsafe_load(ptr)
    end
    return ret
end

function unsafe_peek(from::InputBuffer, ::Type{Vec{N, UInt8}}) where N
    @inbounds vload(Vec{N, UInt8}, from.data, from.ptr)
end

function Base.unsafe_read(from::InputBuffer, T::Type{<:Integer})
    ret = unsafe_peek(from, T)
    from.ptr += sizeof(T)
    return ret
end

function Base.unsafe_read(from::InputBuffer, T::Type{Vec{N, UInt8}}) where N
    ret = unsafe_peek(from, T)
    from.ptr += N
    return ret
end

function unsafe_parse(::Type{T}, from::InputBuffer) where T<:Integer
    n = T(0)
    while true
        d = unsafe_read(from, UInt8) - UInt8('0') # & 0x0f
        if d ≤ 9
            n = T(10)*n + d%T
        else
            break
        end
    end
    return n
end

function unsafe_parse!(out::AbstractArray{T}, from::InputBuffer) where T<:Integer
    for i ∈ eachindex(out)
        n = unsafe_parse(T, from)
        @inbounds out[i] = n
    end
    return out
end

function pad!(input::InputBuffer, padding::Integer)
    resize!(input.data, input.size + padding)
    input.padding = padding
    return input
end
