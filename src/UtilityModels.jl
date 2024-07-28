module UtilityModels

using StatsBase
using StatsFuns
using Distributions

import Distributions: length
import Distributions: loglikelihood
import Distributions: logpdf
import Distributions: mean
import Distributions: pdf
import Distributions: std
import Distributions: rand
import Distributions: var

import StatsBase: sample
import Base: sort!

export ExpectedUtility
export Gamble
export ProspectTheory
export TAX
export UtilityModel
export ValenceExpectancy

export compute_utility
export mean
export loglikelihood
export logpdf
export pdf
export var
export sample
export std

include("Gamble.jl")
include("UtilityModel.jl")
include("ProspectTheory.jl")
include("ExpectedUtility.jl")
include("ValenceExpectancy.jl")
include("TAX.jl")
end
