function day21(file="21.input")
    candidates = Dict{String,Set{String}}()
    allingreds = Vector{String}()

    for line ∈ readlines(file)
        parts = split(line[1:end-1], " (contains ")
        ingredients = Set(split(parts[1]))
        append!(allingreds, ingredients)
        for allergene ∈ split(parts[2], ", ")
            if haskey(candidates, allergene)
                intersect!(candidates[allergene], ingredients)
            else
                candidates[allergene] = ingredients
            end
        end
    end
    
    dictionary = Dict{String,String}()
    
    while length(dictionary) < length(candidates)
        for (allergene, ingredients) ∈ candidates
            if length(ingredients) == 1
                dictionary[allergene] = first(ingredients)
            else
                candidates[allergene] = setdiff(ingredients, values(dictionary))
            end
        end
    end

    part1 = count(!in(Set(values(dictionary))), allingreds)
    part2 = join(values(sort(dictionary)), ',')

    return part1, part2
end
