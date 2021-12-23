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
    x0, df = get_solution_path!(json_file_name);
    #
    # TODO: tagger funtion for time solution file_name
    #
    df_mc = DataFrame()
    idx_path = ones(Int64, size(df)[1]);
    insertcols!(df, 13, :idx_path => idx_path);
    df_mc = [df_mc; df]
    for idx in 2:sampling_size 
        x0, df = get_solution_path!(json_file_name);
        idx_path = idx * ones(Int64, size(df)[1]);
        insertcols!(df, 13, :idx_path => idx_path);
        df_mc = [df_mc; df]
    end
    prefix_file_name = "df_mc("
    d = Dates.now()
    tag = Dates.format(d, "yyyy-mm-dd_HH:MM)") 
    sufix_file_name = ".csv"
    csv_file_name = prefix_file_name * tag * sufix_file_name
    path = "./data/" * csv_file_name
    CSV.write(path, df_mc)
    return df_mc, path
end