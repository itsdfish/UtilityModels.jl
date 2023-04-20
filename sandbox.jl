cd(@__DIR__)

using Pkg 
Pkg.activate("")

using Revise 
using UtilityModels 
using UtilityModels: compute_utility
using UtilityModels: update_utility!
using UtilityModels: compute_probs

gambles = [Gamble(;p=[.5,.5],v=[10.0,0.0]),Gamble(;p=[.9,.1],v=[5.0,8.0])]

parms = (n_options=2, Δ=.3, α=.5, λ=1.0, c=.5)

model = ValenceExpectancy(;parms...)
compute_probs(model, 1)
compute_utility(model, [10,-19])
update_utility!(model, 1, [10,-19])
compute_probs(model, 2)

gambles = [Gamble(;p=[.5,.5],v=[4.0,-1.0]),Gamble(;p=[.3,.7],v=[2.0,0.0])]

model = ValenceExpectancy(;parms...)
choices,outcomes = rand(model, gambles, 1000)

Δs = range(.0,.7, length=100)
LLs = map(Δ -> logpdf(ValenceExpectancy(;parms..., Δ), choices, outcomes), Δs)
_,mx_idx = findmax(LLs)
Δs[mx_idx]
plot(Δs, LLs)

using UtilityModels

parms = (n_options=2, Δ=.3, α=.5, λ=1.5, c=.5)
gambles = [Gamble(;p=[.5,.5],v=[4.0,-1.0]),Gamble(;p=[.3,.7],v=[2.0,0.0])]
model = ValenceExpectancy(;parms...)
choices,outcomes = rand(model, gambles, 100)
logpdf(model, choices, outcomes)
