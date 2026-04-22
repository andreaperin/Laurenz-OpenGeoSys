#!/bin/bash
#SBATCH --account=andrea.perin
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=29
#SBATCH --mail-user=andrea.perin@irz.uni-hannover.de
#SBATCH --mail-type=ALL

module load OpenGeoSys

export OMP_NUM_THREADS=1

julia -p $SLURM_CPUS_PER_TASK --project=/home/andrea.perin/ThermoOptiPlan -e 'using Pkg; Pkg.instantiate(); include("./new_pce.jl")'
