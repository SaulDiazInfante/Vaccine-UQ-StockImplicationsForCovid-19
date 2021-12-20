using Distributions
include("get_stencil_projection.jl")
"""
    Returns a vaccine action.
    This descision is calcualted in order to 
    reach after a horizont time t_horizon a coverage X_C
    
    
"""

function get_vaccine_action!(X_C::Float64, t::Float64, parameters)
    u_a = parameters.delivery_time_u_a[1]
    u_b = parameters.delivery_time_u_b[1]
    u = rand(DiscreteUniform(u_a, u_b),1)[1]
    u_p = 0.0
    # rand(Uniform(-0.70, 0.01), 1)[1]#conertir en parámetro en el main
    
    id = get_stencil_projection(t, parameters)
    t_initial_interval = parameters.t_delivery[id - 1]
    t_horizon = t - t_initial_interval
    # parameters.psi_v[1] = -ln(1.0 - X_C) / (t + u)
    #psi_v = -log(1.0 - X_C) / (t_horizon + u)
    psi_v = -log(1.0 - X_C) / (t_horizon)
    a_t = psi_v * (1.0 + u_p)  
    parameters.psi_v[id - 1] = psi_v
    # print("psi v ", parameters.psi_v)
    return a_t
end
# TODO: Perturb stock plan instead the calculation