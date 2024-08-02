using Documenter
using UtilityModels

makedocs(
    warnonly = true,
    sitename = "UtilityModels",
    format = Documenter.HTML(
        assets = [
            asset(
            "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
            class = :css
        )
        ],
        collapselevel = 1
    ),
    modules = [
        UtilityModels
    # Base.get_extension(SequentialSamplingModels, :TuringExt),  
    # Base.get_extension(SequentialSamplingModels, :PlotsExt) 
    ],
    pages = [
        "Home" => "index.md",
        "Gambles" => "gambles.md",
        "Models" => [
            "Expected Utility Theory" => "expected_utility.md",
            "Prospect Theory" => "prospect_theory.md"
        ],
        "Parameter Estimation" => "parameter_estimation.md",
        "API" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/itsdfish/UtilityModels.jl.git",
)
