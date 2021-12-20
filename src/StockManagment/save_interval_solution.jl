function save_interval_solution(time, x;
                header_strs =
                    ["time", "S", "E",
                     "I_S", "I_A", "R",
                      "D", "V", "CL",
                      "X_vac", "K_stock", "action"],
                file_name = "solution_interval.csv"
)
    data = [time x]
    df_solution = (
        DataFrame(
            Dict(
                zip(
                    header_strs,
                    [data[:,i] for i in 1:size(data,2)]
                )
            )
        )
    )
    CSV.write(file_name, df_solution)
    return df_solution;
end
