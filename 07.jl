function day07(file="07.input")
    rules = map(eachline(file)) do line
        xs = map(m -> m.match, eachmatch.(r"^(\w+ \w+)|(\d \w+ \w+)", line))
        xs[1] => Dict(x[3:end] => parse(Int, x[1]) for x ∈ xs[2:end])
    end |> Dict

    part1 = count(bag -> containsbag(rules, bag), keys(rules))
    part2 = countbags(rules, "shiny gold")

    return part1, part2
end

function containsbag(rules, bag)
    haskey(rules[bag], "shiny gold") || any(k -> containsbag(rules, k), keys(rules[bag]))
end

function countbags(rules, bag)
    # > v1.6: sum(((k, v),) -> v * (1 + countbags(rules, k)), rules[bag], init=0)
    mapreduce(((k, v),) -> v * (1 + countbags(rules, k)), +, rules[bag], init=0)
end
