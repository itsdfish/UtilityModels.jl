module UtilityModels
    using Parameters
    export ProspectTheory, expected_utility, Gamble

    abstract type UtilityModel end
    include("ProspectTheory.jl")
    include("Gamble.jl")
end
