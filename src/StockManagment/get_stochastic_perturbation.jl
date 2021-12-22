import Distributions
include("load_parameters.jl")

function get_stochastic_perturbation(json_file_name="parameters_model.json")
    par = load_parameters(json_file_name);
    t_delivery = par.t_delivery
    k_stock = par.k_stock
    aux_t = zeros(length(t_delivery))
    aux_k = zeros(length(t_delivery))
    delta_t = 0.0
    for t in 2: length(t_delivery)
        delta_t = t_delivery[t] - t_delivery[t-1]
        u = Uniform(0,1)
        # xi_t = Exponential(delta_t)
        eta_t = Normal(k_stock[t], 0.1 * k_stock[t])
        aux_t[t] = aux_t[t-1] + delta_t * (1.0 + rand(u, 1)[1])  
        xi_t = rand(eta_t, 1)[1];
        aux_k[t] = abs(xi_t)
        print("\n t: ",
            t,
            "\tdelta: ",
            delta_t,
            "\tt_delivery: ",
             t_delivery[t],
             "\t", aux_t[t],
             "\t", k_stock[t],
             "\t", xi_t)
    end
    par.t_delivery = aux_t
    par.k_stock = aux_k
    return par;
end
