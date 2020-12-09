function day07(file="07.input")
    rules = map(eachline(file)) do line
        bag, content = split(line, " bags contain ")
        bag => Dict(m[2] => parse(Int, m[1]) for m in eachmatch(r"(\d+) ([\w\s]+) bag", content))
    end |> Dict

    # Part 1
    part1(rules, bag) = haskey(rules[bag], "shiny gold") || any(k -> part1(rules, k), keys(rules[bag]))
    count(bag -> part1(rules, bag), keys(rules)) |> println

    # Part 2
    # > v1.6: part2(rules, bag) = sum(((k, v),) -> v * (1 + part2(rules, k)), rules[bag], init=0)
    part2(rules, bag) = mapreduce(((k, v),) -> v * (1 + part2(rules, k)), +, rules[bag], init=0)
    part2(rules, "shiny gold") |> println
end
