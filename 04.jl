using Match

function day04(file="04.input")
    part1 = part2 = 0
    for entry ∈ split(read(file, String) |> strip, "\n\n")
        passport = [(m.captures) for m ∈ eachmatch(r"(byr|iyr|eyr|hgt|hcl|ecl|pid):([#\w\d]+)", entry)]
        if length(passport) == 7
            part1 += 1
            part2 += all(field -> isvalid(field...), passport)
        end
    end
    return part1, part2
end

function isvalid(key, value)
    @match key begin
        "byr" => parse(Int, value) ∈ 1920:2002
        "eyr" => parse(Int, value) ∈ 2020:2030
        "iyr" => parse(Int, value) ∈ 2010:2020
        "ecl" => value ∈ ("amb", "blu", "brn", "gry", "grn", "hzl", "oth")
        "hcl" => length(value) == 7 # contains(value, r"^#[0-9a-f]{6}$")
        "hgt" => (endswith(value, "cm") && parse(Int, value[1:end-2]) ∈ 150:193) || (endswith(value, "in") && parse(Int, value[1:end-2]) ∈ 59:76)
        "pid" => length(value) == 9 # contains(value, r"^\d{9}$")
    end
end
