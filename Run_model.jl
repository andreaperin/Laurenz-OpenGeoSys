using UncertaintyQuantification

using DelimitedFiles

include("exctractor_function.jl")


viscosity = RandomVariable(Uniform(1e-6, 1e-3), :viscosity)



sourcedir = joinpath(pwd(), "model_inputs/OneLayer_faster/OneLayer_faster")

sourcefile = "OneLayer_T1e2.prj"

numberformats = Dict(:viscosity => ".8e")

workdir = joinpath(pwd(), "output/OneLayer_faster")

disp = Extractor(base -> begin
    x = 2000.0
    y = 0.0
    Δz = [0.0, 100.0]
    
    return extract_all_extraction_temperatures(base, x, y, Δz)
end, :disp)

if Sys.iswindows()
    ogs_cmd = "./OGS_bin/ogs.exe"
else
    ogs_cmd = "ogs"  # Update this path to your OGS installation
end

ogs = Solver(ogs_cmd,
    sourcefile;
    args="",
)

ext = ExternalModel(
    sourcedir, sourcefile, disp, ogs, workdir = workdir, formats = numberformats,
)

mc = MonteCarlo(1)

s_mc = sobolindices(ext, viscosity, :viscosity, mc)