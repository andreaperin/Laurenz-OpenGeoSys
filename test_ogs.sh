#!/bin/zsh


start=$(date +%s)

OGS_LOG_LEVEL=error ./model/ogs/build/bin/ogs model_inputs/OneLayer_faster/OneLayer_T1e2.prj -o Tests/outputs/OneLayer_faster