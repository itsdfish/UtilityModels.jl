@safetestset "Gambles" begin
    @safetestset "mean" begin
        @safetestset "1" begin
            using Test
            using UtilityModels

            gamble = Gamble(;
                p = [0.50, 0.50],
                v = [-10, 20]
            )

            @test mean(gamble) ≈ 5
        end

        @safetestset "2" begin
            using Test
            using UtilityModels

            gamble = Gamble(;
                p = [0.25, 0.25, 0.50],
                v = [-20, 100, 30]
            )

            @test mean(gamble) ≈ -5 + 25 + 15
        end
    end

    @safetestset "std" begin
        using Test
        using UtilityModels

        gamble = Gamble(;
            p = [0.25, 0.75],
            v = [-10, 20]
        )

        @test std(gamble) ≈ √(0.25 * (-10 - 12.5)^2 + 0.75 * (20 - 12.5)^2)
    end
end
