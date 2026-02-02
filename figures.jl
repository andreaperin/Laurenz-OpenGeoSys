using UncertaintyQuantification
using JLD2
using LaTeXStrings
using PGFPlotsX
using DataFrames

@load "results/sensitivity/Sobols_pce.jld2"

function latexify(varname::String)
    if varname == "thermal_conductivity_sandstone_3"
        return L"Th Cond"
    elseif varname == "specific_heat_capacity_sandstone_3"
        return L"Spec Heat"
    elseif varname == "density_sandstone_3"
        return L"Density"
    elseif varname == "kappa_sandstone_3"
        return L"Permeability"
    elseif varname == "sandstone_porosity_parameter_3"
        return L"Porosity"
    end
end

function plot_sobols(df::DataFrame, title::LaTeXString; height::String="8cm", width::String="15cm", bar_width::Float64=0.2, bar_shift_amt::Float64=0.20, color_first_order::String="orange", color_total_effect::String="red")
    class_labels = string.(df.Variables)
    class_labels_latex = latexify.(class_labels)

    group1_values = df.FirstOrder
    group2_values = df.TotalEffect
    n = length(class_labels)

    pgf = @pgf Axis(
        {
            ybar,
            bar_width = bar_width,
            xtick = 1:n,
            xticklabels = class_labels_latex,
            xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
            enlargelimits = 0.05,
            ylabel = "",
            ymin = 0,
            ymax = 1,
            height = height,
            width = width,
            title = title,
            grid = "major"
        },
        # Group 1: shifted left
        Plot({fill = color_first_order, bar_shift = "-$(bar_shift_amt)cm"}, Coordinates([(i, group1_values[i]) for i in 1:n])),
        # Group 2: shifted right
        Plot({fill = color_total_effect, bar_shift = "$(bar_shift_amt)cm"}, Coordinates([(i, group2_values[i]) for i in 1:n])),
        Legend(["First Order", "Total Effect"])
    )
    return pgf
end

# title = L"Sobol's Indices - Crossing Year - 500 samples - Sandstone3"
# plot_sobol = plot_sobols(s_mc, title, bar_width=0.12)
# path2save = "/home/perin/Documents/academic/slides/thermoptiplan/2_second_presentation_INTERNAL/imgs"
# PGFPlotsX.save(joinpath(path2save, "Sobols.pdf"), plot_sobol)


s_mc = DataFrame(
    Variables=Symbol[
        :thermal_conductivity_sandstone_3,
        :specific_heat_capacity_sandstone_3,
        :density_sandstone_3,
        :sandstone_porosity_parameter_3,
        :kappa_sandstone_3
    ],
    FirstOrder=Float64[
        0.00482,
        0.86120,
        0.10640,
        0.00731,
        0.000455
    ],
    FirstOrderStdError=Float64[
        0.00358,
        0.00361,
        0.00374,
        0.00369,
        0.00363
    ],
    TotalEffect=Float64[
        0.00501,
        0.86590,
        0.09580,
        0.00871,
        0.00102
    ],
    TotalEffectStdError=Float64[
        0.00422,
        0.00429,
        0.00438,
        0.00431,
        0.00446
    ]
)

title = L"Sobol's Indices - Crossing Year - 128 samples - Sandstone3"
plot_sobol = plot_sobols(s_mc, title, bar_width=0.12)
path2save = "/home/perin/Documents/academic/slides/thermoptiplan/3_third_presentation_INTERNAL"
PGFPlotsX.save(joinpath(path2save, "Sobols_new.pdf"), plot_sobol)