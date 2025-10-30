using UncertaintyQuantification

include(define_model.jl)

mc = MonteCarlo(2)

# s_mc = sobolindices(ext, [thermal_conductivity_sandstone_3; specific_heat_capacity_sandstone_3; density_sandstone_3; sandstone_porosity_parameter_3; kappa_sandstone_3], :disp, mc)

min_years = 25.0

mc_pf, mc_std, mc_samples = probability_of_failure(
    ext, df -> min_years .- df.disp, inputs, mc
)



rmprocs(workers())

