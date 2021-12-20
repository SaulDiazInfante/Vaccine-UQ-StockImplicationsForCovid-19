#main
using JSON, DataFrames, Plots, Distributions, CSV
include("load_parameters.jl")
include("rhs_evaluation.jl")
include("get_vaccine_stock_coverage.jl")
include("get_vaccine_action.jl")
include("save_interval_solution.jl")
include("get_interval_solution.jl")


#file_JSON=open("parameters_model.json", "r")
#parameters=file_JSON |> JSON.parse |> DataFrames
parameters = load_parameters();

N_grid_size = parameters.N_grid_size[1]

solution = zeros(Float64, N_grid_size, 10)

#unpack initial condition
S_0 = parameters.S_0[1]
E_0 = parameters.E_0[1]
I_S_0 = parameters.I_S_0[1]
I_A_0 = parameters.I_A_0[1]
R_0 = parameters.R_0[1]
D_0 = parameters.D_0[1]
V_0 = parameters.V_0[1]
X_vac_0 = 0.0
k_0 = parameters.k_stock[1] / parameters.N[1]
# #    "psi_v": 0.00123969,
CL0 = sum([S_0 E_0 I_S_0 I_A_0 R_0 D_0 V_0])
header_strs = ["time", "S", "E",
 "I_S", "I_A", "R",
  "D", "V", "CL",
  "X_vac", "K_stock"]
x_0_vector = [0.0 S_0 E_0 I_S_0 I_A_0 R_0 D_0 V_0 CL0 X_vac_0 k_0]
hat_N_n_0 = sum(x_0_vector[2:8]) - D_0
x_0 = DataFrame(
        Dict(
            zip(
                header_strs,
                x_0_vector
            )
        )
    )

# solution[1, 1:7] = x_0
# solution[1, 8] = sum(x_0)
# solution[1, 9] = X_vac_0
# solution[1, 10] = k_0

X_C = get_vaccine_stock_coverage(k_0, parameters)
t_delivery_1 = parameters.t_delivery[2]

a_t = get_vaccine_action(X_C, t_delivery_1, parameters)

#for
simulation_interval = LinRange(parameters.t_delivery[1],parameters.t_delivery[2],N_grid_size)

# for j = 2:N_grid_size
#     #x_new = rhs_evaluation(x_old, parameters)
#     solution[j,:] = rhs_evaluation(solution[j-1,:],a_t, k_0, parameters)
#     #x_old = x_new
# end

solution_0 = get_interval_solution(x_0,a_t, k_0, parameters)

solution_interval_i = save_interval_solution(simulation_interval,solution)

#Graph

T = parameters.T[1]
t = LinRange(0,T,N_grid_size)
# graph_plot = plot(t, solution[:, 1], color="pink", label="S" )
# plot!(graph_plot, t, solution[:, 2], color="blue", label="E" )
# plot!(graph_plot, t, solution[:, 3], color="green", label="I_s" )
# plot!(graph_plot, t, solution[:, 4], color="orange", label="I_a" )
# plot!(graph_plot, t, solution[:, 5], color="brown", label="R" )
# plot!(graph_plot, t, solution[:, 6], color="magenta", label="D" )
# plot!(graph_plot, t, solution[:, 7], color="red", label="V" )
# plot!(graph_plot, t, solution[:, 8], color="black", label="CL" )
graph_plot = plot(t, solution[:, 3], color="green", label="I_s" )
plot(t, solution[:, 9]*parameters.N[1], color="blue", label="X_vac" )
plot(t, solution[:, 10]*parameters.N[1], color="red", label="K_t" )
