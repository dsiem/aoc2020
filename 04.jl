function day04(file="04.input")
    input = split(read(file, String), "\n\n") .|>
        x -> split(x, [' ', '\n']) |>
        x -> Dict(x .|> y -> split(y, ':'))

    reqs = Dict(
        "byr" => x -> parse(Int, x) ∈ 1920:2002,
        "iyr" => x -> parse(Int, x) ∈ 2010:2020,
        "eyr" => x -> parse(Int, x) ∈ 2020:2030,
        "hgt" => x -> 
            (endswith(x, "cm") && parse(Int, x[1:end-2]) ∈ 150:193) ||
            (endswith(x, "in") && parse(Int, x[1:end-2]) ∈ 59:76),
        "hcl" => x -> contains(x, r"^#[0-9a-f]{6}$"),
        "ecl" => x -> x ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
        "pid" => x -> contains(x, r"^\d{9}$")
    )

    havekeys = filter(x -> haskey.(Ref(x), keys(reqs)) |> all, input) 

    # Part 1
    length(havekeys) |> println

    # Part 2
    count(x -> all(((k,v),) -> v(x[k]), reqs), havekeys) |> println
end
