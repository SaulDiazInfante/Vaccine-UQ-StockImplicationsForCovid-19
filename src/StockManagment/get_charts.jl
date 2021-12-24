using PlotlyJS, DataFrames, CSV
function get_charts(data_file, parameters)
    df_solution = DataFrame(CSV.File(data_file))
    config = PlotConfig(
    toImageButtonOptions=attr(
            format="svg",
            filename="custom_image",
            height=500,
            width=700,
            scale=1 
        ).fields
    )
#
    N = parameters.N[1]
    t = df_solution.time
    trace_stock_evolution =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.K_stock,
            name = "Stock Evolution"
        )

    trace_action_evolution =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.action,
            name = "Action"
        )
    trace_S =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.S,
            color = "red",
            name = "S"
        )
    trace_E =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.E,
            color="blue",
            name = "E"
        )

    trace_I_S =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.I_S,
            name = "I_S"
        )
    #Graph
    trace_I_A =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.I_A,
            name = "I_A"
        )

    trace_R =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.R,
            color = "yellow",
            name = "R"
        )

    trace_D =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.D,
            color = "magenta",
            name = "D"
        )
    trace_V =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.V,
            color="green",
            name = "V"
        )
    trace_X_vac =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.X_vac,
            color="green",
            name = "X_vac"
        )
    trace_K_stock =
        scatter(
            mode = "lines",
            x = t,
            y = N * df_solution.K_stock,
            name = "K_stock"
        )
    ##
    layout = Layout(
        # title="Evolution",
        # xaxis_title="time (days)",
        # yaxis_title="Prevalence",
        # legend_title="Epidemic States",
            font=attr(
            family="Courier New, monospace",
            size=12,
            color="black"
            )
        )
    ## subplot dashboard
    fig = make_subplots(
        rows=4, cols=2,
        column_widths=[0.5, 0.5],
        row_heights=[0.25, 0.25, 0.25, 0.25],
        subplot_titles=[
        "Susceptible"  "Infected_S" "Recovered" "Vaccinated";
        "Exposed" "Infected_A" "Death" "Jab counter"
        ]
    )
    #
    add_trace!(
        fig,
        trace_S,
        row=1, col=1
    )
    add_trace!(
        fig,
        trace_E,
        row=1, col=2
    )#
    add_trace!(
        fig,
        trace_I_S,
        row=2, col=1
    )
    add_trace!(
        fig,
        trace_I_A,
        row=2, col=2
    )
    add_trace!(
        fig,
        trace_R,
        row=3, col=1
    )
    add_trace!(
        fig,
        trace_D,
        row=3, col=2
    )
    add_trace!(
        fig,
        trace_V,
        row=4, col=1
    )
    add_trace!(
        fig,
        trace_X_vac,
        row=4, col=2
    )
    relayout!(
        fig,
        title="Epidemic sates",
        xaxis_title = ["time (days)" "time (days)"],
        yaxis_title = ["Number of jabs" "Jabs / day"]
    )
    open("./plot_fig.html", "w") do io
        PlotlyBase.to_html(io, fig.plot)
    end
    #
    # Plottting action and Vaccine Stock
    config = PlotConfig(
        toImageButtonOptions=attr(
            format="svg",
            filename="custom_image",
            height=500,
            width=700,
            scale=1
        ).fields
    )
    layout = Layout(
        legend_title="Epidemic States",
            font=attr(
            family="Courier New, monospace",
            size=12,
            color="black"
            )
        )
    ##
    ## subplot dashboard
    fig2 = make_subplots(
        rows=2, cols=1,
        column_widths=[1.0],
        row_heights=[0.5, .5],
        subplot_titles=[
            "Available Vaccine Stock" "Vaccination Rate (dosis/day)"
        ]
    )
    layout2 = Layout(
            font=attr(
            family="Courier New, monospace",
            size=12,
            color="black"
            )
    )
    add_trace!(
        fig2,
        trace_stock_evolution,
        row=1, col=1
    )
    add_trace!(
        fig2,
        trace_action_evolution,
        row=2, col=1
    )

    relayout!(
        fig2,
        title="Evolution vaccine stock to applied an action",
        xaxis_title = ["time (days)" "time (days)"],
        yaxis_title = ["Number of jabs" "Jabs per day"]
    )
    open("./plot_fig2.html", "w") do io
        PlotlyBase.to_html(io, fig2.plot)
    end
    return fig, fig2
end
