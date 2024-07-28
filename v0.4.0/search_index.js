var documenterSearchIndex = {"docs":
[{"location":"parameter_estimation/#Parameter-Estimation","page":"Parameter Estimation","title":"Parameter Estimation","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"In this brief tutorial, we will demonstrate how to perform Bayesian parameter estimation using Turing.jl. For simplicity, we will estimate the utility curvature parameter of an expected utility model from 50 independent identically distributed observations from a single choice set. ","category":"page"},{"location":"parameter_estimation/#Load-Packages","page":"Parameter Estimation","title":"Load Packages","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"The first step is to load the required packages.","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"using Plots\nusing Random\nusing Turing\nusing UtilityModels\nRandom.seed!(6541)","category":"page"},{"location":"parameter_estimation/#Choice-Set","page":"Parameter Estimation","title":"Choice Set","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"Next, we will create the choice set from two trinary gambles. The first gamble is less risky than the second gamble, as defined by lower variance.","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"gamble1 = Gamble(; \n    p = [.25, .25, .50], \n    v = [44, 40, 5]\n)","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"The second gamble is relatively more risky. ","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"gamble2 = Gamble(; \n    p = [.25, .25, .50], \n    v = [98, 10, 5]\n)","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"In the code block below, we combine the gambles into a vector representing the available options. In addition, we create a model object and generate 50 simulated choices. The gambles and simulated choices are combined into a single data structure so it can be passed to logpdf via Turing and subsequently parsed. ","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"gambles = [gamble1,gamble2]\neu_model = ExpectedUtility(; α = .80, θ = 1)\nchoices  = rand(eu_model, gambles, 50)\ndata = (gambles,choices)","category":"page"},{"location":"parameter_estimation/#Create-Turing-Model","page":"Parameter Estimation","title":"Create Turing Model","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"Below, we create a turing model by prefixing a function with the @model macro. The function passes the data and defines two sampling statements: a prior distribution on the utlity curvature parameter, and a sampling statement for the data.","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"@model function model(data)\n    α ~ truncated(Normal(.8, 1), 0, Inf)\n    data ~ ExpectedUtility(; α, θ = 1)\nend","category":"page"},{"location":"parameter_estimation/#Estimate-Parameters","page":"Parameter Estimation","title":"Estimate Parameters","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"Now that the Turing model has been defined, we can pass it, along with the data, to sample to perform Bayesian parameter estimation with an MCMC algorithm called the No-U-turn sampler. The function call below will sample 2,000 times from the posterior distribution (discarding the first 1,000 warmup samples), for 4 parallel chains.","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"chain = sample(model(data), NUTS(1000, .85), MCMCThreads(), 1000, 4)","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"┌ Info: Found initial step size\n└   ϵ = 0.0125\n┌ Info: Found initial step size\n└   ϵ = 0.025\n┌ Info: Found initial step size\n└   ϵ = 0.00625\n┌ Info: Found initial step size\n└   ϵ = 3.2\nChains MCMC chain (1000×13×4 Array{Float64, 3}):\n\nIterations        = 1001:1:2000\nNumber of chains  = 4\nSamples per chain = 1000\nWall duration     = 0.91 seconds\nCompute duration  = 3.03 seconds\nparameters        = α\ninternals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size\n\nSummary Statistics\n  parameters      mean       std      mcse    ess_bulk    ess_tail      rhat   ess_per_sec \n      Symbol   Float64   Float64   Float64     Float64     Float64   Float64       Float64 \n\n           α    0.8031    0.0317    0.0009   1299.4792   1501.7839    1.0008      428.8710\n\nQuantiles\n  parameters      2.5%     25.0%     50.0%     75.0%     97.5% \n      Symbol   Float64   Float64   Float64   Float64   Float64 \n\n           α    0.7346    0.7841    0.8055    0.8240    0.8591","category":"page"},{"location":"parameter_estimation/#Plot-Posterior-Distribution","page":"Parameter Estimation","title":"Plot Posterior Distribution","text":"","category":"section"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"Inspection of the trace plot does not reveal any anomolies. The density plot shows that the posterior distribution is centered near the data generating value of alpha = 80 and spans roughtly between .75 and .85, suggesting good recovery of the parameter. ","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"plot(chain, grid = false)","category":"page"},{"location":"parameter_estimation/","page":"Parameter Estimation","title":"Parameter Estimation","text":"(Image: )","category":"page"},{"location":"expected_utility/#Expected-Utility-Theory","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The Leaky Competing Accumulator (LCA; Usher & McClelland, 2001) is a sequential sampling model in which evidence for options races independently. The LCA is similar to the Linear Ballistic Accumulator (LBA), but additionally assumes an intra-trial noise and leakage (in contrast, the LBA assumes that evidence accumulates in a ballistic fashion, i.e., linearly and deterministically until it hits the threshold).","category":"page"},{"location":"expected_utility/#Example","page":"Expected Utility Theory","title":"Example","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"In this example, we will demonstrate how to use the LCA in a generic two alternative forced choice task. ","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"using Plots\nusing Random\nusing UtilityModels","category":"page"},{"location":"expected_utility/#Load-Packages","page":"Expected Utility Theory","title":"Load Packages","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The first step is to load the required packages.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"using Plots\nusing Random\nusing UtilityModels\nRandom.seed!(8741)","category":"page"},{"location":"expected_utility/#Create-Choice-Set","page":"Expected Utility Theory","title":"Create Choice Set","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"We will consider the following two options in this example. Note that the package can handle choices between an arbitrary number of options.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"gamble1 = Gamble(; \n    p = [.20, .20, .60], \n    v = [58, 56, 2]\n)\n\ngamble2 = Gamble(; \n    p = [.20, .20, .60], \n    v = [96, 4, 2]\n)\ngambles = [gamble1,gamble2]","category":"page"},{"location":"expected_utility/#Create-Model-Object","page":"Expected Utility Theory","title":"Create Model Object","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"In the code below, we will define parameters for the LBA and create a model object to store the parameter values. ","category":"page"},{"location":"expected_utility/#Utility-Curvature","page":"Expected Utility Theory","title":"Utility Curvature","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The utility curvature parameter alpha controls whether the utility function is concave, linear, or convex. The utility function is given by:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"U(x) = mathrmsign(x)x^alpha","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The parameter alpha can be intrepreted in terms of risk profile as follows: ","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"risk averse: 0 geq alpha  1\nrisk neutral: alpha = 1\nrisk seeking: alpha  1","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The utility function U(x) is plotted below for a range of values of alpha.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"<details><summary>Show Plotting Code</summary>","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"model = ExpectedUtility()\nvals = [-20:.5:20;]\ngamble = Gamble(; v = vals)\nαs = range(0, 1.5, length = 5) \nutilities = [compute_utility(ExpectedUtility(; α) , gamble) for α ∈ αs]\nutility_plot = plot(vals, utilities, xlabel = \"x\", ylabel = \"U(x)\", labels = αs', legendtitle = \"α\", grid = false)","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"</details>","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"utility_plot","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Below, we set the alpha parameter to a value associated with moderate risk aversion. ","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"α = .80","category":"page"},{"location":"expected_utility/#Decisional-Consistency","page":"Expected Utility Theory","title":"Decisional Consistency","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The parameter theta—sometimes known as decisional consistency or sensitivity—controls how deterministically a model selects the option with the higher expected utility. In the equation below, the probability of selecting x_i from choice set x_1dots x_n is computed with the soft max function.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Pr(X = x_i mid x_1 dots x_n) = frace^theta cdot mathrmEU(x_i)sum_j=1^n e^theta cdot mathrmEU(x_j)","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"As shown in the plot below,  parameter theta modulates the choice probability.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"<details><summary>Show Plotting Code</summary>","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"vals = [-10:.1:10;]\nθs = range(0, 2, length = 5) \nprobs = [pdf(ExpectedUtility(; α = 1, θ) , [Gamble(; p = [1], v = [0]), Gamble(; p = [1], v=[v])], [1,0]) for v ∈ vals, θ ∈ θs]\nprob_plot = plot(reverse!(vals), probs, xlabel = \"U(A) - U(B)\", ylabel = \"Probability A\", labels = θs', legendtitle = \"θ\", grid = false)","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"</details>","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"prob_plot","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"We will set theta to the following value:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"θ = 1.0","category":"page"},{"location":"expected_utility/#Expected-Utility-Constructor","page":"Expected Utility Theory","title":"Expected Utility Constructor","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Now that values have been asigned to the parameters, we will pass them to ExpectedUtility to generate the model object.","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"dist = ExpectedUtility(; α, θ)","category":"page"},{"location":"expected_utility/#Expected-Utility","page":"Expected Utility Theory","title":"Expected Utility","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The expected utilities of each gamble can be computed via mean as demonstrated below:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"mean.(dist, gambles)","category":"page"},{"location":"expected_utility/#Standard-Deviation-Utility","page":"Expected Utility Theory","title":"Standard Deviation Utility","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The standard deviation of utilities of each gamble can be computed via std as demonstrated below:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"std.(dist, gambles)","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The larger standard deviation of the second gamble indicates it is a riskier option.  ","category":"page"},{"location":"expected_utility/#Simulate-Model","page":"Expected Utility Theory","title":"Simulate Model","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Now that the model is defined, we will generate 10 choices using rand. ","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":" choices = rand(dist, gambles, 10)","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"In the code block above, the output is a sample from a multinomial distribution in which the ","category":"page"},{"location":"expected_utility/#Compute-Choice-Probability","page":"Expected Utility Theory","title":"Compute Choice Probability","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The probability of choosing the first option can be obtained as follows: ","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"pdf(dist, gambles, [1,0])","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The relatively high choice probability for the first option makes sense in light of its higher expected value (and lower variance).","category":"page"},{"location":"expected_utility/#Multiple-Choice-Sets","page":"Expected Utility Theory","title":"Multiple Choice Sets","text":"","category":"section"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"The logic above can be easily extended to situations involving multiple choice sets by wrapping them in vectors. Consider the following situation involing two repetitions of two choice sets:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"choice_sets = [\n    [\n        Gamble(; p = [0.20, 0.20, 0.60], v = [58, 56, 2]),\n        Gamble(; p = [0.20, 0.20, 0.60], v = [96, 4, 2])\n    ],\n    [\n        Gamble(; p = [0.45, 0.45, 0.10], v = [58, 56, 2]),\n        Gamble(; p = [0.45, 0.45, 0.10], v = [96, 4, 2])\n    ]\n]","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Next, we simulate two choices for each choice set:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"choices = rand.(dist, choice_sets, [2,2])","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"Finally, we compute the joint choice probabilities for each choice set:","category":"page"},{"location":"expected_utility/","page":"Expected Utility Theory","title":"Expected Utility Theory","text":"choices = pdf.(dist, choice_sets, choices)","category":"page"},{"location":"#UtilityModels.jl","page":"Home","title":"UtilityModels.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for UtilityModels.jl","category":"page"}]
}