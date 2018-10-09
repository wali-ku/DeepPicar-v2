#!/bin/bash

. funcs.sh

# Declare colors for pretty output
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[0;33m'
CYN='\033[0;36m'
NCL='\033[0m'

board=${1}
dataDir="datafiles/perf/${board}"

dnnThreads=(1)
dnnCores=("0")
corunners=3
dnnPrio=15
corunPrio=10

mkdir -p ${dataDir}

# This is to make sure that we don't use the GPU on TX-2
export CUDA_VISIBLE_DEVICES=''

# Set trace params
setup

exec_corunners () {
	chrt -f ${corunPrio} bandwidth -c 5 -m 16384 -t 10000 -a write &
	chrt -f ${corunPrio} bandwidth -c 4 -m 16384 -t 10000 -a write &
	chrt -f ${corunPrio} bandwidth -c 3 -m 16384 -t 10000 -a write &
}

echo -e "${GRN}########## Starting Experiment...${NCL}"
for nnCnt in `seq 0 $((${#dnnThreads[@]} - 1))`; do
	# Run experiment without co-runners
	nnThreads=${dnnThreads[${nnCnt}]}
	nnCores=${dnnCores[${nnCnt}]}

	echo -e "${CYN}========== [NN: ${nnCores}] Executing DNN Unlocked (Solo)${NCL}"
	chrt -f ${dnnPrio} taskset -c ${nnCores}			       \
		python test-model.py  ${nnThreads} 0  			       \
		| tee ${dataDir}/nn${nnThreads}_unlocked.solo
	echo -e "${GRN}========== Run Complete...${NCL}"
	echo -e "${YLW}========== Waiting 2 seconds...${NCL}"
	echo
	exec_corunners
	sleep 2

	# Run experiment with co-runners
	echo -e "${CYN}========== [NN: ${nnThreads}] Executing DNN Unlocked (Corun)${NCL}"
	chrt -f ${dnnPrio} taskset -c ${nnCores}			       \
		python test-model.py  ${nnThreads} 0  			       \
		| tee ${dataDir}/nn${nnThreads}_unlocked.corun${corunners}
	echo -e "${GRN}========== Run Complete...${NCL}"
	echo -e "${YLW}========== Waiting 2 seconds...${NCL}"
	echo
	sleep 2

	# Run experiment with co-runners and gang-lock
	echo -e "${CYN}========== [NN: ${nnThreads}] Executing DNN Locked (Corun)${NCL}"
	set_rt_lock yes
	chrt -f ${dnnPrio} taskset -c ${nnCores}			       \
		python test-model.py  ${nnThreads} 0  			       \
		| tee ${dataDir}/nn${nnThreads}_locked.corun${corunners}
	set_rt_lock no
	echo -e "${GRN}========== Run Complete...${NCL}"
	echo -e "${YLW}========== Waiting 2 seconds...${NCL}"
	echo
	killall bandwidth
	sleep 2
done
