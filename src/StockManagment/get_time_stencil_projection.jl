function get_time_stencil_projection(delivery_time, interval_simulation_time)
    h = interval_simulation_time[3] - interval_simulation_time[2]
    left_projection_idx = fld(delivery_time, h) + 1
    left_projection = left_projection_idx * h
    right_projection_idx = cld(delivery_time, h)
    right_projection = right_projection_idx * h
    left_projection_err = abs(delivery_time - left_projection)
    right_projection_err = abs(delivery_time - right_projection)
    projection = left_projection
    idx =  left_projection_idx
    return [projection, idx]
end
