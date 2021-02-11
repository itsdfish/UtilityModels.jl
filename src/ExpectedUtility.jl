"""
*ExpectedUtility*

`ExpectedUtility` constructs a model object for expected utility theory

- `α`: utility curvature for gains

Constructor
````julia
ExpectedUtility(;α=.80)
````
"""
mutable struct ExpectedUtility{T} <:UtilityModel
    α::T
end

function ExpectedUtility(;α=.80)
    return ExpectedUtility(α)
end

"""
*mean*

`mean` computes the expected utility for expected utility theory

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
mean(model::ExpectedUtility, gamble::Gamble)
````
"""
function mean(model::ExpectedUtility, gamble::Gamble)
    @unpack p = gamble
    utility = compute_utility(model, gamble)
    return p'*utility
end

"""
*var*

`var` computes the variance of the gamble for Expected Utility

- `model`: a model object for expected utilty
- `gamble`: a gamble object

Function Signature
````julia
var(model::ExpectedUtility, gamble::Gamble)
````
"""
function var(model::ExpectedUtility, gamble::Gamble)
    @unpack α = model
    @unpack p = gamble
    utility = compute_utility(model, gamble)
    eu = mean(model, gamble)
    return  sum(p .* (utility .- eu).^2)
end

"""
*std*

`std` computes the standard deviation of the gamble for expected utility

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
std(model::ExpectedUtility, gamble::Gamble)
````
"""
std(model::ExpectedUtility, gamble::Gamble) = sqrt(var(model, gamble))

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
    @unpack α = model
    @unpack v = gamble
    utility = @. sign(v)*abs(v)^α 
    return utility
end