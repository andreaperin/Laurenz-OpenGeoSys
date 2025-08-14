using Distributed

addprocs(2)

# Global constants
const MAIN_DIR = pwd()
const OGS_CMD = Sys.iswindows() ? joinpath(MAIN_DIR, "model", "ogs", "ogs.exe") : 
               Sys.isapple() ? joinpath(MAIN_DIR, "model", "ogs", "build", "bin", "ogs") : "ogs"
const SOURCE_DIR = joinpath(MAIN_DIR, "model_inputs", "OneLayer_faster")
const WORK_DIR = joinpath(MAIN_DIR, "output", "OneLayer_faster")

# Send constants to all workers
@everywhere const OGS_CMD = $OGS_CMD
@everywhere const SOURCE_DIR = $SOURCE_DIR
@everywhere const WORK_DIR = $WORK_DIR

@everywhere begin

    using UncertaintyQuantification, DelimitedFiles, Distributions

    include("exctractor_function.jl")

    #Variables

    # viscosity = RandomVariable(Uniform(1e-6, 1e-3), :viscosity)
    thermal_conductivity_sandstone_3 = RandomVariable(Truncated(Normal(2.09, 0.3), 1.0, 3.0), :thermal_conductivity_sandstone_3)
    specific_heat_capacity_sandstone_3 = RandomVariable(Truncated(Normal(820, 50), 700, 940), :specific_heat_capacity_sandstone_3)
    density_sandstone_3 = RandomVariable(Truncated(Normal(2690, 100), 2400, 2900), :density_sandstone_3)
    kappa_sandstone_3 = RandomVariable(LogNormal(log(2.39e-13), 1.0), :kappa_sandstone_3)
    sandstone_porosity_parameter_3 = RandomVariable(Truncated(Normal(0.2, 0.05), 0.1, 0.3), :sandstone_porosity_parameter_3)


    # External Model
    sourcefile = "OneLayer_T1e2.prj"
    extrafiles = ["OneLayer_3D_domain_ini.vtu", "OneLayer_3D_physical_group_Inj.vtu", "OneLayer_3D_physical_group_Pump.vtu", "OneLayer_3D.gml"]
    numberformats = Dict(:thermal_conductivity_sandstone_3 => ".2f", :specific_heat_capacity_sandstone_3 => ".1f", :density_sandstone_3 => ".0f", :sandstone_porosity_parameter_3 => ".3f", :kappa_sandstone_3 => ".2e")

    disp = Extractor(base -> begin
        x = 2000.0
        y = 0.0
        Δz = [-1340.55, 1274.45]
        
        out = extract_all_extraction_temperatures(base, x, y, Δz)
        
        times = [result[2] for result in out]
        idx = findmin(abs.(times .- 25.0))[2] # Return temperature closest to 25 years
        return out[idx][1] 
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

s_mc = sobolindices(ext, [thermal_conductivity_sandstone_3; specific_heat_capacity_sandstone_3; density_sandstone_3; sandstone_porosity_parameter_3; kappa_sandstone_3], :disp, mc)



rmprocs(workers())

