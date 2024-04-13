@safetestset "TAX" begin
    # tested against http://psych.fullerton.edu/mbirnbaum/calculators/taxcalculator.htm
    # using gambles from Birnbaum 2008
    using Test
    using UtilityModels

    model = TAX()
    p = [0.25, 0.25, 0.50]
    v = [100.0, 0.0, -50.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ -15.5125 atol = 1e-4

    model = TAX()
    p = [0.80, 0.10, 0.10]
    v = [110.0, 44.0, 40.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ 65.02513599372996 atol = 1e-8

    model = TAX()
    p = [0.05, 0.05, 0.90]
    v = [96.0, 12.0, 3.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ 8.803653482548164 atol = 1e-8

    δ = 1.0
    β = 0.9
    γ = 0.70
    model = TAX(; δ, β, γ)
    p = [0.05, 0.05, 0.90]
    v = [96.0, 12.0, 3.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    # calculator uses certainty equivalent
    @test (eu)^(1 / β) ≈ 33.567163255247856 atol = 1e-8

    δ = -0.8
    β = 1.1
    γ = 0.70
    model = TAX(; δ, β, γ)
    p = [0.90, 0.05, 0.05]
    v = [10.0, 12.0, 2.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    # calculator uses certainty equivalent
    @test (eu)^(1 / β) ≈ 7.964935426997389 atol = 1e-8
end
