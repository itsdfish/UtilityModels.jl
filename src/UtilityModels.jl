module UtilityModels
    using Parameters, Distributions, ConcreteStructs
    import Distributions: mean, var, std
    export UtilityModel, TAX, ProspectTheory, ExpectedUtility, Gamble
    export mean, var, std, pdf
    
    include("Gamble.jl")
    include("UtilityModel.jl")
    include("ProspectTheory.jl")
    include("ExpectedUtility.jl")
    include("TAX.jl")
end
