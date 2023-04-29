import Distributions: pdf, logpdf 
#PROBABILISTIC NATURE OF PREFERENTIAL CHOICE
@concrete mutable struct PriorityHeuristic
    δo
    δp
    σ
    w_min
    w_p
end

PriorityHeuristic(;δo=.10, δp=.10, σ=.10, w_min=.8, w_p = .15) = PriorityHeuristic(δo, δp, σ, w_min, w_p)


gambles = [Gamble(;v=[3.0, 2.0],p=[.8,.2]), Gamble(;v=[1.0,2.0], p=[.5,.5])]
choice = 1
model = PriorityHeuristic(;σ=.5)

#pdf(model, gambles, choice)

function pdf(d::PriorityHeuristic, gambles, choice)
    length(gambles) > 2 ? error("Not defined for more than 2 gambles") : nothing
    (;δo,δp,σ,w_min,w_p) = d
    w_max = 1 - (w_min + w_p)
    min_idx_a,min_idx_b = get_min_index.(gambles)
    max_idx_a,max_idx_b = get_max_index.(gambles)
    d_min = gambles[1].v[min_idx_a] - gambles[2].v[min_idx_b]
    d_max = gambles[1].v[max_idx_a] - gambles[2].v[max_idx_b]
    min_prob_a = gambles[1].p[min_idx_a]
    min_prob_b = gambles[2].p[min_idx_b]
    d_prob = min_prob_a - min_prob_b
    max_v = get_max_outcome(gambles)
    # outcome standard deviation
    σo = σ * max_v
    # threshold for comparing minimum outcomes
    _δo = δo * max_v

    p_a = order_min_p_max(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    p_a += order_p_min_max(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    p_a += order_max_p_min(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    p_a += order_p_max_min(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    p_a += order_max_min_p(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    p_a += order_min_max_p(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
   
    return choice == 1 ? p_a : (1 - p_a)
end


function order_min_p_max(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_a_min = ccdf(Normal(d_min, σo), _δo)
    p_b_min = cdf(Normal(d_min, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), δp)
    p_prob_b_min = cdf(truncated(Normal(d_prob, σ), -1, 1), -δp)

    p_max_a = ccdf(Normal(d_max, σo), 0)

    w1 = w_min / (w_min + w_p + w_max)
    w2 = w_p / (w_p + w_max)

    return w1 * p_a_min + 
        w2 * (1 - p_a_min - p_b_min) * p_prob_a_min +
        (1 - p_a_min - p_b_min) * (1 - p_prob_a_min - p_prob_b_min) * p_max_a
end

function order_p_min_max(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_a_min = ccdf(Normal(d_min, σo), _δo)
    p_b_min = cdf(Normal(d_min, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), δp)
    p_prob_b_min = cdf(truncated(Normal(d_prob, σ), -1, 1), -δp)

    p_max_a = ccdf(Normal(d_max, σo), 0)

    # prob min prob first
    w1 = w_p / (w_min + w_p + w_max)
    # prob min outcome second given min prob first
    w2 = w_min / (w_min + w_max)

    return w1 * p_prob_a_min + 
        w2 * (1 - p_prob_a_min - p_prob_b_min) * p_a_min +
         (1 - p_prob_a_min - p_prob_b_min) * (1 - p_a_min - p_b_min) * p_max_a
end

function order_max_p_min(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_max_a = ccdf(Normal(d_max, σo), _δo)
    p_max_b = cdf(Normal(d_max, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), δp)
    p_prob_b_min = cdf(truncated(Normal(d_prob, σ), -1, 1), -δp)

    p_a_min = ccdf(Normal(d_min, σo), 0)

    # prob max outcome first
    w1 = w_max / (w_min + w_p + w_max)
    # prob min prob second given max outcome first
    w2 = w_p / (w_min + w_p)

    return w1 * p_max_a + 
        w2 * (1 - p_max_a - p_max_b) * p_prob_a_min +
        (1 - p_max_a - p_max_b) * (1 - p_prob_a_min - p_prob_b_min) * p_a_min
end

function order_p_max_min(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_max_a = ccdf(Normal(d_max, σo), _δo)
    p_max_b = cdf(Normal(d_max, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), δp)
    p_prob_b_min = cdf(truncated(Normal(d_prob, σ), -1, 1), -δp)

    p_a_min = ccdf(Normal(d_min, σo), 0)

    # prob max outcome first
    w1 = w_p / (w_min + w_p + w_max)
    # prob min prob second given max outcome first
    w2 = w_max / (w_min + w_max)

    return w1 * p_prob_a_min + 
        w2 * (1 - p_prob_a_min - p_prob_b_min) * p_max_a +
        (1 - p_prob_a_min - p_prob_b_min) * (1 - p_max_a - p_max_b)  * p_a_min
end

function order_max_min_p(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_max_a = ccdf(Normal(d_max, σo), _δo)
    p_max_b = cdf(Normal(d_max, σo), -_δo)

    p_a_min = ccdf(Normal(d_min, σo), _δo)
    p_b_min = cdf(Normal(d_min, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), 0)

    # prob max outcome first
    w1 = w_max / (w_min + w_p + w_max)
    # prob min prob second given max outcome first
    w2 = w_min / (w_min + w_p)

    return w1 * p_max_a + 
        w2 * (1 - p_max_a - p_max_b) * p_a_min +
        (1 - p_max_a - p_max_b) * (1 - p_a_min - p_b_min) * p_prob_a_min
end

function order_min_max_p(d_min, d_prob, σo, σ, _δo, δp, d_max, w_min, w_p, w_max)
    
    p_max_a = ccdf(Normal(d_max, σo), _δo)
    p_max_b = cdf(Normal(d_max, σo), -_δo)

    p_a_min = ccdf(Normal(d_min, σo), _δo)
    p_b_min = cdf(Normal(d_min, σo), -_δo)

    p_prob_a_min = ccdf(truncated(Normal(d_prob, σ), -1, 1), 0)

    # prob max outcome first
    w1 = w_min / (w_min + w_p + w_max)
    # prob min prob second given max outcome first
    w2 = w_max / (w_max + w_p)

    return w1 * p_a_min + 
        w2 * (1 - p_a_min - p_b_min) * p_max_a +
        (1 - p_a_min - p_b_min) * (1 - p_max_a - p_max_b) * p_prob_a_min
end


function get_min_index(gamble)
    min_idx = 0
    if any(x -> x ≥ 0, gamble.v)
    _,min_idx = findmin(gamble.v)
    else
    _,min_idx = findmax(gamble.v)
    end
    return min_idx
end

function get_max_index(gamble)
    max_idx = 0
    if any(x -> x ≥ 0, gamble.v)
    _,max_idx = findmax(gamble.v)
    else
    _,max_idx = findmin(gamble.v)
    end
    return max_idx
end

function get_max_outcome(gambles)
    outcomes = [gambles[1].v; gambles[2].v]
    return any(x -> x ≥ 0, outcomes) ? maximum(outcomes) : minimum(outcomes)
end

function weights(w, o1, o2)
    v = setdiff(1:3, o1)
    return (w[o1] / sum(w)) * (w[o2] /sum(w[v]))
end
