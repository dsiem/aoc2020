module AdventOfCode2020

using Base: @propagate_inbounds
using BenchmarkTools
using SIMD

include("input_buffer.jl")
include("low_level.jl")
include("vector_vector.jl")

function load_day(day::Integer)
    day_str = lpad(day, 2, "0")
    include(joinpath(@__DIR__, "day$day_str.jl"))
    input = read(joinpath(@__DIR__, "..", "input", "day$day_str.txt")) |> InputBuffer
    day_mod = getfield(AdventOfCode2020, Symbol("Day$day_str"))
    return day_mod, input
end

function benchmark(day::Integer)
    day_mod, input = load_day(day)
    @benchmark $day_mod.solve($input) setup=(seekstart($input)) evals=1
end

end # module
