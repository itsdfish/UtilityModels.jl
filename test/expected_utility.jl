@safetestset "ExpectedUtility" begin
    using Test
    using UtilityModels
    α = 1.0
    θ = 1.0
    model = ExpectedUtility(α, θ)
    p = [0.3, 0.2, 0.3, 0.2]
    v = [10.0, 3.0, -2.0, -1.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ p' * v atol = 1e-4

    α = 0.8
    θ = 1.0
    model = ExpectedUtility(α, θ)
    p = [0.3, 0.2, 0.3, 0.2]
    v = [10.0, 3.0, -2.0, -1.0]
    gamble = Gamble(; p, v)
    eu = mean(model, gamble)
    @test eu ≈ (sign.(v) .* abs.(v) .^ α)' * p atol = 1e-4
end
