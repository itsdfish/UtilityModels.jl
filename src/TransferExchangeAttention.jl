"""
*TAX*

`TAX` constructs a model object for cummulative prospect theory. 
By default, parameters for utility curvature and probability weigting are equal gains and losses.

- `δ`: utility curvature for gains
- `γ`: probability weighting parameter for gains 
- `β`: utility curvature for losses

Constructor
````julia
TAX(;δ=.80, β=.3, γ=.70)
````
*References*

"""
mutable struct TAX{T1,T2,T3} <:UtilityModel
    δ::T1
    γ::T2
    β::T3
end

function TAX(;δ=.80, β=.3, γ=.70)
    return TAX(δ, γ, β)
end

"""
*compute_utility*

`compute_utility` computes utility of gamble outcomes according to prospect theory

- `model`: a model object for prospect theory
- `gamble`: a gamble object

Function Signature
````julia
compute_utility(model::TAX, gamble::Gamble)
````
"""
function compute_utility(model::ProspectTheory, gamble)
    @unpack α,β,λ = model
    @unpack vg,vl = gamble
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
compute_weights(model::TAX, gamble::Gamble)
````
"""
function compute_weights(model::TAX, gamble::Gamble)
    @unpack pg,pl = gamble
    @unpack γg,γl = model
    ω = [_compute_weights(pl, γl); _compute_weights(pg, γg)]
    return ω
end

weight(p, γ) = (p^γ)/(p^γ + (1-p)^γ)^(1/γ)