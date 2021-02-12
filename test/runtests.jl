using SafeTestsets

@safetestset "ProspectTheory" begin
    # test values based on http://psych.fullerton.edu/mbirnbaum/calculators/cpt_calculator.htm
    using Test, UtilityModels
    import UtilityModels: compute_weights
    α = .8; β = .9; γg = .6; γl =.7; λ = 2.25
    model = ProspectTheory(;α, β, γg, γl, λ)
    p = [.3,.2,.3,.2]
    v = [10.0,3.0,-2.0,-1.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ .5672 atol = 1e-4
    ω = compute_weights(model, gamble)
    @test ω ≈ [0.1293,0.3281,0.0992,0.3165] atol = 1e-4

    α = 1.2; β = 1.5; γg = .8; γl = .9; λ = 1.5
    model = ProspectTheory(;α, β, γg, γl, λ)
    p = [.1,.2,.5,.2]
    v = [1.0,3.0,-5.0,-2.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ -8.1017 atol = 1e-4
    ω = compute_weights(model, gamble)
    @test ω ≈ [0.1811,0.4962,0.0848,0.2415] atol = 1e-4
end

@safetestset "TAX" begin
    # tested against http://psych.fullerton.edu/mbirnbaum/calculators/taxcalculator.htm
    # using gambles from Birnbaum 2008
    using Test, UtilityModels
    
    model = TAX()
    p = [.25,.25,.50]
    v = [100.0,0.0,-50.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ -15.5125 atol = 1e-4

    model = TAX()
    p = [.80,.10,.10]
    v = [110.0,44.0,40.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ 65.02513599372996 atol = 1e-8

    model = TAX()
    p = [.05,.05,.90]
    v = [96.0,12.0,3.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ 8.803653482548164 atol = 1e-8

    using Test, UtilityModels
    δ = 1.0; β = .9; γ = .70
    model = TAX(;δ, β, γ)
    p = [.05,.05,.90]
    v = [96.0,12.0,3.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    # calculator uses certainty equivalent
    @test (eu)^(1/β) ≈ 33.567163255247856 atol = 1e-8
end

@safetestset "ExpectedUtility" begin
    using Test, UtilityModels
    α = 1.0
    model = ExpectedUtility(α)
    p = [.3,.2,.3,.2]
    v = [10.0,3.0,-2.0,-1.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ p'*v atol = 1e-4

    α = .8
    model = ExpectedUtility(α)
    p = [.3,.2,.3,.2]
    v = [10.0,3.0,-2.0,-1.0]
    gamble = Gamble(;p, v)
    eu = mean(model, gamble)
    @test eu ≈ (sign.(v).*abs.(v).^α)'*p atol = 1e-4
end