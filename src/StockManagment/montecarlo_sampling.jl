using JSON, DataFrames, Distributions, CSV
using PlotlyJS, LaTeXStrings
import Dates
include("load_parameters.jl")
include("rhs_evaluation.jl")
include("get_vaccine_stock_coverage.jl")
include("get_vaccine_action.jl")
include("save_interval_solution.jl")
include("get_interval_solution.jl")
include("get_stencil_projection.jl")
include("get_charts.jl")
include("get_solution_path.jl")
#
function montecarlo_sampling(
    sampling_size = 10000, 
    json_file_name="parameters_model.json" 
)
    parameters = load_parameters(json_file_name);
    x0, df = get_solution_path!(parameters);
    #
    # 
    df_par = DataFrame()
    df_mc = DataFrame()
    #
    idx_path_par = ones(Int64, size(parameters)[1]);
    idx_path = ones(Int64, size(df)[1]);
    #
    insertcols!(parameters, 31, :idx_path => idx_path_par);
    insertcols!(df, 13, :idx_path => idx_path);
    df_mc = [df_mc; df]
    df_par = [df_par; parameters];
    for idx in 2:sampling_size 
        par = get_stochastic_perturbation();
        x0, df = get_solution_path!(par);
        idx_path_par = idx * ones(Int64, size(par)[1]);
        idx_path = idx * ones(Int64, size(df)[1]);
        insertcols!(par, 31, :idx_path => idx_path_par_path);
        insertcols!(df, 13, :idx_path => idx_path);
        df_par = [df_par; par];        
        df_mc = [df_mc; df]   
    end
    # saving par time seires
    prefix_file_name = "df_par("
    #
    d = Dates.now()
    tag = Dates.format(d, "yyyy-mm-dd_HH:MM)") 
    sufix_file_name = ".csv"
    csv_file_name = prefix_file_name * tag * sufix_file_name
    path_par = "./data/" * csv_file_name
    CSV.write(path_par, df_par)   
    # 
    prefix_file_name = "df_mc("
    csv_file_name = prefix_file_name * tag * sufix_file_name
    path_mc = "./data/" * csv_file_name
    CSV.write(path_mc, df_mc)
    return df_par, df_mc, path_par, path_mc
end