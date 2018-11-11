#!/bin/bash

tgt="CPU"

# CPU Experiments
# ----------------
# 1N x 1C (Cortex)
# ================
echo "[${tgt}] Running: 1N x 1C (Cortex)"
CUDA_VISIBLE_DEVICES="" taskset -c 0 python test-model.py 1 0 > ${tgt}_1n1c_cx.perf &
wait
echo

# ----------------
# 1N x 1C (Denver)
# ================
echo "[${tgt}] Running: 1N x 1C (Denver)"
CUDA_VISIBLE_DEVICES="" taskset -c 1 python test-model.py 1 0 > ${tgt}_1n1c_dv.perf &
wait
echo

# ----------------
# 1N x 2C (Cortex)
# ================
echo "[${tgt}] Running: 1N x 2C (Cortex)"
CUDA_VISIBLE_DEVICES="" taskset -c 0,3 python test-model.py 2 0 > ${tgt}_1n2c_cx.perf &
wait
echo

# # ----------------
# # 1N x 2C (Denver)
# # ================
# echo "[${tgt}] Running: 1N x 2C (Denver)"
# CUDA_VISIBLE_DEVICES="" taskset -c 1,2 python test-model.py 2 0 > ${tgt}_1n2c_dv.perf &
# wait
# echo
# 
# # ----------------
# # 1N x 4C (Cortex)
# # ================
# echo "[${tgt}] Running: 1N x 4C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,3,4,5 python test-model.py 4 0 > ${tgt}_1n4c_cx.perf &
# wait
# echo
# 
# # ---------------
# # 1N x 6C
# # ===============
# echo "[${tgt}] Running: 1N x 6C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,1,2,3,4,5 python test-model.py 6 0 > ${tgt}_1n6c.perf &
# wait
# echo
# 
# # ---------------
# # 4N x 1C
# # ===============
# echo "[${tgt}] Running: 4N x 1C"
# CUDA_VISIBLE_DEVICES="" taskset -c 3 python test-model2.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 4 python test-model3.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 5 python test-model4.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 0 python test-model.py 1 0 &> ${tgt}_4n1c_cx.perf &
# wait
# echo
# 
# # ---------------
# # 6N x 1C
# # ===============
# echo "[${tgt}] Running: 6N x 1C"
# CUDA_VISIBLE_DEVICES="" taskset -c 1 python test-model2.py 1 &> ${tgt}_6n1c_dv.perf &
# CUDA_VISIBLE_DEVICES="" taskset -c 2 python test-model3.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 3 python test-model4.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 4 python test-model2.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 5 python test-model3.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 0 python test-model.py 1 0 &> ${tgt}_6n1c_cx.perf &
# wait
# echo
# 
# # ---------------
# # 2N x 2C (Homogeneous)
# # ===============
# echo "[${tgt}] Running: 2N x 2C (HM)"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,3 python test-model2.py 2 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 4,5 python test-model.py 2 0 &> ${tgt}_2n2c_hm.perf &
# wait
# echo
# 
# # ---------------
# # 2N x 2C (Heterogeneous)
# # ===============
# echo "[${tgt}] Running: 2N x 2C (HT)"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,3 python test-model2.py 2 &> ${tgt}_2n2c_cx.perf &
# CUDA_VISIBLE_DEVICES="" taskset -c 1,2 python test-model.py 2 0 &> ${tgt}_2n2c_dv.perf &
# wait
# echo
# 
# 
# # ---------------
# # 2N x 3C
# # ===============
# echo "[${tgt}] Running: 2N x 3C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,1,2 python test-model2.py 3 &> ${tgt}_2n3c_cd.perf &
# CUDA_VISIBLE_DEVICES="" taskset -c 3,4,5 python test-model.py 3 0 &> ${tgt}_2n3c_cx.perf &
# wait
# echo
