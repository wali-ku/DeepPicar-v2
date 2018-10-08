#!/bin/bash

. funcs.sh

board=${1}
dataDir="datafiles/perf/${board}"

dnnThreads=(4)
corunners=3
dnnPrio=15

mkdir -p ${dataDir}

# This is to make sure that we don't use the GPU on TX-2
export CUDA_VISIBLE_DEVICES=''

# Set trace params
setup

echo "########## Starting Experiment..."
for nnCnt in ${dnnThreads[@]}; do
	# Run experiment without co-runners
	echo "========== [NN: ${nnCnt}] Executing DNN Unlocked (Solo)"
	chrt -f ${dnnPrio} python test-model.py ${nnCnt} 0 		       \
	| tee ${dataDir}/nn${nnCnt}_unlocked.solo
	echo "========== Run Complete..."
	echo "========== Waiting 2 seconds..."
	echo
	sleep 2

	# Run experiment with co-runners
	echo "========== [NN: ${nnCnt}] Executing DNN Unlocked (Corun)"
	chrt -f ${dnnPrio} python test-model.py ${nnCnt} ${corunners} write    \
	| tee ${dataDir}/nn${nnCnt}_unlocked.corun${corunners}
	echo "========== Run Complete..."
	echo "========== Waiting 2 seconds..."
	echo
	sleep 2

	# Run experiment with co-runners and gang-lock
	echo "========== [NN: ${nnCnt}] Executing DNN Locked (Corun)"
	set_rt_lock yes
	chrt -f ${dnnPrio} python test-model.py ${nnCnt} ${corunners} write    \
	| tee ${dataDir}/nn${nnCnt}_locked.corun${corunners}
	set_rt_lock no
	echo "========== Run Complete..."
	echo "========== Experiment Complete..."
	echo "========== Waiting 2 seconds..."
	sleep 2
done
