
function get_stencil_projection(t, parameters)
    stencil = parameters.t_delivery
    grid = findall(t .>= stencil)
    projection = maximum(grid)
    return projection
end
