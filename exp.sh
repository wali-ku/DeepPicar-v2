#!/bin/bash

echo "[CPU] Running 1N x 6C (x2)"
CUDA_VISIBLE_DEVICES="" taskset -c 0,1,2,3,4,5 chrt -f 20 python test-model2.py 6  &> x2_n1c6_lp_rg.perf &
CUDA_VISIBLE_DEVICES="" taskset -c 0,1,2,3,4,5 chrt -f 25 python test-model.py 6 0 &> x2_n1c6_hp_rg.perf &
wait
echo
