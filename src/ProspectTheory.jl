abstract type AbstractProspectTheory <: UtilityModel end
"""
   ProspectTheory{T <: Real} <: AbstractProspectTheory 

A model object for cummulative prospect theory. 
By default, parameters for utility curvature and probability weigting are equal gains and losses.

# Fields 

- `α = .80`: utility curvature for gains
- `β = α`: utility curvature for losses
- `γg = .70`: probability weighting parameter for gains 
- `γl = γg`: probability weighting parameter for losses
- `λ = 2.25`: loss aversion parameter
- `θ`: temperature or decisional consistency

# Constructors

```julia 
ProspectTheory(; α = 0.80, β = α, γg = 0.70, γl = γg, λ = 2.25, θ = 1.0)

ProspectTheory(α, β, γg, γl, λ, θ)
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

model = ProspectTheory(; 
    α = 0.80, 
    γg = 0.70, 
    λ = 2.25, 
    θ = 1.0
)

pdf(model, gambles, 1)

logpdf(model, gambles, 1)
```

# References

Fennema, H., & Wakker, P. (1997). Original and cumulative prospect theory: A discussion of empirical differences. Journal of Behavioral Decision Making, 10(1), 53-64.

Tversky, A., & Kahneman, D. (1992). Advances in prospect theory: Cumulative representation of uncertainty. Journal of Risk and uncertainty, 5(4), 297-323.
"""
mutable struct ProspectTheory{T <: Real} <: AbstractProspectTheory
    α::T
    β::T
    γg::T
    γl::T
    λ::T
    θ::T
end

function ProspectTheory(; α = 0.80, β = α, γg = 0.70, γl = γg, λ = 2.25, θ = 1.0)
    return ProspectTheory(α, β, γg, γl, λ, θ)
end

function ProspectTheory(α, β, γg, γl, λ, θ)
    return ProspectTheory(promote(α, β, γg, γl, λ, θ)...)
end

"""
    compute_utility(model::AbstractProspectTheory, gamble)

Computes utility of gamble outcomes according to prospect theory

# Arguments 

- `model::AbstractProspectTheory`: a model object for prospect theory
- `gamble`: a gamble object
"""
function compute_utility(model::AbstractProspectTheory, gamble)
    (; α, β, λ) = model
    vl, vg = split_values(gamble)
    utilg = vg .^ α
    utill = @. -λ * abs(vl)^β
    return [utill; utilg]
end

"""
    compute_weights(model::AbstractProspectTheory, gamble::Gamble)

Computes decision weights based on cummulative outcomes

# Arguments

- `model::AbstractProspectTheory`: a model object for prospect theory
- `gamble`: a gamble object
"""
function compute_weights(model::AbstractProspectTheory, gamble::Gamble)
    pl, pg = split_probs(gamble)
    (; γg, γl) = model
    ω = [compute_weights(model, pl, γl); compute_weights(model, pg, γg)]
    return ω
end

"""
    compute_weights(model::AbstractProspectTheory, p::Vector{<:Real}, γ::Real)

Computes decision weights based on cummulative outcomes

# Arguments

- `p`: a probability vector
- `γ`: parameter that controls weighting of low and high probabilities
"""
function compute_weights(model::AbstractProspectTheory, p::AbstractVector{<:Real}, γ::Real)
    n = length(p)
    f(i) =
        compute_weights(model, sum(p[i:n]), γ) -
        compute_weights(model, sum(p[(i + 1):n]), γ)
    ω = [f(i) for i ∈ 1:(n-1)]
    isempty(p) ? nothing : push!(ω, compute_weights(model, p[n], γ))
    return ω
end

function compute_weights(model::AbstractProspectTheory, p::Real, γ::Real)
    p = min(p, 1.0) # to deal with overflow
    return (p^γ) / (p^γ + (1 - p)^γ)^(1 / γ)
end

function sort!(model::AbstractProspectTheory, gamble::Gamble)
    (; p, v) = gamble
    i = sortperm(v)
    p .= p[i]
    v .= v[i]
    gains = v .>= 0
    pl = @view p[.! gains]
    vl = @view v[.! gains]
    reverse!(vl)
    reverse!(pl)
    return nothing
end

function split_values(gamble)
    (; v) = gamble
    gains = v .>= 0
    vg = @view v[gains]
    vl = @view v[.! gains]
    return vl, vg
end

function split_probs(gamble)
    (; v, p) = gamble
    gains = v .>= 0
    pg = @view p[gains]
    pl = @view p[.! gains]
    return pl, pg
end
