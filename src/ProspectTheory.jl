"""
*ProspectTheory*

`ProspectTheory` constructs a model object for cummulative prospect theory. 
By default, parameters for utility curvature and probability weigting are equal gains and losses.

- `α`: utility curvature for gains
- `β`: utility curvature for losses
- `γg`: probability weighting parameter for gains 
- `γl`: probability weighting parameter for losses
- `λ`: loss aversion parameter

Constructor
````julia
ProspectTheory(;α=.80, β=α, γg=.70, γl=γg, λ=2.25)
````
*References*

Fennema, H., & Wakker, P. (1997). Original and cumulative prospect theory: A discussion of empirical differences. Journal of Behavioral Decision Making, 10(1), 53-64.

Tversky, A., & Kahneman, D. (1992). Advances in prospect theory: Cumulative representation of uncertainty. Journal of Risk and uncertainty, 5(4), 297-323.
"""
mutable struct ProspectTheory{T1,T2,T3,T4,T5} <:UtilityModel
    α::T1
    β::T2
    γg::T3
    γl::T4
    λ::T5
end

function ProspectTheory(;α=.80, β=α, γg=.70, γl=γg, λ=2.25)
    return ProspectTheory(α, β, γg, γl, λ)
end

"""
*compute_utility*

`compute_utility` computes utility of gamble outcomes according to prospect theory

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
compute_utility(model::ProspectTheory, gamble::Gamble)
````
"""
function compute_utility(model::ProspectTheory, gamble)
    @unpack α,β,λ = model
    vl,vg = split_values(gamble)
    utilg = vg.^α
    utill = @. -λ*abs(vl)^β 
    return [utill; utilg]
end

"""
*compute_weights*

`compute_weights` computes decision weights based on cummulative outcomes

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
compute_weights(model::ProspectTheory, gamble::Gamble)
````
"""
function compute_weights(model::ProspectTheory, gamble::Gamble)
    pl,pg = split_probs(gamble)
    @unpack γg,γl = model
    ω = [_compute_weights(pl, γl); _compute_weights(pg, γg)]
    return ω
end

"""
*_compute_weights*

`_compute_weights` computes decision weights based on cummulative outcomes

- `p`: a probability vector
- `γ`: parameter that controls weighting of low and high probabilities

Function Signature
````julia
_compute_weights(p, γ)
````
"""
function _compute_weights(p, γ)
    n = length(p)
    f(i) = weight(sum(p[i:n]), γ) - weight(sum(p[(i+1):n]), γ)
    ω = [f(i) for i in 1:n-1]
    isempty(p) ? nothing : push!(ω, weight(p[n], γ))
    return ω
end

weight(p, γ) = (p^γ)/(p^γ + (1-p)^γ)^(1/γ)

function sort!(model::ProspectTheory, gamble)
    @unpack p,v = gamble
    i = sortperm(v)
    p .= p[i]; v .= v[i]
    gains = v .>= 0
    pl = @view p[.!gains]
    vl = @view v[.!gains]
    reverse!(vl); reverse!(pl)
    return nothing
end

function split_values(gamble)
    @unpack v = gamble
    gains = v .>= 0
    vg = @view v[gains] 
    vl = @view v[.!gains]
    return vl,vg
end

function split_probs(gamble)
    @unpack v,p = gamble
    gains = v .>= 0
    pg = @view p[gains] 
    pl = @view p[.!gains]
    return pl,pg
end