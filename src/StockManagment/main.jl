using JSON, DataFrames, CSV
using PlotlyJS, LaTeXStrings
using Random, Distributions

include("load_parameters.jl")
include("rhs_evaluation.jl")
include("get_vaccine_stock_coverage.jl")
include("get_vaccine_action.jl")
include("save_interval_solution.jl")
include("get_interval_solution.jl")
include("get_stencil_projection.jl")
include("get_charts.jl")
include("get_solution_path.jl")
include("get_stochastic_perturbation.jl")
include("montecarlo_sampling.jl")


# Setup
Random.seed!(123)
sampling_size = 5000
df_par, df_mc, path_par, path_mc = montecarlo_sampling(sampling_size) 
last_trajectory_path = "./data/df_solution.csv"
parameters = load_parameters()
fig1, fig2 = get_charts(last_trajectory_path, parameters)
fig2
# TODO: implement the postive part in to the Stock
# TODO: Explore Noise with a mean reverting process,
# check and equation for psi_t
# TODO: Fix the actualiztion of parameters via rewritng the JSON file
