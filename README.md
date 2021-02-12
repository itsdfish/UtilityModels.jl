# UtilityModels

UtilityModels.jl is a collection of utility based decision models. Currently, expected utlity theory, transfer of attention exchange, and prospect theory are implemented. More models soon to follow. 

# Installation

In the REPL, enter `]` to activate package mode, then type

````julia 
add UtilityModels
````
# Help

In the REPL, enter `?` to activate help mode, then type the name of the function or object, such as:

````julia
TAX
````

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

## Transfer of Attention Exchange

````julia
using UtilityModels
# TAX with default values
model = TAX()
p = [.25,.25,.50]
v = [100.0,0.0,-50.0]
gamble = Gamble(;p, v)
````
### Expected Utility

````julia
eu = mean(model, gamble)
````

*References*

1. Birnbaum, M. H., & Chavez, A. (1997). Tests of theories of decision making: Violations of branch independence and distribution independence. Organizational Behavior and human decision Processes, 71(2), 161-194.
2. Birnbaum, M. H. (2008). New paradoxes of risky decision making. Psychological review, 115(2), 463.

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
3.7516
````

*References*

1. Fennema, H., & Wakker, P. (1997). Original and cumulative prospect theory: A discussion of empirical differences. Journal of Behavioral Decision Making, 10(1), 53-64.

2. Tversky, A., & Kahneman, D. (1992). Advances in prospect theory: Cumulative representation of uncertainty. Journal of Risk and uncertainty, 5(4), 297-323.
