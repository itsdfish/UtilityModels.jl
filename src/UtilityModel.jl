"""
    UtilityModel <: DiscreteMultivariateDistribution

`UtilityModel` is an abstract type for  utility-based models
````
"""
abstract type UtilityModel <: DiscreteMultivariateDistribution end

"""
    mean(model::UtilityModel, gamble::Gamble)

Computes mean or expected utility

# Arguments 

- `model::UtilityModel`: a model M <: UtilityModel
- `gamble::Gamble`: a gamble object
````
"""
function mean(model::UtilityModel, gamble::Gamble)
    sort!(model, gamble)
    weights = compute_weights(model, gamble)
    utility = compute_utility(model, gamble)
    return weights' * utility
end

Base.broadcastable(model::UtilityModel) = Ref(model)
length(model::UtilityModel) = 1

"""
    var(model::UtilityModel, gamble::Gamble)

Computes the variance of the gamble

# Arguments

- `model::UtilityModel`: a utility model 
- `gamble::Gamble`: a gamble object
"""
function var(model::UtilityModel, gamble::Gamble)
    (; p) = gamble
    utility = compute_utility(model, gamble)
    eu = mean(model, gamble)
    return sum(p .* (utility .- eu) .^ 2)
end

"""
    std(model::UtilityModel, gamble::Gamble)

Computes the standard deviation of the gamble

# Arguments 

- `model::UtilityMode`: a model M <: UtilityModel
- `gamble::Gamble`: a gamble object
"""
std(model::UtilityModel, gamble::Gamble) = sqrt(var(model, gamble))

"""
    compute_weights(model::UtilityModel, gamble::Gamble)

Computes decision weights as `gamble.p` by default .

# Arguments

- `model::UtilityModel`: a model M <: UtilityModel
- `gamble::Gamble`: a gamble object
"""
compute_weights(model::UtilityModel, gamble::Gamble) = gamble.p

"""
    sort!(model::UtilityModel, gamble)

Sorts gamble probabilities and values. The generic method
does not sort the gambles

# Arguments

- `model::UtilityModel`: a utility model 
- `gamble::Gamble`: a gamble object
"""
function sort!(model::UtilityModel, gamble::Gamble) end

"""
    pdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice::Int)

Computes the choice probability for a vector of gambles. 

# Arguments

- `model::UtilityModel`: a utility model 
- `gambles::Vector{<:Gamble}`: a vector of gambles representing a choice set
- `choice_idxs::Vector{<:Int}`: indices for the chosen gambles
"""
function pdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice_idxs::Vector{<:Int})
    utility = mean.(model, gambles)
    util_exp = exp.(model.θ .* utility)
    n = sum(choice_idxs)
    p = util_exp ./ sum(util_exp)
    return pdf(Multinomial(n, p), choice_idxs)
end

"""
    logpdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice::Int)

Computes the choice log probability for a vector of gambles. 

# Arguments

- `model::UtilityModel`: a utility model 
- `gambles::Vector{<:Gamble}`: a vector of gambles representing a choice set
- `choice_idxs::Vector{<:Int}`: indices for the chosen gambles
"""
function logpdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice_idxs::Vector{<:Int})
    utility = mean.(model, gambles)
    util_exp = exp.(model.θ .* utility)
    T = typeof(model.θ)
    n = sum(choice_idxs)
    p = util_exp ./ sum(util_exp)
    !isprobvec(p) ? (return T(-Inf)) : nothing
    return logpdf(Multinomial(n, p), choice_idxs)
end

isprobvec(p::AbstractVector{<:Real}) =
    all(x -> x ≥ zero(x), p) && isapprox(sum(p), one(eltype(p)))

function logpdf(model::UtilityModel, data::Tuple)
    return logpdf(model, data[1], data[2])
end

loglikelihood(
    model::UtilityModel,
    data::Tuple{Vector{<:Vector{<:Gamble}}, Vector{<:Vector{<:Integer}}}
) = loglikelihood(model, data[1], data[2])

loglikelihood(
    model::UtilityModel,
    gambles::Vector{<:Vector{<:Gamble}},
    choices::Vector{<:Vector{<:Integer}}
) = sum(logpdf.(model, gambles, choices))

loglikelihood(
    model::UtilityModel,
    gambles::Vector{<:Gamble},
    choices::Vector{<:Integer}
) = sum(logpdf(model, gambles, choices))

loglikelihood(
    model::UtilityModel,
    data::Tuple{Vector{<:Gamble}, Vector{<:Integer}}
) = sum(logpdf(model, data[1], data[2]))

"""
    rand(model::UtilityModel, gambles::Vector{<:Gamble})

Generates a simulated choice  

# Arguments

- `model::UtilityModel`: a utility model 
- `gambles::Vector{<:Gamble}`: a vector of gambles representing a choice set
"""
function rand(model::UtilityModel, gambles::Vector{<:Gamble}, n_sim::Int = 1)
    utility = mean.(model, gambles)
    util_exp = exp.(model.θ .* utility)
    probs = util_exp ./ sum(util_exp)
    if any(isnan, probs)
        probs = utility[1] > utility[2] ? [1 - eps(), eps()] : [eps(), 1 - eps()]
    end
    return rand(Multinomial(n_sim, probs))
end
