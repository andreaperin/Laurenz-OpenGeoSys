#!/bin/bash
#SBATCH --account=andrea.perin
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --output=pce_fullmodel_stdoutput.txt
#SBATCH --error=pce_fullmodel_stderror.txt

julia -p $SLURM_CPUS_PER_TASK --project=/home/andrea.perin/ThermoOptiPlan -e 'using Pkg; Pkg.instantiate(); include("./new_pce.jl")'
