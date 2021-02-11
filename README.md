# UtilityModels

UtilityModels.jl is a collection of utility based decision models. Currently, expected utlity theory and prospect theory are the only models in the collection, but more will be added in the future. 

# Examples

## Expected Utility Theory
````julia
using UtilityModels

α = .8
model = ExpectedUtility(α)
p = [.3,.2,.3,.2]
v = [10.0,3.0,-2.0,-1.0]
gamble = Gamble(;p, v)
````
### Expected Utility

````julia
mean(model, gamble)
1.65219
````

### Standard Deviation of Utility

````julia
std(model, gamble)
3.38863
````

## Prospect Theory
````julia
using UtilityModels

α = .8; γg = .6; λ = 2.25
# By default, α=β  and γg = γl
model = ProspectTheory(;α, γg, λ)
p = [.3,.2,.3,.2]
v = [10.0,3.0,-2.0,-1.0]
gamble = Gamble(;p, v)
````
### Expected Utility

````julia
mean(model, gamble)
0.77268
````

### Standard Deviation of Utility

````julia
std(model, gamble)
3.50402
````
