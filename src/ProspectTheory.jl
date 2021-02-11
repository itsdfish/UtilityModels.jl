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

weight(p, γ) = (p^γ)/(p^γ + (1-p)^γ)^(1/γ)

"""
*mean*

`mean` computes the expected utility given a model and a gamble

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
mean(model::ProspectTheory, gamble::Gamble)
````
"""
function mean(model::ProspectTheory, gamble::Gamble)
    @unpack γg,γl,λ = model
    @unpack pg,pl = gamble
    ωg = compute_weights(pg, γg)
    ωl = compute_weights(pl, γl)
    utill, utilg = compute_utility(model, gamble)
    return sum(λ*ωl.*utill) + sum(ωg.*utilg)
end

"""
*var*

`var` computes the expected utility given a model and a gamble

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
var(model::ProspectTheory, gamble::Gamble)
````
"""
function var(model::ProspectTheory, gamble::Gamble)
    @unpack γg,γl,λ = model
    @unpack pg,pl = gamble
    eu = mean(model, gamble)
    ωg = compute_weights(pg, γg)
    ωl = compute_weights(pl, γl)
    utill, utilg = compute_utility(model, gamble)
    return sum(ωl .* (utill .- eu).^2) + sum(ωg .* (utilg .- eu).^2)
end

"""
*std*

`std` computes the expected utility given a model and a gamble

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
std(model::ProspectTheory, gamble::Gamble)
````
"""
std(model::ProspectTheory, gamble::Gamble) = sqrt(var(model, gamble))

"""
*compute_weights*

`compute_weights` computes decision weights based on cummulative outcomes

- `p`: a probability vector
- `γ`: parameter that controls weighting of low and high probabilities

Function Signature
````julia
compute_weights(p, γ)
````
"""
function compute_weights(p, γ)
    n = length(p)
    f(i) = weight(sum(p[i:n]), γ) - weight(sum(p[(i+1):n]), γ)
    ω = [f(i) for i in 1:n-1]
    isempty(p) ? nothing : push!(ω, weight(p[n], γ))
    return ω
end

function compute_utility(model::ProspectTheory, gamble)
    @unpack α,β = model
    @unpack vg,vl = gamble
    utilg = vg.^α
    utill = @. -abs(vl)^β 
    return utill, utilg
end