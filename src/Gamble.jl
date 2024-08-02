"""
    Gamble{T <: Real}

A gamble object with probability vector `p` and outcome vector `v`. 

# Fields 

- `p`: probability vector
- `v`: outcome vector

# Constructors

    Gamble(; p = [0.5, 0.5], v = [10.0, 0.0])

    Gamble(p, v)
"""
mutable struct Gamble{T <: Real}
    p::Vector{T}
    v::Vector{T}
end

function Gamble(; p = [0.5, 0.5], v = [10.0, 0.0])
    return Gamble(p, v)
end

function Gamble(p, v)
    T = promote_type(typeof(p), typeof(v))
    return Gamble(T(p), T(v))
end

function rand(gamble::Gamble)
    return sample(gamble.v, Weights(gamble.p))
end

mean(g::Gamble) = g.v' * g.p

std(g::Gamble) = √(var(g))

function var(gamble::Gamble)
    (; p, v) = gamble
    ev = mean(gamble)
    return sum(p .* (v .- ev) .^ 2)
end
