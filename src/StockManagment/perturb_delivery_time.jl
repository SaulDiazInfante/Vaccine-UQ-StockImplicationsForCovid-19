function perturb_delivery_time(delivery_time, scale = 15.0)
"""
    Returns a vector with perturbed delivery times by summing a
    random variable with Uniform Distribution.
"""
    dim = size(delivery_time)[1]
    perturbed_delivery_time = zeros(dim)
    u = Uniform(-scale, scale)
    for j in 2:dim
        perturbed_delivery_time[j] = delivery_time[j] + rand(u)
    end
    return  perturbed_delivery_time
end
