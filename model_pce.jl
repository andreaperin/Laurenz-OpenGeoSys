using UncertaintyQuantification, Serialization
include("define_model.jl")


const TRAIN_SAMPLES = 500
const PCE_DEGREE = 4

println("Preparing PCE with TRAIN_SAMPLES=$TRAIN_SAMPLES, degree=$PCE_DEGREE")

function choose_basis(rv)
	try
		d = rv.dist
		if d isa Uniform
			return LegendreBasis()
		else
			return HermiteBasis()
		end
	catch
		return HermiteBasis()
	end
end

bases = [choose_basis(rv) for rv in inputs]
Ψ = PolynomialChaosBasis(bases, PCE_DEGREE)

est = LeastSquares(SobolSampling(TRAIN_SAMPLES))

println("Running polynomial chaos construction (this may run external model per sample)...")

pce, samples, mse = polynomialchaos(inputs, ext, Ψ, :disp, est)

println("PCE built. Training MSE = $mse")
println("PCE mean (surrogate) = $(mean(pce))")
println("PCE variance (surrogate) = $(var(pce))")

nsamp = 10000
psamps = UncertaintyQuantification.sample(pce, nsamp)

println("Surrogate sample mean: $(mean(psamps.disp)), var: $(var(psamps.disp))")

println("Finished PCE run — consider increasing TRAIN_SAMPLES for higher accuracy.")

open("my_pce_model.jls", "w") do io
    serialize(io, pce)
end

# using Serialization
# pce = open(deserialize, "my_pce_model.jls")

rmprocs(workers())

