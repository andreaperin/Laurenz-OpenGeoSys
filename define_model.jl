using Distributed

addprocs(2)

# Global constants
const MAIN_DIR = pwd()
const OGS_CMD = Sys.iswindows() ? joinpath(MAIN_DIR, "model", "ogs", "ogs.exe") : 
               Sys.isapple() ? joinpath(MAIN_DIR, "model", "ogs", "build", "bin", "ogs") : "ogs"
const SOURCE_DIR = joinpath(MAIN_DIR, "model_inputs", "OneLayer_IRZ_Coarse_Refined_mesh")
const WORK_DIR = joinpath(MAIN_DIR, "output", "OneLayer_IRZ_Coarse_Refined_mesh")

# Send constants to all workers
@everywhere const OGS_CMD = $OGS_CMD
@everywhere const SOURCE_DIR = $SOURCE_DIR
@everywhere const WORK_DIR = $WORK_DIR

@everywhere begin

    using UncertaintyQuantification, DelimitedFiles, Distributions, LinearAlgebra

    include("exctractor_function.jl")

    #Variables

    # Define marginal Distributions first (we'll wrap them as RandomVariable below).
    # viscosity = RandomVariable(Uniform(1e-6, 1e-3), :viscosity)
    dist_thermal_conductivity_sandstone_3 = Truncated(Normal(2.09, 0.25), 1.5675, 2.6125) # Approx 25% uncertainty window tapered towards the limits
    dist_specific_heat_capacity_sandstone_3 = Truncated(Normal(820, 80), 615, 1025) # Approx 25% uncertainty window tapered towards the limits
    dist_density_sandstone_3 = Truncated(Normal(2690, 100), 2400, 2900) # Approx 10% uncertainty window tapered towards the limits
    dist_kappa_sandstone_3 = Truncated(Normal(2.39e-13, 2.39e-14), 1.912e-13, 2.868e-13) # Approx 20% uncertainty window tapered towards the limits
    dist_sandstone_porosity_parameter_3 = Truncated(Normal(0.2, 0.01), 0.18, 0.22) # Approx 20% uncertainty window tapered towards the limits

    # Wrap as RandomVariable objects (used by UQ routines)
    thermal_conductivity_sandstone_3 = RandomVariable(dist_thermal_conductivity_sandstone_3, :thermal_conductivity_sandstone_3)
    specific_heat_capacity_sandstone_3 = RandomVariable(dist_specific_heat_capacity_sandstone_3, :specific_heat_capacity_sandstone_3)
    density_sandstone_3 = RandomVariable(dist_density_sandstone_3, :density_sandstone_3)
    kappa_sandstone_3 = RandomVariable(dist_kappa_sandstone_3, :kappa_sandstone_3)
    sandstone_porosity_parameter_3 = RandomVariable(dist_sandstone_porosity_parameter_3, :sandstone_porosity_parameter_3)

    const USE_COPULA = true

    inputs = [
        thermal_conductivity_sandstone_3,
        specific_heat_capacity_sandstone_3,
        density_sandstone_3,
        sandstone_porosity_parameter_3,
        kappa_sandstone_3,
    ]

    if USE_COPULA
        rho = 0.8
        k = length(inputs)
        Σ = Matrix{Float64}(I, k, k)
        Σ[4, 5] = rho
        Σ[5, 4] = rho

        D = sqrt.(diag(Σ))
        R = Σ ./ (D * D')

        marginals = RandomVariable[
            thermal_conductivity_sandstone_3,
            specific_heat_capacity_sandstone_3,
            density_sandstone_3,
            sandstone_porosity_parameter_3,
            kappa_sandstone_3,
        ]

        inputs = [JointDistribution(marginals, GaussianCopula(R))]
    end

    # External Model
    sourcefile = "OneLayer_IRZ_T1e2_konstVisk.prj"
    extrafiles = ["OneLayer_3D_domain_ini.vtu", "OneLayer_3D_physical_group_Inj.vtu", "OneLayer_3D_physical_group_Pump.vtu", "OneLayer_3D.gml"]
    numberformats = Dict(:thermal_conductivity_sandstone_3 => ".2f", :specific_heat_capacity_sandstone_3 => ".1f", :density_sandstone_3 => ".0f", :sandstone_porosity_parameter_3 => ".3f", :kappa_sandstone_3 => ".2e")

    function find_crossing_year(temps::AbstractVector{<:Real}, times::AbstractVector{<:Real}; threshold = 71.0 + 273.15)
        isempty(temps) && return NaN
        temps[1] <= threshold && return times[1]
        for i in 1:length(temps)-1
            if temps[i] >= threshold && temps[i+1] <= threshold
                T1, T2 = temps[i], temps[i+1]
                t1, t2 = times[i], times[i+1]
                return (T1 == T2) ? (T1 == threshold ? t1 : NaN) : t1 + (threshold - T1)*(t2 - t1)/(T2 - T1)
            end
        end
        return NaN
    end

    disp = Extractor(base -> begin
        x = 2000.0
        y = 0.0
        Δz = [-1340.55, 1274.45]
        
        out = extract_all_extraction_temperatures(base, x, y, Δz)
        th = 71.0 + 273.15
        return find_crossing_year([r[1] for r in out], [r[2] for r in out]; threshold = th)
    end, :disp)

    ogs = Solver(OGS_CMD,
        sourcefile;
        args="",
    )

    ext = ExternalModel(
        SOURCE_DIR, sourcefile, disp, ogs, workdir = WORK_DIR, extras = extrafiles, formats = numberformats, cleanup = true,
    )

end


mc = MonteCarlo(2)

# s_mc = sobolindices(ext, [thermal_conductivity_sandstone_3; specific_heat_capacity_sandstone_3; density_sandstone_3; sandstone_porosity_parameter_3; kappa_sandstone_3], :disp, mc)

min_years = 25.0

mc_pf, mc_std, mc_samples = probability_of_failure(
    ext, df -> min_years .- df.disp, inputs, mc
)



rmprocs(workers())

