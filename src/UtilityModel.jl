"""
    UtilityModel <: ContinuousUnivariateDistribution

`UtilityModel` is an abstract utility-based model object
````
"""
abstract type UtilityModel <: ContinuousUnivariateDistribution end

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
- `choice_idx::Int`: the index for the chosen gamble
"""
function pdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice_idx::Int)
    utility = mean.(model, gambles)
    util_exp = exp.(model.θ .* utility)
    return util_exp[choice_idx] ./ sum(util_exp)
end

"""
    logpdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice::Int)

Computes the choice log probability for a vector of gambles. 

# Arguments

- `model::UtilityModel`: a utility model 
- `gambles::Vector{<:Gamble}`: a vector of gambles representing a choice set
- `choice_idx::Int`: the index for the chosen gamble
"""
function logpdf(model::UtilityModel, gambles::Vector{<:Gamble}, choice_idx::Int)
    utility = mean.(model, gambles)
    util_scaled = model.θ .* utility
    return util_scaled[choice_idx] - logsumexp(util_scaled)
end

"""
    rand(model::UtilityModel, gambles::Vector{<:Gamble})

Generates a simulated choice  

# Arguments

- `model::UtilityModel`: a utility model 
- `gambles::Vector{<:Gamble}`: a vector of gambles representing a choice set
"""
function rand(model::UtilityModel, gambles::Vector{<:Gamble})
    utility = mean.(model, gambles)
    util_exp = exp.(model.θ .* utility)
    probs =  util_exp ./ sum(util_exp)
    return sample(1:length(gambles), Weights(probs))
end