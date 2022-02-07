export ≍, bitmask, select

≍(x::Vec{16, UInt8}, y::Vec{16, UInt8}) = bitmask(UInt16, x == y)
≍(x::Vec{32, UInt8}, y::Vec{32, UInt8}) = bitmask(UInt32, x == y)
≍(x::Vec{64, UInt8}, y::Vec{64, UInt8}) = bitmask(UInt64, x == y)
≍(x::Vec{N, UInt8}, i::UInt8) where {N} = x ≍ Vec{N, UInt8}(i)
≍(x::Vec{N, UInt8}, c::Char) where {N} = x ≍ (c % UInt8)

@generated function bitmask(::Type{T}, x::Vec{N, Bool}) where {N, T}
    bits = sizeof(T) * 8
    if N < bits
        ret = """
        %res = zext i$(N) %maski to i$(bits)
        ret i$(bits) %res
        """
    elseif N == bits
        ret = "ret i$(bits) %maski"
    else
        ret = """
        %res = trunc i$(N) %maski to i$(bits)
        ret i$(bits) %res
        """
    end
    s = """
        %mask = trunc <$(N) x i8> %0 to <$(N) x i1>
        %maski = bitcast <$(N) x i1> %mask to i$(N)
        $(ret)
    """
    return :(
        $(Expr(:meta, :inline));
        Base.llvmcall($s, T, Tuple{NTuple{N, Base.VecElement{Bool}}}, x.data)
    )
end

@inline select(cond::Vec{N, Bool}, x, y) where {N} = SIMD.Intrinsics.select(cond.data, x.data, y.data) |> Vec
