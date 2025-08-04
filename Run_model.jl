using UncertaintyQuantification

using DelimitedFiles

include("exctractor_function.jl")

#Variables

viscosity = RandomVariable(Uniform(1e-6, 1e-3), :viscosity)


# External Model

if Sys.iswindows()
    ogs_cmd = joinpath(pwd(), "model", "ogs", "ogs.exe")
elseif Sys.isMacOS()
    ogs_cmd = joinpath(pwd(), "model", "ogs", "build", "bin", "ogs")
else
    ogs_cmd = "ogs" # Assuming ogs is on PATH
end

sourcedir = joinpath(pwd(), "model_inputs", "OneLayer_faster")
sourcefile = "OneLayer_T1e2.prj"
extrafiles = ["OneLayer_3D_domain_ini.vtu", "OneLayer_3D_physical_group_inj.vtu", "OneLayer_3D_physical_group_Pump.vtu", "OneLayer_3D.gml"]
workdir = joinpath(pwd(), "output", "OneLayer_faster")

numberformats = Dict(:viscosity => ".8e")

disp = Extractor(base -> begin
    x = 2000.0
    y = 0.0
    Δz = [-1340.55, 1274.45]
    
    out = extract_all_extraction_temperatures(base, x, y, Δz)
    
    times = [result[2] for result in out]
    idx = findmin(abs.(times .- 25.0))[2] # Return temperature closest to 25 years
    return out[idx][1] 
end, :disp)

ogs = Solver(ogs_cmd,
    sourcefile;
    args="",
)

ext = ExternalModel(
    sourcedir, sourcefile, disp, ogs, workdir = workdir, extras = extrafiles, formats = numberformats, cleanup = true,
)

mc = MonteCarlo(1)

s_mc = sobolindices(ext, viscosity, :disp, mc)