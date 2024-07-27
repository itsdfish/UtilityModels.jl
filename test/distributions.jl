@safetestset "pdf" begin
    @safetestset "1" begin
        using Test
        using UtilityModels

        gamble1 = Gamble(;
            p = [0.50, 0.50],
            v = [-10, 10]
        )

        gamble2 = Gamble(;
            p = [1],
            v = [0]
        )

        gambles = [gamble1, gamble2]

        model = ExpectedUtility(; α = 1.0, θ = 1.0)

        prob = pdf(model, gambles, 1)

        @test prob ≈ 0.50
    end

    @safetestset "2" begin
        using Test
        using UtilityModels

        gamble1 = Gamble(;
            p = [0.50, 0.50],
            v = [-11, 10]
        )

        gamble2 = Gamble(;
            p = [1],
            v = [0]
        )

        gambles = [gamble1, gamble2]

        model = ExpectedUtility(; α = 1.0, θ = 2.0)

        prob = pdf(model, gambles, 1)

        @test prob ≈ 1 / (1 + exp(-2 * -0.5))
    end
end

@safetestset "logpdf" begin
    @safetestset "1" begin
        using Test
        using UtilityModels

        gamble1 = Gamble(;
            p = [0.50, 0.50],
            v = [-11, 10]
        )

        gamble2 = Gamble(;
            p = [1],
            v = [0]
        )

        gambles = [gamble1, gamble2]

        model = ExpectedUtility(; α = 1.0, θ = 2.0)

        log_prob = pdf(model, gambles, 1) |> log

        @test log_prob ≈ logpdf(model, gambles, 1)
    end
end
