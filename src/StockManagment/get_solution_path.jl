using JSON, DataFrames, Distributions, CSV
using PlotlyJS, LaTeXStrings
include("load_parameters.jl")
include("rhs_evaluation.jl")
include("get_vaccine_stock_coverage.jl")
include("get_vaccine_action.jl")
include("save_interval_solution.jl")
include("get_interval_solution.jl")
include("get_stencil_projection.jl")
include("get_charts.jl")

function get_solution_path!(json_file_name="parameters_model.json")
    parameters = load_parameters(json_file_name);
    N_grid_size = parameters.N_grid_size[1];
    solution = zeros(Float64, N_grid_size, 11);
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
    CL0 = sum([S_0, E_0, I_S_0, I_A_0, R_0, D_0, V_0])
    header_strs = ["time", "S", "E",
        "I_S", "I_A", "R",
        "D", "V", "CL",
        "X_vac", "K_stock", "action"
    ]
    x_0_vector = [
        0.0, S_0, E_0, I_S_0, I_A_0, R_0, 
        D_0, V_0, CL0, X_vac_0, k_0, 0.0
    ]
    hat_N_n_0 = sum(x_0_vector[2:8]) - D_0
    x_0 = DataFrame(
        Dict(
            zip(
                header_strs,
                x_0_vector
            )
        )
    )
    #
    # Solution on the first delivery time period
    #
    X_C = get_vaccine_stock_coverage(k_0, parameters)
    t_delivery_1 = parameters.t_delivery[2]
    a_t = get_vaccine_action!(X_C, t_delivery_1, parameters)
    simulation_interval =
        LinRange(
            parameters.t_delivery[1],
            parameters.t_delivery[2],
            N_grid_size
        )
#
    time_horizon_1 = parameters.t_delivery[2]
    t_interval_1 = LinRange(0, time_horizon_1, N_grid_size)
    solution_1 =
        get_interval_solution!(
            x_0,
            a_t,
            k_0,
            parameters
        )
    prefix = "df_solution_"
    sufix = "1.csv"
    file = prefix * sufix
    df_solution_1 =
    save_interval_solution(
        t_interval_1, solution_1;
        file_name = file
    )
    solution_list =[]
    solution_list = push!(solution_list, df_solution_1)
    solution_list_time = []
    solution_list_time = push!(solution_list_time, t_interval_1)
    df_solution = DataFrame()
    df_solution = [df_solution; df_solution_1]
    #
    # Solution on each t_interval
    for t in 2:(length(parameters.t_delivery) - 1)
        h = (parameters.t_delivery[t + 1] -
            parameters.t_delivery[t]) / N_grid_size
        t_interval =
            LinRange(
                parameters.t_delivery[t] +
                h,
                parameters.t_delivery[t+1],
                N_grid_size
        )
        solution_list_time = push!(solution_list_time, t_interval)
        x_t = solution_list[t - 1][end, :]
        k_t =x_t.K_stock + parameters.k_stock[t] / parameters.N[t]
        X_Ct = get_vaccine_stock_coverage(k_t, parameters)
        t_delivery_t = parameters.t_delivery[t + 1]
        a_t = get_vaccine_action!(X_Ct, t_delivery_t, parameters)
        solution_t = get_interval_solution!(x_t, a_t, k_t, parameters)
        sufix = "$(t)"*".csv"
        file = prefix*sufix
        df_solution_t = 
            save_interval_solution(
                t_interval, solution_t; 
                file_name = file
        )
        solution_list = push!(solution_list, df_solution_t)
        df_solution = [df_solution; df_solution_t]
        solution_list_time = push!(solution_list_time, t_interval)
    end
    return x_0, df_solution
end