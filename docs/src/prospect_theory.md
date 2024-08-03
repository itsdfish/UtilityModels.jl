# Prospect Theory

Prospect theory is a generalization of expected utility theory designed to describe human decision making rather than propose a theory of optional decision making. In particular, prospect theory incorporates loss aversion and non-linear subjective probabilities to yield a more accurate description of human decision making. 

# Example
In this example, we will demonstrate how to use prosepect theory with a choice between two gambles. 
```@setup prospect_theory
using LaTeXStrings
using Plots
using Random
using UtilityModels
```

## Load Packages
The first step is to load the required packages.

```@example prospect_theory
using LaTeXStrings
using Plots
using Random
using UtilityModels
Random.seed!(214)
```
## Create Choice Set

We will consider the following two options in this example: $\mathbf{G}_1 = (58, .20; 56, .20; 2, .60)$ and $\mathbf{G}_2 = (96, .20; 4, .20; 2, .60)$. Note that the package can handle choices between an arbitrary number of options, each with an arbitrary number of outcomes.

```@example prospect_theory
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

### Utility Function 

The utility function for prospect theory is given by:

```math
U(x) = \begin{cases} 
      x^\alpha  & \geq 0 \\
      -\lambda |x|^\beta & \mathrm{ otherwise}\\
\end{cases}.
```
Next, we will explain the three parameters $\alpha$, $\beta$, and $\lambda$.

### Utility Curvature

The utility curvature parameters controls whether the utility function is concave, linear, or convex. Unlike expected utility theory, prospect theory allows the curvature to differ for gains and losses. However, for simplicity, we will assume $\alpha = \beta$. 

The parameters $\alpha$ and $\beta$ can be intrepreted in terms of risk profile as follows: 

- risk averse: ``0 \geq \alpha, \beta < 1``
- risk neutral: ``\alpha, \beta = 1``
- risk seeking: ``\alpha, \beta > 1``

The utility function $U(x)$ is plotted below for a range of values of $\alpha$.

```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example prospect_theory
model = ProspectTheory()
vals = [-20:.5:20;]
gamble = Gamble(; v = vals)
αs = range(0, 1.5, length = 5) 
utilities = [compute_utility(ProspectTheory(; α, λ = 1) , gamble) for α ∈ αs]
utility_plot = plot(vals, utilities, xlabel = "x", ylabel = "U(x)", labels = αs', legendtitle = "α", grid = false, xlims = (-20,20), ylims = (-75, 75))
```
```@raw html
</details>
```
```@example prospect_theory
utility_plot
```

Below, we set the $\alpha$ parameter to a value associated with moderate risk aversion. 
```@example prospect_theory
α = β = .80
```
### Loss Aversion 

The parameter $\lambda \geq 1$ for loss aversion embodies the notion that *losses loom larger than gains*. As shown in the utility function above, the utility of losses is scaled by parameter $\lambda$ to make it more impactful than a gain of equivalent magnitude. 

The plot below illustrates the effect of varying $\lambda$ for $\alpha = \beta = .80$. 

```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example prospect_theory
model = ProspectTheory()
vals = [-20:.5:20;]
gamble = Gamble(; v = vals)
λs = range(1, 2.5, length = 5) 
utilities = [compute_utility(ProspectTheory(; α = .80, λ) , gamble) for λ ∈ λs]
loss_aversion_plot = plot(vals, utilities, xlabel = "x", ylabel = "U(x)", labels = λs', legendtitle = "λ", grid = false, lims = (-20,20))
```
```@raw html
</details>
```
```@example prospect_theory
loss_aversion_plot
```

We will assign the following value to the loss aversion parameter:

```@example prospect_theory
λ = 2
```

### Probability Weighting 

In prospect theory, outcome probabilities are not necessarily treated objectively. Instead, outcome probabilities are transformed into subjective weights, akin to the transformation of outcomes in the utility function. The weighting function is defined as follows:

```math
w(p) = \frac{p^\gamma}{(p^\gamma + (1 - p)^\gamma)^{\frac{1}{\gamma}}},
```
where parameter $\gamma$ controls the non-linear weighting. As shwon in the plot below, the behavior of the parameter $\gamma$ is defined
on the following ranges:

- overweight small probabilities, underweight large probabilities: ``0 \geq \gamma  < 1``
- objective weighting: ``\gamma = 1``
- underweight small probabilities, overweight large probabilities: ``\gamma > 1``


```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example prospect_theory
using UtilityModels: compute_weights
model = ProspectTheory()
probs = 0:.005:1
γgs = range(.5, 2, length = 5) 
weights = [compute_weights.(ProspectTheory(; α = .80) , probs, γg) for γg ∈ γgs]
probability_weight_plot  = plot(probs, weights, xlabel = "p", ylabel = "W(p)", labels = γgs', legendtitle = L"\gamma_g", grid = false)
plot!(probs, probs, color = :black, linestyle = :dash, label = "")
```
```@raw html
</details>
```
```@example prospect_theory
probability_weight_plot
```
In its most general form, prospect theory includes a parameter $\gamma_g$ for the gain domain, and parameter $\gamma_l$ for the loss domain. For simplicity, we will assume $\gamma_g = \gamma_l$:

```@example prospect_theory
γg = γl = 0.7
```

### Decisional Consistency 

The parameter $\theta$—sometimes known as decisional consistency or sensitivity—controls how deterministically a model selects the option with the higher expected utility. In the equation below, the probability of selecting $\mathbf{G}_i$ from choice set $\{\mathbf{G}_1,\dots, \mathbf{G}_n\}$ is computed with the soft max function.

```math
\Pr(\mathbf{G}_i \mid \{\mathbf{G}_1, \dots, \mathbf{G}_n\}) = \frac{e^{\theta \cdot \mathrm{EU}(\mathbf{G}_i)}}{\sum_{j=1}^n e^{\theta \cdot \mathrm{EU}(\mathbf{G}_j)}}
```
As shown in the plot below, parameter $\theta$ modulates the choice probability.

```@raw html
<details><summary>Show Plotting Code</summary>
```
```@example prospect_theory
vals = [-10:.1:10;]
θs = range(0, 2, length = 5) 
probs = [pdf(ProspectTheory(; α = 1, θ) , [Gamble(; p = [1], v = [0]), Gamble(; p = [1], v=[v])], [1,0]) for v ∈ vals, θ ∈ θs]
prob_plot = plot(reverse!(vals), probs, xlabel = "U(A) - U(B)", ylabel = "Probability A", labels = θs', legendtitle = "θ", grid = false)
```
```@raw html
</details>
```
```@example prospect_theory
prob_plot
```
We will set $\theta$ to the following value:

```@example prospect_theory
θ = 1.0
```

### Prospect Theory Constructor 

Now that values have been asigned to the parameters, we will pass them to `ProspectTheory` to generate the model object.

```@example prospect_theory
dist = ProspectTheory(; α, β, λ, γg, γl, θ)
```

## Expected Utility

The expected utilities of each gamble can be computed via `mean` as demonstrated below:

```@example prospect_theory
mean.(dist, gambles)
```

## Standard Deviation Utility

The standard deviation of utilities of each gamble can be computed via `std` as demonstrated below:

```@example prospect_theory
std.(dist, gambles)
```
The larger standard deviation of the second gamble indicates it is a riskier option.  

## Simulate Model

Now that the model is defined, we will generate $10$ choices using `rand`. 

 ```@example prospect_theory
 choices = rand(dist, gambles, 10)
```
In the code block above, the output is a sample from a multinomial distribution in which the 

## Compute Choice Probability

The probability of choosing the first option can be obtained as follows: 

 ```@example prospect_theory
pdf(dist, gambles, [1,0])
```
The relatively high choice probability for the first option makes sense in light of its higher expected value (and lower variance).

## Multiple Choice Sets
The logic above can be easily extended to situations involving multiple choice sets by wrapping them in vectors. Consider the following situation involing two repetitions of two choice sets:
 ```@example prospect_theory
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
 ```@example prospect_theory
choices = rand.(dist, choice_sets, [2,2])
```
Finally, we compute the joint choice probabilities for each choice set:
 ```@example prospect_theory
choices = pdf.(dist, choice_sets, choices)
```

# References

Fennema, H., & Wakker, P. (1997). Original and cumulative prospect theory: A discussion of empirical differences. Journal of Behavioral Decision Making, 10(1), 53-64.

Tversky, A., & Kahneman, D. (1992). Advances in prospect theory: Cumulative representation of uncertainty. Journal of Risk and uncertainty, 5(4), 297-323.