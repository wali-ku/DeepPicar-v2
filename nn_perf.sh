#!/bin/bash

. funcs.sh

dataDir="datafiles/perf"

dnnThreads=1
corunners=3
dnnPrio=15

mkdir -p ${dataDir}

# This is to make sure that we don't use the GPU on TX-2
export CUDA_VISIBLE_DEVICES=''

# Set trace params
setup

# Run experiment without co-runners
echo "########## Starting Experiment..."
echo "========== Executing DNN Unlocked (Solo)"
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} 0 		  \
| tee ${dataDir}/nn${dnnThreads}_unlocked.solo
echo "========== Run Complete..."
echo "========== Waiting 5 seconds..."
echo
sleep 5

# Run experiment with co-runners
echo "========== Executing DNN Unlocked (Corun)"
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} ${corunners} write  \
| tee ${dataDir}/nn${dnnThreads}_unlocked.corun${corunners}
echo "========== Run Complete..."
echo "========== Waiting 5 seconds..."
echo
sleep 5

# Run experiment with co-runners and gang-lock
echo "========== Executing DNN Locked (Corun)"
set_rt_lock yes
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} ${corunners} write  \
| tee ${dataDir}/nn${dnnThreads}_locked.corun${corunners}
set_rt_lock no
echo "========== Run Complete..."
echo "========== Experiment Complete..."
