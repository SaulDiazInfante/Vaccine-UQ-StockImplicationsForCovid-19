function get_path_plot(df_solution,
    file_name = "solution_path.png"
)
    Gadfly.push_theme(:dark)
    p_S =
        plot(
            df_solution,
            x=:time,
            y=:S,
            Geom.step
        )
    p_I_S =
        plot(
            df_solution,
            x=:time,
            y=:I_S,
            Geom.step
        )
    p_I_A =
        plot(
            df_solution,
            x=:time,
            y=:I_A,
            Geom.step
        )
    #
    p_R =
        plot(
            df_solution,
            x=:time,
            y=:R,
            Geom.step
        )
    #
    p_D =
        plot(
            df_solution,
            x=:time,
            y=:D,
            Geom.step
        )
    p_V =
        plot(
            df_solution,
            x=:time,
            y=:V,
            Geom.step
        )
    path_plot = gridstack(
        [
            p_S p_I_S p_I_A;
            p_R p_D p_V
        ]
    )
    widht = (180.0 / 25.4) ## millimeters to include("file")
    height = (widht / 1.6180)
    golden_widht = widht * inch
    golden_height = height * inch
    draw(PNG(file_name, golden_widht, golden_height), path_plot)
end
