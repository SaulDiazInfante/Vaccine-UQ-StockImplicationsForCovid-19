using Plotly
Plotly.set_credentials_file(Dict("username"=>"sauld","api_key"=>"qzgprczaag"))
function get_plotly_charts(solution_data_frame)
    time = solution_data_frame.time
    I_S = solution_data_frame.I_S
    Plotly.plot(time, I_S)
end