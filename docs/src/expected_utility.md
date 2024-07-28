# Expected Utility Theory

The Leaky Competing Accumulator (LCA; Usher & McClelland, 2001) is a sequential sampling model in which evidence for options races independently. The LCA is similar to the Linear Ballistic Accumulator (LBA), but additionally assumes an intra-trial noise and leakage (in contrast, the LBA assumes that evidence accumulates in a ballistic fashion, i.e., linearly and deterministically until it hits the threshold).

# Example
In this example, we will demonstrate how to use the LCA in a generic two alternative forced choice task. 
```@setup expected_utility
using Plots
using Random
using UtilityModels
```

## Load Packages
The first step is to load the required packages.

```@example expected_utility
using Plots
using Random
using UtilityModels
Random.seed!(8741)
```
## Create Choice Set

We will consider the following two options in this example. Note that the package can handle choices between an arbitrary number of options.

```@example expected_utility
gamble1 = Gamble(; 
    p = [.20, .20, .60], 
    v = [58, 56, 2]
)

gamble2 = Gamble(; 
    p = [.20, .20, .60], 
    v = [96, 4, 2]
)
gambles = [gamble1,gamble2]
```

## Create Model Object
In the code below, we will define parameters for the LBA and create a model object to store the parameter values. 

### Utility Curvature

The utility curvature parameter $\alpha$ controls whether the utility function is concave, linear, or convex. The utility function is given by:

```math
U(x) = \mathrm{sign}(x)|x|^\alpha.
```
The parameter $\alpha$ can be intrepreted in terms of risk profile as follows: 

- risk averse: ``0 \geq \alpha < 1``
- risk neutral: ``\alpha = 1``
- risk seeking: ``\alpha > 1``

The utility function $U(x)$ is plotted below for a range of values of $\alpha$.

```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example expected_utility
model = ExpectedUtility()
vals = [-20:.5:20;]
gamble = Gamble(; v = vals)
αs = range(0, 1.5, length = 5) 
utilities = [compute_utility(ExpectedUtility(; α) , gamble) for α ∈ αs]
utility_plot = plot(vals, utilities, xlabel = "x", ylabel = "U(x)", labels = αs', legendtitle = "α", grid = false)
```
```@raw html
</details>
```
```@example expected_utility
utility_plot
```

Below, we set the $\alpha$ parameter to a value associated with moderate risk aversion. 
```@example expected_utility
α = .80
```

### Decisional Consistency 

The parameter $\theta$—sometimes known as decisional consistency or sensitivity—controls how deterministically a model selects the option with the higher expected utility. In the equation below, the probability of selecting $\x_i$ from choice set $\{x_1,\dots, x_n\}$ is computed with the soft max function.

```math
\Pr(X = x_i \mid \{x_1, \dots, x_n\}) = \frac{e^{\theta \cdot \mathrm{EU}(x_i)}}{\sum_{j=1}^n e^{\theta \cdot \mathrm{EU}(x_j)}}
```
As shown in the plot below,  parameter $\theta$ modulates the choice probability.

```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example expected_utility
vals = [-10:.1:10;]
θs = range(0, 2, length = 5) 
probs = [pdf(ExpectedUtility(; α = 1, θ) , [Gamble(; p = [1], v = [0]), Gamble(; p = [1], v=[v])], [1,0]) for v ∈ vals, θ ∈ θs]
prob_plot = plot(reverse!(vals), probs, xlabel = "U(A) - U(B)", ylabel = "Probability A", labels = θs', legendtitle = "θ", grid = false)
```
```@raw html
</details>
```
```@example expected_utility
prob_plot
```
We will set $\theta$ to the following value:

```@example expected_utility
θ = 1.0
```

### Expected Utility Constructor 

Now that values have been asigned to the parameters, we will pass them to `ExpectedUtility` to generate the model object.

```@example expected_utility
dist = ExpectedUtility(; α, θ)
```

## Expected Utility

The expected utilities of each gamble can be computed via `mean` as demonstrated below:

```@example expected_utility
mean.(dist, gambles)
```

## Standard Deviation Utility

The standard deviation of utilities of each gamble can be computed via `std` as demonstrated below:

```@example expected_utility
std.(dist, gambles)
```
The larger standard deviation of the second gamble indicates it is a riskier option.  

## Simulate Model

Now that the model is defined, we will generate $10$ choices using `rand`. 

 ```@example expected_utility
 choices = rand(dist, gambles, 10)
```
In the code block above, the output is a sample from a multinomial distribution in which the 

## Compute Choice Probability

The probability of choosing the first option can be obtained as follows: 

 ```@example expected_utility
pdf(dist, gambles, [1,0])
```
The relatively high choice probability for the first option makes sense in light of its higher expected value (and lower variance).

## Multiple Choice Sets
The logic above can be easily extended to situations involving multiple choice sets by wrapping them in vectors. Consider the following situation involing two repetitions of two choice sets:
 ```@example expected_utility
choice_sets = [
    [
        Gamble(; p = [0.20, 0.20, 0.60], v = [58, 56, 2]),
        Gamble(; p = [0.20, 0.20, 0.60], v = [96, 4, 2])
    ],
    [
        Gamble(; p = [0.45, 0.45, 0.10], v = [58, 56, 2]),
        Gamble(; p = [0.45, 0.45, 0.10], v = [96, 4, 2])
    ]
]
```
Next, we simulate two choices for each choice set:
 ```@example expected_utility
choices = rand.(dist, choice_sets, [2,2])
```
Finally, we compute the joint choice probabilities for each choice set:
 ```@example expected_utility
choices = pdf.(dist, choice_sets, choices)
```