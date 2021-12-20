include("rhs_evaluation.jl")
include("get_stencil_projection.jl")

function get_interval_solution!(x, a_t, k, parameters)
    t = x.time[1]
    index = get_stencil_projection(t,parameters)
    N_grid_size = parameters.N_grid_size[index]
    sol = zeros(Float64, N_grid_size, 11)

    S_0 = x.S
    E_0 = x.E
    I_S_0 = x.I_S
    I_A_0 = x.I_A
    R_0 = x.R
    D_0 = x.D
    V_0 = x.V
    X_vac_0 = x.X_vac
    k_0 = x.K_stock
    CL0 = x.CL
    x_00 = [S_0 E_0 I_S_0 I_A_0 R_0 D_0 V_0 CL0 X_vac_0 k_0 a_t]

    sol[1,:] = x_00
    header_strs = ["S", "E",
     "I_S", "I_A", "R",
      "D", "V", "CL",
      "X_vac", "K_stock", "action" ]
    for j = 2:N_grid_size
        #x_new = rhs_evaluation(x_old, parameters)
        S_old = sol[j-1,:]
        S_old_df = DataFrame(
                Dict(
                    zip(
                        header_strs,
                        S_old
                    )
                )
            )
        sol[j,:] = rhs_evaluation!(t, S_old_df, a_t, k, parameters)
        #x_old = x_new
    end
    return sol
end
