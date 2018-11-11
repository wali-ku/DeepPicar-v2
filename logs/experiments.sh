#!/bin/bash

tgt="CPU"

# GPU Experiments
# ---------------
# 1N x 1C
# ===============
# echo "[${tgt}] Running: 1N x 1C"
# taskset -c 0 python test-model.py 1 0 > ${tgt}_1n1c.perf &
# wait
# echo

# ---------------
# 1N x 2C
# ===============
# echo "[${tgt}] Running: 1N x 2C"
# taskset -c 0,1 python test-model.py 2 0 > ${tgt}_1n2c.perf &
# wait
# echo

# ---------------
# 1N x 4C
# ===============
# echo "[${tgt}] Running: 1N x 2C"
# taskset -c 0,1,2,3 python test-model.py 4 0 > ${tgt}_1n4c.perf &
# wait
# echo

# ---------------
# 1N x 8C
# ===============
# echo "[${tgt}] Running: 1N x 8C"
# python test-model.py 8 0 > ${tgt}_1n8c.perf &
# wait
# echo


# # ---------------
# # 4N x 1C
# # ===============
# echo "[${tgt}] Running: 4N x 1C"
# CUDA_VISIBLE_DEVICES="" taskset -c 1 python test-model2.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 2 python test-model3.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 3 python test-model4.py 1 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 0 python test-model.py 1 0 &> ${tgt}_4n1c.perf &
# wait
# echo
#
# ---------------
# 8N x 1C
# ===============
echo "[${tgt}] Running: 8N x 1C"
CUDA_VISIBLE_DEVICES="" taskset -c 1 python test-model2.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 2 python test-model3.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 3 python test-model4.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 4 python test-model2.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 5 python test-model3.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 6 python test-model4.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 7 python test-model2.py 1 &> /dev/null &
CUDA_VISIBLE_DEVICES="" taskset -c 0 python test-model.py 1 0 &> ${tgt}_8n1c.perf &
wait
echo

# # ---------------
# # 2N x 2C
# # ===============
# echo "[${tgt}] Running: 2N x 2C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,1 python test-model2.py 2 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 2,3 python test-model.py 2 0 &> ${tgt}_2n2c.perf &
# wait
# echo
#
# # ---------------
# # 4N x 2C
# # ===============
# echo "[${tgt}] Running: 4N x 2C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,1 python test-model2.py 2 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 2,3 python test-model3.py 2 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 4,5 python test-model4.py 2 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 6,7 python test-model.py 2 0 &> ${tgt}_4n2c.perf &
# wait
# echo
#
#
# # ---------------
# # 2N x 4C
# # ===============
# echo "[${tgt}] Running: 2N x 4C"
# CUDA_VISIBLE_DEVICES="" taskset -c 0,1,2,3 python test-model2.py 4 &> /dev/null &
# CUDA_VISIBLE_DEVICES="" taskset -c 4,5,6,7 python test-model.py 4 0 &> ${tgt}_2n4c.perf &
# wait
# echo
