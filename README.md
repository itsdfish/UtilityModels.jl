# UtilityModels

UtilityModels.jl is a collection of utility based decision models. Currently, prospect theory is the only model in the collection, but more will be added in the future. 

## Example
````julia
using UtilityModels

α = .8; γg = .6; λ = 2.25
# By default, α=β  and γg = γl
model = ProspectTheory(;α, γg, λ)
p = [.3,.2,.3,.2]
v = [10.0,3.0,-2.0,-1.0]
gamble = Gamble(;p, v)
eu = mean(model, gamble)
````

Result:

````julia
julia> eu = mean(model, gamble)
0.7726777993737757
````
