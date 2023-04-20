module UtilityModels

    using StatsBase
    using Distributions
    using ConcreteStructs

    import Distributions: ContinuousUnivariateDistribution
    import Distributions: mean
    import Distributions: var
    import Distributions: std
    import Distributions: rand
    import Distributions: logpdf
    import StatsBase: sample 
    
    export UtilityModel
    export TAX
    export ProspectTheory
    export ExpectedUtility
    export ValenceExpectancy
    export Gamble
    export mean
    export var
    export std
    export pdf
    export logpdf
    export sample
    #export rand
    
    include("Gamble.jl")
    include("UtilityModel.jl")
    include("ProspectTheory.jl")
    include("ExpectedUtility.jl")
    include("ValenceExpectancy.jl")
    include("TAX.jl")
end
