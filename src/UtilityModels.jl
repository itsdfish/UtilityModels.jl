module UtilityModels
    using Parameters, Distributions
    import Distributions: mean, var, std
    export UtilityModel, TAX, ProspectTheory, ExpectedUtility, Gamble
    export mean, var , std
    abstract type UtilityModel end
    
    include("Gamble.jl")
    include("UtilityModel.jl")
    include("ProspectTheory.jl")
    include("ExpectedUtility.jl")
    include("TAX.jl")
end
