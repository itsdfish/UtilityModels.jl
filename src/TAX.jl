"""
*TAX*

`TAX` constructs a model object for transfer of attention exchange.

- `δ`: transfer of attention parameter
- `γ`: probability weighting parameter
- `β`: utility curvature

Constructor
````julia
TAX(;δ=.80, β=.3, γ=.70)
````
*References*

Birnbaum, M. H., & Chavez, A. (1997). Tests of theories of decision making: Violations of branch independence and distribution independence. Organizational Behavior and human decision Processes, 71(2), 161-194.
Birnbaum, M. H. (2008). New paradoxes of risky decision making. Psychological review, 115(2), 463.

"""
mutable struct TAX{T1,T2,T3} <:UtilityModel
    δ::T1
    γ::T2
    β::T3
end

function TAX(;δ=-1.0, β=1.0, γ=.70)
    return TAX(δ, γ, β)
end

"""
*compute_utility*

`compute_utility` computes utility of gamble outcomes according to TAX

- `model`: a model object for TAX
- `gamble`: a gamble object

Function Signature
````julia
compute_utility(model::TAX, gamble::Gamble)
````
"""
function compute_utility(model::TAX, gamble)
    @unpack β = model
    @unpack v = gamble
    utility = @. sign(v)*abs(v)^β 
    return utility
end

tax_weight(p, γ) = (p^γ)

function ω(p, pk, n, δ, γ)
    if δ > 0
        return δ*tax_weight(pk, γ)/(n+1)
    end
    return δ*tax_weight(p, γ)/(n+1)
end

function sort!(model::TAX, gamble)
    @unpack p,v = gamble
    i = sortperm(v)
    p .= p[i]; v .= v[i]
    return nothing
end

"""
*mean*

`mean` a method for computing the mean for the TAX model

- `model`: a model M <: UtilityModel
- `gamble`: a gamble object

Function Signature
````julia
mean(model::TAX, gamble::Gamble)
````
"""
function mean(model::TAX, gamble::Gamble)
    @unpack p,v = gamble
    @unpack γ,δ = model
    n = length(p)
    sort!(model, gamble)
    utility = compute_utility(model, gamble)
    eu = 0.0
    sum_weight = 0.0
    for i in 1:n
        eu += tax_weight(p[i], γ)*utility[i]
        sum_weight += tax_weight(p[i], γ)
        for k in 1:(i-1)
            eu += (utility[i] - utility[k])*ω(p[i], p[k], n, δ, γ)
        end
    end
    return eu/sum_weight
end

function var(model::TAX, gamble::Gamble)
    error("var not implimented for TAX")
    return -100.0
end