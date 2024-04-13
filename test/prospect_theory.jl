@safetestset "Prospect Theory" begin
    # test values based on http://psych.fullerton.edu/mbirnbaum/calculators/cpt_calculator.htm
    using Test
    using UtilityModels
    import UtilityModels: compute_weights

    α = 0.8
    β = 0.9
    γg = 0.6
    γl = 0.7
    λ = 2.25
    model = ProspectTheory(; α, β, γg, γl, λ)
    p = [0.3, 0.2, 0.3, 0.2]
    v = [10.0, 3.0, -2.0, -1.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ 0.5672 atol = 1e-4
    ω = compute_weights(model, gamble)
    @test ω ≈ [0.1293, 0.3281, 0.0992, 0.3165] atol = 1e-4

    α = 1.2
    β = 1.5
    γg = 0.8
    γl = 0.9
    λ = 1.5
    model = ProspectTheory(; α, β, γg, γl, λ)
    p = [0.1, 0.2, 0.5, 0.2]
    v = [1.0, 3.0, -5.0, -2.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ -8.1017 atol = 1e-4
    ω = compute_weights(model, gamble)
    @test ω ≈ [0.1811, 0.4962, 0.0848, 0.2415] atol = 1e-4
end
