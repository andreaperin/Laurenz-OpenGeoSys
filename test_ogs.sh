#!/bin/zsh


start=$(date +%s)

OGS_LOG_LEVEL=error /home/perin/Documents/projects/work/code/ogs/build/bin/ogs model_inputs/OneLayer_IRZ_Coarse_Refined_mesh_test/OneLayer_IRZ_T1e2_konstVisk.prj -o Tests/outputs/OneLayer_test