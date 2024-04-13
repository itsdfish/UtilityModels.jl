"""
*ExpectedUtility*

`ExpectedUtility` constructs a model object for expected utility theory

- `α`: utility curvature for gains

Constructor
````julia
ExpectedUtility(;α=.80)
````
"""
mutable struct ExpectedUtility{T} <: UtilityModel
    α::T
end

function ExpectedUtility(; α = 0.80)
    return ExpectedUtility(α)
end

"""
*compute_utility*

`compute_utility` computes utility of gamble outcomes according to expected utility theory

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
compute_utility(model::ExpectedUtility, gamble::Gamble)
````
"""
function compute_utility(model::ExpectedUtility, gamble::Gamble)
    (; α) = model
    (; v) = gamble
    utility = @. sign(v) * abs(v)^α
    return utility
end
