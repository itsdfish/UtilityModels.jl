"""
*Gamble*

`Gamble` constructs a gamble object with probability vector `p` and outcome vector `v`. 
Vectors `p` and `v` are sorted seperately for gains and losses in ascending order of the absolute value of
`v`. Subarrays for `p` and `v` for gains and losses are stored for internal calculations for prospect theory. 

- `p`: probability vector
- `v`: outcome vector
- `pg`: probability vector for gains
- `vg`: outcome vector for gains
- `pl`: probability vector for losses
- `vl`: outcome vector for losses

Constructor
````julia
Gamble(;p=[.5,.5], v=[10.0,0.0])
````
"""
mutable struct Gamble{T1,T2,T3,T4,T5}
    p::T1
    v::T1
    pg::T2
    pl::T3
    vg::T4
    vl::T5
end

function Gamble(;p=[.5,.5], v=[10.0,0.0])
    i = sortperm(v)
    p = p[i]; v = v[i]
    gains = v .>= 0
    pg = @view p[gains]
    pl = @view p[.!gains]
    vg = @view v[gains] 
    vl = @view v[.!gains]
    reverse!(vl); reverse!(pl)
    return Gamble(p, v, pg, pl, vg, vl)
end
