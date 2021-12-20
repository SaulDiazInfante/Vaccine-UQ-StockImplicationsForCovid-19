function get_solution(interval_time_i, x_current, 
            current_vaccination_rate, 
            parameters)
    dimension_dyn = size(x_current)[2]
    S_current = x_current[1]
    E_current = x_current[2]
    I_S_current = x_current[3]
    I_A_current = x_current[4]
    R_current = x_current[5]
    D_current = x_current[6]
    V_current = x_current[7]
    CL_current = x_current[8]
    X_vac_current = x_current[9]
    current_stock = x_current[10]
#
    x_current = [ 
        S_current, 
        E_current, 
        I_S_current, 
        I_A_current, 
        R_current, 
        D_current, 
        V_current, 
        CL_current,
        X_vac_current,
        current_stock
    ]
#
    N_grid_size = size(interval_time_i)[1]
    convert(UInt8, N_grid_size)
    convert(UInt8, dimension_dyn)
    solution = zeros(Float64, N_grid_size, dimension_dyn);
    solution[1, :] = x_current
    for j = 2 : N_grid_size
        solution[j, :] = 
            rhs_evaluation(solution[j - 1, :], 
                current_vaccination_rate, 
                current_stock, 
                parameters
            )
    end
    return solution
end