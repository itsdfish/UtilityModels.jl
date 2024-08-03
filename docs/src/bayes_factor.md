# Computing the Bayes Factor

## Overview

In this tutorial, we will use the Bayes factor to compare the evidence for one model relative to another reference model. Computing the Bayes factor is challenging because it requires integrating the log likelihood over the model parameters. One method for approximating this complex integral is non-reversible parallel tempering (Bouchard-Côté et al., 2022) using 
[Pigeons.jl](https://julia-tempering.github.io/Pigeons.jl/dev/). 

In the tutorial below, we will compare two models which differ only in terms of assumptions about drift rate variability: the LBA and the RDM. The LBA assumes that the drift rate varies across trials and is otherwise deterministic, whereas the RDM assumes the drift rate varies within a trial as Gaussian noise, but not across trials. The difference between the models can be visualized with Plots.jl:

### RDM
```@setup bayes_factor
using Random
using UtilityModels
using Plots
```


## Load Packages

Before proceeding, we will load the required packages.
```julia
using LinearAlgebra
using Pigeons
using Random
using UtilityModels
using Turing
```

## Define Choice Sets

The eight choice sets below were taken from Birnbaum (2008). 
```julia
choice_sets = [
    [
        Gamble(; p = [0.20, 0.20, 0.60], v = [58, 56, 2]),
        Gamble(; p = [0.20, 0.20, 0.60], v = [96, 4, 2])
    ],
    [
        Gamble(; p = [0.45, 0.45, 0.10], v = [58, 56, 2]),
        Gamble(; p = [0.45, 0.45, 0.10], v = [96, 4, 2])
    ],
    [
        Gamble(; p = [0.80, 0.10, 0.10], v = [110, 44, 40]),
        Gamble(; p = [0.80, 0.10, 0.10], v = [110, 98, 10])
    ],
    [
        Gamble(; p = [0.80, 0.10, 0.10], v = [98, 98, 2]),
        Gamble(; p = [0.80, 0.10, 0.10], v = [40, 40, 2])
    ],
    [
        Gamble(; p = [0.80, 0.10, 0.10], v = [98, 2, 2]),
        Gamble(; p = [0.80, 0.10, 0.10], v = [40, 40, 2])
    ],
    [
        Gamble(; p = [.05, .05, .90], v = [96, 12, 3]),
        Gamble(; p = [.05, .05, .90], v = [52, 48, 3]),
    ],
    [
        Gamble(; p = [.50, .25, .25], v = [0, -800, -1_000]),
        Gamble(; p = [.50, .25, .25], v = [0, -200, -1_600]),
    ],
    [
        Gamble(; p = [.25, .25, .25, .25], v = [2_000, 800, -800, -1_000]),
        Gamble(; p = [.25, .25, .25, .25], v = [1_600, 1_200, -200, -1_600]),
    ],
    [
        Gamble(; p = [.50, .25, .25], v = [0, 50, 50]),
        Gamble(; p = [.50, .25, .25], v = [0, 0, 100]),
    ],
    [
        Gamble(; p = [.50, .25, .25], v = [0, -50, -50]),
        Gamble(; p = [.50, .25, .25], v = [0, 0, -100]),
    ],
    [
        Gamble(; p = [.59, .20, .20, .01], v = [110, 49, 45, 4]),
        Gamble(; p = [.59, .20, .20, .01], v = [110, 97, 11, 4]),
    ],
    [
        Gamble(; p = [.59, .20, .20, .01], v = [4, 45, 49, 110]),
        Gamble(; p = [.59, .20, .20, .01], v = [4, 11, 97, 110]),
    ],
    [
        Gamble(; p = [.48, .48, .02], v = [48, 40, 2]),
        Gamble(; p = [.48, .48, .02], v = [96, 4, 2]),
    ]
]
```
## Data-Generating Model

The next step is to generate simulated data for comparing the models. Here, we will assume that the LBA is the
true data generating model:
```julia
Random.seed!(554)
model = TAX(; 
    δ = .70, 
    β = .60, 
    γ = 0.70, 
    θ = 1.0
)
# repetitions per choice set
ns = fill(10, length(choice_sets))
choices = rand.(model, choice_sets, ns)
data = (choice_sets,choices)
```

## Define Models 
The following code blocks define the models along with their prior distributions using [Turing.jl](https://turinglang.org/stable/). Notice that the models are identical except for the log likelihood function.

### TAX

```julia
@model function tax(data)
    β ~ Gamma(.2, 4)
    γ ~ Gamma(.2, 4)
    δ ~ Normal(0, 2)
    data ~ TAX(; δ, γ, β)
end
```

## Prospect Theory 

```julia
@model function prospect_theory(data)
    α ~ Gamma(.2, 4)
    γg ~ Gamma(.2, 4)
    λ ~ truncated(Normal(2, 5), 0, Inf)
    data ~ ProspectTheory(; α, γg, λ)
end
```
## Estimate Marginal Log Likelihood
The next step is to run the `pigeons` function to estimate the marginal log likelihood for each model. 
### TAX
```julia
pt_tax = pigeons(target=TuringLogPotential(tax(data)), record=[traces])
```
```julia
────────────────────────────────────────────────────────────────────────────
  #scans       Λ      log(Z₁/Z₀)   min(α)     mean(α)    min(αₑ)   mean(αₑ) 
────────── ────────── ────────── ────────── ────────── ────────── ──────────
        2        3.3      -24.5   4.43e-56      0.634          1          1 
        4       1.88       42.2      0.331      0.791          1          1 
        8       3.05       40.2     0.0393      0.661          1          1 
       16       3.33       41.1      0.364       0.63          1          1 
       32       3.05       41.3      0.396      0.662          1          1 
       64       3.52       40.6      0.423      0.609          1          1 
      128       3.26       41.4       0.56      0.638          1          1 
      256       3.45       40.8      0.564      0.617          1          1 
      512       3.48       40.8      0.578      0.613          1          1 
 1.02e+03       3.33       40.9      0.596      0.629          1          1 
────────────────────────────────────────────────────────────────────────────
```
### Prospect Theory
```julia
pt_prospect_theory = pigeons(target=TuringLogPotential(prospect_theory(data)), record=[traces])
```

```julia
────────────────────────────────────────────────────────────────────────────
  #scans       Λ      log(Z₁/Z₀)   min(α)     mean(α)    min(αₑ)   mean(αₑ) 
────────── ────────── ────────── ────────── ────────── ────────── ──────────
        2       4.73       31.6   0.000606      0.475          1          1 
        4       2.83       43.1       0.42      0.686          1          1 
        8       3.05       39.8    0.00128      0.661          1          1 
       16       3.46       41.2      0.268      0.615          1          1 
       32       3.81       40.9      0.328      0.577          1          1 
       64       3.16       40.6      0.404      0.649          1          1 
      128       3.26       41.3      0.569      0.638          1          1 
      256        3.3       40.6       0.56      0.633          1          1 
      512       3.38       40.9       0.55      0.625          1          1 
 1.02e+03       3.45       40.7      0.589      0.617          1          1
```
## Extract marginal log likelihood
In the following code block, the function `stepping_stone` extracts that marginal log likelihood:
```julia
mll_lba = stepping_stone(pt_lba)
mll_rdm = stepping_stone(pt_rdm)
```

## Compute the Bayes Factor
The bayes factor is obtained by exponentiating the difference between marginal log likelihoods. The value of `1.21` indicates that the LBA is `1.21` times more likely to have generated the data. 
```julia
bf = exp(mll_lba - mll_rdm)
```
```julia 
1.2070298459526883
```
# References

Syed, S., Bouchard-Côté, A., Deligiannidis, G., & Doucet, A. (2022). Non-reversible parallel tempering: a scalable highly parallel MCMC scheme. Journal of the Royal Statistical Society Series B: Statistical Methodology, 84(2), 321-350.