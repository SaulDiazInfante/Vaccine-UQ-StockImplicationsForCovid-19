using Distributions
function get_vaccine_stock_coverage(k::Float64, parameters)
    l_s = parameters.low_stock[1] / parameters.N[1]
    x_coverage = maximum([k - l_s, 0.0])
    return x_coverage
end
