using Distributed
using JLD2
using Dates

addprocs(8)

@everywhere begin

    using UncertaintyQuantification, DelimitedFiles, LinearAlgebra

    const training_size = 2

    const degree = 4
    const SOBOL_SAMPLING = true

    const MAIN_DIR = pwd()
    const OGS_CMD =
    if Sys.iswindows()
        joinpath(MAIN_DIR, "model", "ogs", "ogs.exe")
    elseif Sys.isapple()
        joinpath(MAIN_DIR, "model", "ogs", "build", "bin", "ogs")
    elseif Sys.islinux()
        osrelease = "/etc/os-release"
        data = read(osrelease, String)
        if occursin("Solus", data)
            expanduser("/home/perin/Documents/projects/work/code/ogs/build/bin/ogs")
        elseif occursin("NixOS", data)
            "/home/lau/Seafile/Documents/MT/Masterthesis_Github_Projects/ogs/ogs/build/bin/ogs"
        end
    end
    const WORK_DIR = joinpath(MAIN_DIR, "output", "OneLayer_IRZ_Coarse_Refined_mesh")
    const SOURCE_DIR = joinpath(MAIN_DIR, "model_inputs", "OneLayer_IRZ_Coarse_Refined_mesh")
    # const SOURCE_DIR = joinpath(MAIN_DIR, "model_inputs", "OneLayer_IRZ_Coarse_Refined_mesh_test")

    const USE_COPULA = false

    # External Model Settings
    const cleanup = true
    const sourcefile = "MULTI_BW_line_IRZ.prj"
    const extrafiles = [
                        "MULTI_BW_line_IRZ_domain_ini.vtu",
                        "MULTI_BW_line_IRZ_domain.vtu",
                        "MULTI_BW_line_IRZ.geo",
                        "MULTI_BW_line_IRZ.msh",
                        "MULTI_BW_line_IRZ_physical_group_boundary_ini.vtu",
                        "MULTI_BW_line_IRZ_physical_group_boundary.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Clay_1.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Clay_2.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Inj_line_2.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Inj_line_3.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Inj_line_4.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Pump_line_2.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Pump_line_3.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Pump_line_4.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Sand_2.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Sand_3.vtu",
                        "MULTI_BW_line_IRZ_physical_group_Sand_4.vtu",
                        "MULTI_BW_line_IRZ.pvd",
                        "MULTI_BW_line_IRZ_physical_group_Sand_2.vtu"
                       ]

    const numberformats = Dict(:thermal_conductivity_sandstone_3 => ".2f", :specific_heat_capacity_sandstone_3 => ".1f", :density_sandstone_3 => ".0f", :sandstone_porosity_parameter_3 => ".3f", :kappa_sandstone_3 => ".2e")
    const x_extractor = 2_000.0
    const y_extractor = 0.0
    const Δz_extractor = [-1340.55, 1274.45]
    const T_threshold = 70.0 + 273.15

    include("exctractor_function.jl")

    #Variables

    # Define marginal Distributions first (we'll wrap them as RandomVariable below).
    # viscosity = RandomVariable(Uniform(1e-6, 1e-3), :viscosity)
    dist_thermal_conductivity_sandstone_3 = Truncated(Normal(2.09, 0.25), 1.5675, 2.6125) # Approx 25% uncertainty window tapered towards the limits
    dist_specific_heat_capacity_sandstone_3 = Truncated(Normal(820, 80), 615, 1025) # Approx 25% uncertainty window tapered towards the limits
    dist_density_sandstone_3 = Truncated(Normal(2690, 100), 2400, 2800) # Approx 10% uncertainty window tapered towards the limits
    dist_kappa_sandstone_3 = Truncated(Normal(2.39e-13, 2.39e-14), 1.912e-13, 2.868e-13) # Approx 20% uncertainty window tapered towards the limits
    ## LOG Permeability
    μ_kappa_sandstone_3 = 2.39e-13
    σ_kappa_sandstone_3 = 2.39e-14
    lo_kappa_sandstone_3 = 1.912e-13
    hi_kappa_sandstone_3 = 2.868e-13
    m = mean(dist_kappa_sandstone_3)
    v = var(dist_kappa_sandstone_3)
    σ_log² = log(1 + v / m^2)
    σ_log = sqrt(σ_log²)
    μ_log = log(m) - 0.5 * σ_log²
    dist_log_kappa_sandstone_3 = Truncated(LogNormal(μ_log, σ_log), 1.912e-13, 2.868e-13)

    dist_sandstone_porosity_parameter_3 = Truncated(Normal(0.2, 0.05), 0.12, 0.30) # Approx 20% uncertainty window tapered towards the limits
    # Wrap as RandomVariable objects (used by UQ routines)
    thermal_conductivity_sandstone_3 = RandomVariable(dist_thermal_conductivity_sandstone_3, :thermal_conductivity_sandstone_3)
    specific_heat_capacity_sandstone_3 = RandomVariable(dist_specific_heat_capacity_sandstone_3, :specific_heat_capacity_sandstone_3)
    density_sandstone_3 = RandomVariable(dist_density_sandstone_3, :density_sandstone_3)
    kappa_sandstone_3 = RandomVariable(dist_kappa_sandstone_3, :kappa_sandstone_3)
    log_kappa_sandstone_3 = RandomVariable(dist_log_kappa_sandstone_3, :log_kappa_sandstone_3)

    sandstone_porosity_parameter_3 = RandomVariable(dist_sandstone_porosity_parameter_3, :sandstone_porosity_parameter_3)

    inputs = [
              thermal_conductivity_sandstone_3,
              specific_heat_capacity_sandstone_3,
              density_sandstone_3,
              sandstone_porosity_parameter_3,
              kappa_sandstone_3,
              # log_kappa_sandstone_3,
             ]

    function find_crossing_year(temps::AbstractVector{<:Real}, times::AbstractVector{<:Real}; threshold=T_threshold)
        isempty(temps) && return NaN
        temps[1] <= threshold && return times[1]
        for i in 1:length(temps)-1
            if temps[i] >= threshold && temps[i+1] <= threshold
                T1, T2 = temps[i], temps[i+1]
                t1, t2 = times[i], times[i+1]
                return (T1 == T2) ? (T1 == threshold ? t1 : NaN) : t1 + (threshold - T1) * (t2 - t1) / (T2 - T1)
            end
        end
        return NaN
    end

    function find_crossing_year(pairs::AbstractVector; threshold=T_threshold)
        isempty(pairs) && return NaN
        temps = Float64[]
        times = Float64[]
        for p in pairs
            if !(isa(p, AbstractVector) || isa(p, Tuple))
                throw(ArgumentError("each element must be a 2-element vector or tuple [temp, time]"))
            end
            length(p) < 2 && throw(ArgumentError("each element must have at least two entries: [temp, time]"))
            push!(temps, float(p[1]))
            push!(times, float(p[2]))
        end
        return find_crossing_year(temps, times; threshold=threshold)
    end

    crossing_year = Extractor(base -> begin
                                  x = x_extractor
                                  y = y_extractor
                                  Δz = Δz_extractor

                                  return find_crossing_year(extract_all_extraction_temperatures(base, x, y, Δz); threshold=T_threshold)
                              end, :crossing_year)

    ogs = Solver(OGS_CMD,
                 sourcefile;
                 args="",
                )

    # log_model = Model(df -> exp.(df.log_kappa_sandstone_3), :kappa_sandstone_3)
    ext = ExternalModel(
                        SOURCE_DIR, sourcefile, crossing_year, ogs, workdir=WORK_DIR, extras=extrafiles, formats=numberformats, cleanup=cleanup,
                       )

    bases = repeat([LegendreBasis()], length(inputs))
    Ψ = PolynomialChaosBasis(bases, degree)

    if SOBOL_SAMPLING
        est = LeastSquares(SobolSampling(training_size))
    else
        est = LeastSquares(MonteCarlo(training_size))
    end

end

# """Sobol's Indices"""
# path_to_sensitivity = joinpath(pwd(), "results", "sensitivity")
# mkpath(path_to_sensitivity)

# @show("start sensitivity analysis with $(sobolsimulation)")
# @time sobols = sobolindices(ext, inputs, :crossing_year, sobolsimulation)

# name = Dates.format(now(), "yyyy_mm_dd_HH_MM") * "_" * string(sobolsimulation) * ".jld2"
# @save joinpath(path_to_sensitivity, name) sobols


"""PolynomialChaosExpansion"""
path_to_pce = joinpath(pwd(), "results", "pce")
mkpath(path_to_pce)

@show("start pce analysis with simulation: $(est)")
@time pce, samples, mse = polynomialchaos(inputs, ext, Ψ, :crossing_year, est)
# @time pce, samples, mse = polynomialchaos(inputs, [log_model, ext], Ψ, :crossing_year, est)
res = [pce, samples, mse]

name = Dates.format(now(), "yyyy_mm_dd_HH_MM") * "_sobolsampling" * string(SOBOL_SAMPLING) * "_" * string(training_size) * ".jld2"
@save joinpath(path_to_pce, name) res

rmprocs(workers())
