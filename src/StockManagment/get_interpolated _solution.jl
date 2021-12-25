using Interpolations
function get_interpolated_solution(trajectory::DataFrame, line_time)
    state_names = [
        "time", 
        "D", "E", "I_A", "I_S", "K_stock",
        "R", "S", "V", "X_vac", "action"
    ]
    time = trajectory.time
    dim = [length(line_time), length(state_names)]
    interpolated_time_states = zeros(dim[1], dim[2])
    interpolated_time_states[:, 1] = line_time
    df = DataFrame(interpolated_time_states, state_names)
    for state_name in state_names
        state = trajectory[!, Symbol(state_name)]
        interpolated_state = 
        LinearInterpolation(time, state, extrapolation_bc=Line())
        interpolated_state_eval = interpolated_state.(line_time)
        df[!, Symbol(state_name)] = interpolated_state_eval
    end
    return df
end