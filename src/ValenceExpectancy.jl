abstract type AbstractValenceExpectancy <: UtilityModel end
"""
    ValenceExpectancy{T <: Real} <: AbstractValenceExpectancy

A model object for expected utility theory

# Fields

- `υ`: a vector of expected utilities
- `Δ`: learning rate where `Δ ∈ [0,1]`
- `α`: utility shape parameter where `α > 0`
- `λ`: loss aversion where `λ > 0`
- `c`: temperature

# Constructors

```julia 
ValenceExpectancy(; n_options, Δ, α = 0.80, λ, c)

ValenceExpectancy(Δ, α, λ, c)
```
"""
mutable struct ValenceExpectancy{T <: Real} <: AbstractValenceExpectancy
    υ::Vector{T}
    Δ::T
    α::T
    λ::T
    c::T
end

function ValenceExpectancy(; n_options, Δ, α = 0.80, λ, c)
    υ = zeros(n_options)
    return ValenceExpectancy(υ, Δ, α, λ, c)
end

function ValenceExpectancy(Δ, α, λ, c)
    Δ, α, λ, c = promote(Δ, α, λ, c)
    υ = zeros(typeof(Δ), n_options)
    return ValenceExpectancy(υ, Δ, α, λ, c)
end

"""
    compute_utility(model::ValenceExpectancy, outcomes::Vector) 

`compute_utility` computes utility of gamble outcomes according to expected utility theory

- `model`: a model object for prospect theory
- `outcomes`: observed outcomes of decisions

"""
function compute_utility(model::ValenceExpectancy, outcomes)
    (; λ, α) = model
    v = sum(outcomes)
    utility = sign(v) * abs(v)^α
    utility *= v < 0 ? λ : 1
    return utility
end

function update_utility!(model::AbstractValenceExpectancy, choice_idx, outcomes)
    υ = model.υ
    υ[choice_idx] += model.Δ * (compute_utility(model, outcomes) - υ[choice_idx])
    return υ
end

function compute_probs(model::AbstractValenceExpectancy, trial_idx)
    (; υ, c) = model
    θ = min(300, (trial_idx / 10)^c)
    v = exp.(υ * θ)
    return v ./ sum(v)
end

function logpdf(model::AbstractValenceExpectancy, choices, outcomes)
    LL = 0.0
    for i ∈ 1:length(choices)
        probs = compute_probs(model, i)
        p = max(1e-10, probs[choices[i]])
        LL += log(p)
        update_utility!(model, choices[i], outcomes[i])
    end
    return LL
end

function rand(model::AbstractValenceExpectancy, gambles, n_trials::Int)
    choices = fill(0, n_trials)
    n_options = length(gambles)
    outcomes = fill(0.0, n_trials)
    for i ∈ 1:length(choices)
        probs = compute_probs(model, i)
        choice = sample(1:n_options, Weights(probs))
        choices[i] = choice
        outcome = sample(gambles[choice])
        outcomes[i] = outcome
        update_utility!(model, choice, outcome)
    end
    return choices, outcomes
end
