# UtilityModels.jl

This package provides a unified interface for developing and testing utility-based models of decision making. Utility-based models have roots in economics and cognitive science, and are bound together by their common assumption that options are evaluated by weighting and adding their features to form an overall impression called an expected utility. Consider a generic gamble, $O = (x_1, p_1; \dots ; x_n, p_n)$, where $x_i$ is a possible outcome which occurs with probability $p_i$. The expected utility can be expressed in the following form: 
```math
\mathrm{EU}(O) = \sum_{i=1}^n w(p_i) u(x_i),
``` 
where functions $w(p)$ and $u(x)$ transform objective probabilities and outcomes into subjective values. The option with a higher expected utility has a higher chance of selection. Utility-based models differ in their specification of $w(p)$ and $u(x)$.

# Package Ecosystem

UtilityModels.jl can be used with many packages in the Julia ecosystem because it uses the API defined in Distributions.jl. Here are a few examples of packages that are compatible with UtilityModels.jl:

- [Distributions.jl](https://github.com/JuliaStats/Distributions.jl): functions for probability distributions
- [Pigeons.jl](http://pigeons.run/dev/): Bayesian parameter estimation and Bayes factors
- [Turing.jl](https://turinglang.org/dev/docs/using-turing/get-started): Bayesian parameter estimation


# Installation

You can install a stable version of `SequentialSamplingModels` by running the following in the Julia REPL:

```julia
] add SequentialSamplingModels
```

# Quick Example

The code block below compares the expected utility and expected value using the TAX model.  
````@example quick_example
using UtilityModels
# TAX with default values
model = TAX()
# trinary gamble
gamble = Gamble(;
    p = [.25,.25,.50],
    v = [100.0,0.0,-50.0]
)
# expected utility vs. expected value
mean(model, gamble), mean(gamble)
````


