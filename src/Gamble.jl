"""
*Gamble*

`Gamble` constructs a gamble object with probability vector `p` and outcome vector `v`. 

- `p`: probability vector
- `v`: outcome vector


Constructor
````julia
Gamble(;p=[.5,.5], v=[10.0,0.0])
````
"""
mutable struct Gamble{T1,T2}
    p::T1
    v::T2
end

function Gamble(;p=[.5,.5], v=[10.0,0.0])
    return Gamble(p, v)
end