function get_plot(df_solution,
    file_name = "solution"
)
    Gadfly.push_theme(:dark)
    p_S =
        plot(
            df_solution,
            x=:time,
            y=:S,
            Geom.line
        )
    p_E =
            plot(
                df_solution,
                x=:time,
                y=:E,
                Geom.line
            )
    p_I_S =
        plot(
            df_solution,
            x=:time,
            y=:I_S,
            Geom.line
        )
    p_I_A =
        plot(
            df_solution,
            x=:time,
            y=:I_A,
            Geom.line
        )
    #
    p_R =
        plot(
            df_solution,
            x=:time,
            y=:R,
            Geom.line
        )
    #
    p_D =
        plot(
            df_solution,
            x=:time,
            y=:D,
            Geom.line
        )
    p_V =
        plot(
            df_solution,
            x=:time,
            y=:V,
            Geom.line
        )
    p_X_vac =
        plot(
            df_solution,
            x=:time,
            y=:X_vac,
            Geom.line
        )
    p_K_stock =
        plot(
            df_solution,
            x=:time,
            y=:K_stock,
            Geom.line
        )
    path_plot_ec_1 = gridstack(
        [
            p_S  p_E p_I_S p_I_A;
            p_R p_D p_V p_X_vac
        ]
    )
    #
    path_plot_ec_2 = vstack(p_X_vac, p_K_stock)
    widht = (180.0 / 25.4) ## millimeters to include("file")
    height = (widht / 1.6180)
    golden_widht = widht * inch
    golden_height = height * inch
    draw(
        PNG(
            file_name*"ec.png",
            golden_widht,
            golden_height
        ),
        path_plot_ec_1
    )
    draw(
        PNG(
            file_name*"stock.png",
            golden_widht,
            golden_height
        ),
        path_plot_ec_2
    )
end
