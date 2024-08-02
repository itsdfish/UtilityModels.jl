# UtilityModels

UtilityModels.jl is a collection of utility based decision models. Currently, expected utlity theory, transfer of attention exchange, and prospect theory are implemented. More models soon to follow. See the [documentation](https://itsdfish.github.io/UtilityModels.jl/dev/) for more details.

# Quick Example

````julia
using UtilityModels
# TAX with default values
model = TAX()
# trinary gamble
gamble = Gamble(;
    p = [.25,.25,.50],
    v = [100.0,0.0,-50.0]
)
# expected utility
mean(model, gamble)
````
````julia
# output
-15.51253
````
