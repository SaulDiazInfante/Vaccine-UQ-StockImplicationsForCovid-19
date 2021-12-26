using  Distributions
include("load_parameters.jl")

function get_stochastic_perturbation(
    json_file_name="parameters_model.json"
    )
    par = load_parameters(json_file_name);
    t_delivery = par.t_delivery
    k_stock = par.k_stock
    aux_t = zeros(length(t_delivery))
    aux_k = zeros(length(t_delivery))
    delta_t = 0.0
    t=1
    # u = Uniform(0, 0.5)
    aux_t[t] = t_delivery[t]
    aux_k[t] = k_stock[t]
    # print(
    #    "\n t: ",
    #    t,
    #    "\tt_delivery: ",
    #    t_delivery[t],
    #    "\t", aux_t[t],
    #    "\t", k_stock[t],
    #    "\t", aux_k[t],
    #    "\n" 
    #)

    for t in 2: length(t_delivery)
        eta_t = Normal(k_stock[t], 0.1 * k_stock[t])
        delta_t = t_delivery[t] - t_delivery[t-1]
        # tau = Normal(0 , sqrt(delta_t))
        tau = Uniform(.25 * delta_t, 1.5 * delta_t) 
        delta_tau = rand(tau, 1 )[1]
        # aux_t[t] = aux_t[t-1] + delta_t * (1.0 + rand(u, 1)[1])  
        aux_t[t] = aux_t[t-1]  + delta_tau

        xi_t = rand(eta_t, 1)[1];
        aux_k[t] = abs(xi_t)
#        print("\n t: ",
#            t,
#            "\tt_delivery: ",
#             t_delivery[t],
#             "\t", aux_t[t],
#             "\t", k_stock[t],
#             "\t", xi_t
#        )
    end
    print("\n")
    par.t_delivery = aux_t
    par.k_stock = aux_k
    return par;
end
par = get_stochastic_perturbation();