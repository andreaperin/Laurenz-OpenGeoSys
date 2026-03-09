#!/bin/zsh


start=$(date +%s)

#OGS_LOG_LEVEL=error /home/perin/Documents/projects/work/code/ogs/build/bin/ogs model_inputs/OneLayer_Coarse_test/OneLayer_T1e2.prj -o Tests/outputs/OneLayer_test

/home/perin/Documents/projects/work/code/ogs/build/bin/ogs model_inputs/Model_ML_IRZ/MULTI_BW_line_IRZ.prj -o Tests/outputs/OneLayer_test
