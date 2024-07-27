module UtilityModels

using StatsBase
using StatsFuns
using Distributions

import Distributions: ContinuousUnivariateDistribution
import Distributions: mean
import Distributions: var
import Distributions: std
import Distributions: rand
import Distributions: logpdf
import Distributions: pdf
import Distributions: rand
import StatsBase: sample
import Base: sort!

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

include("Gamble.jl")
include("UtilityModel.jl")
include("ProspectTheory.jl")
include("ExpectedUtility.jl")
include("ValenceExpectancy.jl")
include("TAX.jl")
end
