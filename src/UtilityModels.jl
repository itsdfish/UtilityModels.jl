module UtilityModels
    using Parameters, Distributions
    import Distributions: mean, var, std
    export ProspectTheory, ExpectedUtility, Gamble
    export mean, var , std
    abstract type UtilityModel end

    include("Gamble.jl")
    include("ProspectTheory.jl")
    include("ExpectedUtility.jl")
end
