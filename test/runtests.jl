using AdventOfCode2020
using Printf
using Test

function solve(day::Integer)
    day_mod, input = AdventOfCode2020.load_day(day)
    @eval return $day_mod.solve($input)
end

@testset "Advent of Code 2020" begin
    @test solve(1) == (806656, 230608320)
    @test solve(2) == (600, 245)
    @test solve(3) == (203, 3316272960)
    @test solve(4) == (170, 103)
    @test solve(5) == (987, 603)
    @test solve(6) == (6947, 3398)
    @test solve(7) == (287, 48160)
    @test solve(8) == (1600, 1543)
    @test solve(9) == (731031916, 93396727)
    @test solve(10) == (2574, 2644613988352)
    @test solve(11) == (2273, 2064)
    @test solve(12) == (2280, 38693)
    @test solve(13) == (410, 600691418730595)
    @test solve(14) == (12135523360904, 2741969047858)
    @test solve(15) == (475, 11261)
    @test solve(16) == (22073, 1346570764607)
end
