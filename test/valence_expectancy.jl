using Test 
@testset verbose = true "Valence Expectancy" begin
    @safetestset "compute_probs" begin 
        using Test
        using UtilityModels
        using UtilityModels: compute_probs
        
        gambles = [Gamble(;p=[.5,.5],v=[10.0,0.0]),
            Gamble(;p=[.9,.1],v=[5.0,8.0])]
        
        parms = (n_options=2, Δ=.3, α=.5, λ=1.0, c=.5)
        
        model = ValenceExpectancy(;parms...)
        probs = compute_probs(model, 1)
        @test probs ≈ [.5,.5]

        parms = (n_options=2, Δ=.3, α=.5, λ=1.0, c=1.0)
        model = ValenceExpectancy(;parms...)
        model.υ = [0.0,2^2]
        probs = compute_probs(model, 5)
        p = 1 / (1 + exp(-2))
        true_probs = [(1 - p),p]
        @test true_probs ≈ probs
    end

    @safetestset "compute_utility" begin 
        using Test
        using UtilityModels
        using UtilityModels: compute_utility
        
        parms = (n_options=2, Δ=.3, α=.5, λ=2.0, c=.5)
        
        model = ValenceExpectancy(;parms...)
        utility = -6.0
        @test utility ≈ compute_utility(model, [-10,1])
    end

    @safetestset "update_utility!" begin 
        using Test
        using UtilityModels
        using UtilityModels: update_utility!
        
        parms = (n_options=2, Δ=.3, α=.5, λ=2.0, c=.5)
        
        model = ValenceExpectancy(;parms...)
        utility = [0.0,-6.0 * .3]
        @test utility ≈ update_utility!(model, 2, [-10,1]) atol = 1e-8
    end
end