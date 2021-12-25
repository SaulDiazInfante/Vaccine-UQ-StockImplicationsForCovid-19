using JSON, DataFrames, Distributions, CSV
using PlotlyJS, LaTeXStrings
using Interpolations
include("get_interpolated _solution.jl")
include("load_parameters.jl")
path = "./data/df_mc(2021-12-23_20:47).csv"
trajectories = CSV.read(path, DataFrame)
# obtain dimmensions
parameters = load_parameters();
idx_0 = (trajectories.idx_path .== 1);
query = trajectories[idx_0, :];
line_time = query.time
#
# TODO: To interpolate accodinngly to the first line time
#
interpolated_trajectory_1 = 
        get_interpolated_solution(query, line_time)
idx_path = unique(trajectories, :idx_path).idx_path
df_interpolated = DataFrame()
df_interpolated = [df_interpolated; interpolated_trajectory_1]
for j in idx_path[2:end]
    idx_j = (trajectories.idx_path .== j);
    trajectory_j = trajectories[idx_j, :];
    print("\n path: ", j)
    # TODO check path 363
    interpolated_trajectory_j = 
        get_interpolated_solution(trajectory_j, line_time)
    df_interpolated = [df_interpolated; interpolated_trajectory_j]
end
#




idx_t = (interpolated_trajectory_j.time .== t)
#
query_on_time = trajectories[idx_t, :]
median_state_t = [median(c) for c in eachcol(query_on_time)]
lower_q_state_t = [quantile(c, 0.05) for c in eachcol(query_on_time)]
upper_q_state_t = [quantile(c, 0.95) for c in eachcol(query_on_time)]
header_strs = names(query_on_time)
df_median_path = DataFrame()
df_lower_q_path = DataFrame()
df_upper_q_path = DataFrame()
df_median_path_ = 
    DataFrame(
        Dict(
            zip(
                header_strs,
                median_state_t
            )
        )
    )
df_lower_q_path_ = 
    DataFrame(
        Dict(
            zip(
                header_strs,
                lower_q_state_t
            )
        )
    )
df_upper_q_path_ = 
    DataFrame(
        Dict(
            zip(
                header_strs,
                upper_q_state_t
            )
        )
    )
df_median_path = [df_median_path; df_median_path_]
df_lower_q_path = [df_lower_q_path; df_lower_q_path_]
df_upper_q_path = [df_upper_q_path; df_upper_q_path_]
for t in time_[2:end]
    query_on_time = s_path[s_path.time .== t, :]
    median_state_t = [median(c) for c in eachcol(query_on_time)]
    lower_q_state_t = [quantile(c, 0.05) for c in eachcol(query_on_time)]
    upper_q_state_t = [quantile(c, 0.95) for c in eachcol(query_on_time)]
    #       
    df_median_path_ = 
        DataFrame(
            Dict(
                zip(
                    header_strs,
                    median_state_t
                )
            )
        )
    df_lower_q_path_ = 
        DataFrame(
            Dict(
                zip(
                    header_strs,
                    lower_q_state_t
                )
            )
        )
    df_upper_q_path_ = 
        DataFrame(
            Dict(
                zip(
                    header_strs,
                    upper_q_state_t
                )
            )
        )
    df_median_path = [df_median_path; df_median_path_]
    df_lower_q_path = [df_lower_q_path; df_lower_q_path_]
    df_upper_q_path = [df_upper_q_path; df_upper_q_path_]
end

N = parameters.N[1]
trace1 = 
    PlotlyJS.scatter(
        x = df_median_path.time, 
        y = N * df_median_path.X_vac,
        mode="lines",
        name="I_S")
trace2 = 
    PlotlyJS.scatter(
        x = df_lower_q_path.time,
        y = N * df_lower_q_path.X_vac,
        mode="lines",
        name="lower_I_S"
    )
trace3 = 
    PlotlyJS.scatter(
        x = df_upper_q_path.time,
        y = N * df_upper_q_path.X_vac,
        mode="lines",
        name="upper_I_S"
    )                    

PlotlyJS.plot([trace1, trace2, trace3])