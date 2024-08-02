# Gamble Objects

Gamble objects are a special type of categorical distribution which contain a $n \times 1$ vector of possible outcomes and a corresponding $n \times 1$ vector of outcome probabilities. The fields are

- `v`: the vector of outcome values 
- `p`: the vector of outcome probabilities

# Example

In this section, we will illustrate how to create a gamble object and how to use various methods with the gamble objects, such as computing expected values.

```@setup gamble
using Random
using UtilityModels
```

## Load Packages
The first step is to load the required packages.

```@example gamble
using Random
using UtilityModels
Random.seed!(9854)
```
## Create a Gamble Object

The code block below illustrates how to construct a gamble object for the gamble $\mathbf{G} = (58, .20; 56, .20; 2, .60)$.
```@example gamble
gamble = Gamble(; 
    p = [.20, .20, .60], 
    v = [58, 56, 2]
)
```
Note that the package can handle choices between an arbitrary number of options, each with an arbitrary number of outcomes.

## Expected Value

The expected value can be computed as follows: 

```@example gamble
mean(gamble)
```
## Standard Deviation 

The standard deviation can be computed as follows: 

```@example gamble
std(gamble)
```

## Sample Random Outcome

You can sample a random outcome from the gamble distribution with `rand`. Here is an example:

```@example gamble
rand(gamble)
```
