"""
    ExpectedUtility{T <: Real} <: UtilityModel

A model object for expected utility theory

# Fields 

- `α`: utility curvature
- `θ`: temperature or decisional consistency

# Constructors
````julia
ExpectedUtility(; α = .80, θ = 1.0)
````
````julia
ExpectedUtility(α, θ)
````
# Example 

```julia
using UtilityModels

gamble1 = Gamble(; 
    p = [.25, .25, .50], 
    v = [44, 40, 5]
)

gamble2 = Gamble(; 
    p = [.25, .25, .50], 
    v = [98, 10, 5]
)

gambles = [gamble1,gamble2]

mean.(model, gambles)
std.(model, gambles)

model = ExpectedUtility(; α = .80, θ = 1.0)

pdf(model, gambles, 1)

logpdf(model, gambles, 1)
```
"""
mutable struct ExpectedUtility{T <: Real} <: UtilityModel
    α::T
    θ::T
end

function ExpectedUtility(; α = 0.80, θ = 1.0)
    return ExpectedUtility(α, θ)
end

function ExpectedUtility(α, θ)
    return ExpectedUtility(promote(α, θ))
end

"""
    compute_utility(model::ExpectedUtility, gamble::Gamble)

Computes utility of gamble outcomes according to expected utility theory.

# Arguments

- `model::ExpectedUtility`: a model object for prospect theory
- `gamble::Gamble`: a gamble object
"""
function compute_utility(model::ExpectedUtility, gamble::Gamble)
    (; α) = model
    (; v) = gamble
    utility = @. sign(v) * abs(v)^α
    return utility
end
