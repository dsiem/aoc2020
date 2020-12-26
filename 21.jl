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
    identified = Vector{String}()
    while !isempty(candidates)
        for (allergene, ingredients) ∈ candidates
            candidates[allergene] = setdiff(ingredients, identified)
            if length(ingredients) == 1
                dictionary[allergene] = first(pop!(candidates, allergene))
                push!(identified, dictionary[allergene])
            end
        end
    end

    part1 = count(!in(Set(values(dictionary))), allingreds)
    part2 = join(values(sort(dictionary)), ',')

    return part1, part2
end
