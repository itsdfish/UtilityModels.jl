"""
    Gamble(;p=[.5,.5], v=[10.0,0.0])

Constructs a gamble object with probability vector `p` and outcome vector `v`. 

# Fields 

- `p`: probability vector
- `v`: outcome vector
"""
mutable struct Gamble{T1,T2}
    p::T1
    v::T2
end

function Gamble(;p=[.5,.5], v=[10.0,0.0])
    return Gamble(p, v)
end

function sample(gamble::Gamble)
    return sample(gamble.v, Weights(gamble.p))
end

mean(g::Gamble) = g.v' * g.p