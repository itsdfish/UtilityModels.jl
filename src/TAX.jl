abstract type AbstractTAX <: UtilityModel end
"""
    TAX{T <: Real} <: AbstractTAX

A model object for transfer of attention exchange.

# Fields

- `δ = 1.0`: transfer of attention parameter
- `γ = 1.0`: probability weighting parameter
- `β = .70`: utility curvature
- `θ`: temperature or decisional consistency

# Constructors

```julia 
TAX(; δ = -1.0, β = 1.0, γ = 0.70, θ = 1.0)

TAX(δ, γ, β, θ)
```
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

model = TAX(; δ = -1.0, 
    β = 1.0, 
    γ = 0.70, 
    θ = 1.0
)

pdf(model, gambles, 1)

logpdf(model, gambles, 1)
```
# References

Birnbaum, M. H., & Chavez, A. (1997). Tests of theories of decision making: Violations of branch independence and distribution independence. Organizational Behavior and Human Decision Processes, 71(2), 161-194.
Birnbaum, M. H. (2008). New paradoxes of risky decision making. Psychological Review, 115(2), 463.
"""
mutable struct TAX{T <: Real} <: AbstractTAX
    δ::T
    γ::T
    β::T
    θ::T
end

function TAX(; δ = -1.0, β = 1.0, γ = 0.70, θ = 1.0)
    return TAX(δ, γ, β, θ)
end

function TAX(δ, γ, β, θ)
    return TAX(promote(δ, γ, β, θ)...)
end

"""
    compute_utility(model::AbstractTAX, gamble)

Computes utility of gamble outcomes according to TAX

# Arguments

- `model::AbstractTAX`: a model object for TAX
- `gamble`: a gamble object
"""
function compute_utility(model::AbstractTAX, gamble)
    (; β) = model
    (; v) = gamble
    utility = @. sign(v) * abs(v)^β
    return utility
end

tax_weight(p, γ) = (p^γ)

function ω(p, pk, n, δ, γ)
    if δ > 0
        return δ * tax_weight(pk, γ) / (n + 1)
    end
    return δ * tax_weight(p, γ) / (n + 1)
end

function sort!(model::AbstractTAX, gamble::Gamble)
    (; p, v) = gamble
    i = sortperm(v)
    p .= p[i]
    v .= v[i]
    return nothing
end

"""
    mean(model::AbstractTAX, gamble::Gamble)

Computes mean utility for the TAX model

# Arguments

- `model::AbstractTAX`: a model M <: UtilityModel
- `gamble::Gamble`: a gamble object
"""
function mean(model::AbstractTAX, gamble::Gamble)
    (; p, v) = gamble
    (; γ, δ) = model
    n = length(p)
    sort!(model, gamble)
    utility = compute_utility(model, gamble)
    eu = 0.0
    sum_weight = 0.0
    for i ∈ 1:n
        eu += tax_weight(p[i], γ) * utility[i]
        sum_weight += tax_weight(p[i], γ)
        for k ∈ 1:(i - 1)
            eu += (utility[i] - utility[k]) * ω(p[i], p[k], n, δ, γ)
        end
    end
    return eu / sum_weight
end

function var(model::AbstractTAX, gamble::Gamble)
    error("var not implimented for TAX")
    return -100.0
end
