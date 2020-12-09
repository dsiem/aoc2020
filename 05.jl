function day05(file="05.input")
    input = map(eachline(file)) do l
        s = replace(collect(l), Dict(zip("FBLR", "0101"))...) |> join
        parse(Int, s, base=2)
    end

    # Part 1
    maximum(input) |> println

    # Part 2
    sort(input) |> x -> x[findfirst(!isone, diff(x))]+1 |> println
end
