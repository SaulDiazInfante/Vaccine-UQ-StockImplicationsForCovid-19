using JSON, DataFrames, Distributions, CSV
using PlotlyJS, LaTeXStrings
s_path = 
    CSV.read("df_mc(2021-12-16_09:37).csv", DataFrame)
# obtain dimmensions
parameters = load_parameters();
query_path = s_path[s_path.idx_path .== 1, :]
time_ = query_path.time
t = time_[1]
query_on_time = s_path[s_path.time .== t, :]
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