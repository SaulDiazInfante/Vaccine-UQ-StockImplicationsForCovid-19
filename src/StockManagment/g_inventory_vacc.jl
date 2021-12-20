using Gillespie
using Gadfly
using Random
using JSON, DataFrames, CSV
include("load_parameters.jl")
include("evaluation_birth_death_process.jl")
include("save_data.jl")
include("get_path_plot.jl")
#
parameters = load_parameters();
N = trunc(Int, 1e-4 * parameters.N[1])
omega_v = parameters.omega_v[1]
psi_v = parameters.psi_v[1]
p = parameters.p[1]
alpha_a = parameters.alpha_a[1]
alpha_s = parameters.alpha_s[1]
theta = parameters.theta[1]
delta_e = parameters.delta_e[1]
delta_r = parameters.delta_r[1]
epsilon = parameters.epsilon[1]
beta_s = parameters.beta_s[1]
beta_a = parameters.beta_a[1]
param = [N,
        omega_v,
        psi_v,
        p,
        alpha_a,
        alpha_s,
        theta,
        delta_e,
        delta_r,
        epsilon,
        beta_s,
        beta_a
        ]
#
x0 = [1220, 204, 10, 10, 1200, 0, 0]
nu = [
        [-1 0 0 0 0 1 0]; # vaccination
        [-1 1 0 0 0 0 0]; # acquiring_virus,
        [0 -1 1 0 0 0 0]; # developing_symptoms
        [0 -1 0 1 0 0 0]; # developing_transitory_disease
        [0 0 -1 0 1 0 0]; # infection_with_symptoms_recovering
        [0 0 -1 0 0 0 1]; # death_by_disease
        [0 0 0 -1 1 0 0]; # transitory_infection_recovering
        [1 0 0 0 -1 0 0]; # losing_natural_immunity
        [1 0 0 0 0 -1 0]; # losing_vaccine_induced_immunity
        [0 1 0 0 0 -1 0]; # virus_inoculation_by_imperfect_immunization
    ]
tf = 30.0
Random.seed!(1234)
result =
    ssa(
        x0,
        evaluation_birth_death_process,
        nu,
        param,
        tf,
        algo=:jensen,
        max_rate=30000.0,
        thin=true
    )
df_solution = save_data(result)
get_path_plot(df_solution)
