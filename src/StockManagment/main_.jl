using JSON, DataFrames, Distributions, CSV
using PlotlyJS, LaTeXStrings
include("load_parameters.jl")
include("rhs_evaluation.jl")
include("get_vaccine_stock_coverage.jl")
include("get_vaccine_action.jl")
include("save_interval_solution.jl")
include("get_interval_solution.jl")
include("get_stencil_projection.jl")
include("get_charts.jl")
include("get_solution_path.jl")

x0, df = get_solution_path();
sampling_size = 10000
#TODO: tagger funtion for time solution file_name
 
df_mc = DataFrame()
idx_path = ones(size(df)[1]);
insertcols!(df, 13, :idx_path => idx_path);
df_mc = [df_mc; df]
    for idx in 2:sampling_size 
        x0, df = get_solution_path();
        idx_path = idx * ones(size(df)[1]);
        insertcols!(df, 13, :idx_path => idx_path);
        df_mc = [df_mc; df]
    end
file_name = "df_mc.csv"
CSV.write(file_name, df_mc)