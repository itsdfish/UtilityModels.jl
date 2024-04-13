"""
    UtilityModel

`UtilityModel` is an abstract utility-based model object
````
"""
abstract type UtilityModel <: ContinuousUnivariateDistribution end

"""
*mean*

`mean` generic method for computing mean

- `model`: a model M <: UtilityModel
- `gamble`: a gamble object

Function Signature
````julia
mean(model::UtilityModel, gamble::Gamble)
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

`var` a generic method for computing the variance of the gamble

- `model`: a model M <: UtilityModel
- `gamble`: a gamble object

"""
function var(model::UtilityModel, gamble::Gamble)
    (; p) = gamble
    utility = compute_utility(model, gamble)
    eu = mean(model, gamble)
    return sum(p .* (utility .- eu) .^ 2)
end

"""
    std(model::UtilityModel, gamble::Gamble)

`std` a generic method for computing the standard deviation of the gamble

- `model`: a model M <: UtilityModel
- `gamble`: a gamble object
"""
std(model::UtilityModel, gamble::Gamble) = sqrt(var(model, gamble))

"""
    compute_weights(model::UtilityModel, gamble::Gamble)

`compute_weights` a generic method for computing decision weights

- `model`: a model M <: UtilityModel
- `gamble`: a gamble object
"""
compute_weights(model::UtilityModel, gamble::Gamble) = gamble.p

"""
    sort!(model::UtilityModel, gamble)

`sort!` a generic method for sorting gamble probabilities and values. The generic method
does not sort the gambles

- `model`: a model
- `gamble`: a gamble object
"""
function sort!(model::UtilityModel, gamble)
    return nothing
end
