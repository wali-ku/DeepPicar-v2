#!/bin/bash

corunners=5
accessType=('read' 'write')
execType=('CPU' 'GPU')

cd ..
for execution in ${execType[@]}; do
	for access in ${accessType[@]}; do
		for num_of_corunners in `seq 1 ${corunners}`; do
			for core in `seq 1 ${num_of_corunners}`; do
				# Start corunners
				printf "[STATUS] Starting bandwidth (%s) on Core-%d\n" ${access} ${core}
				bandwidth -c ${core} -m 16384 -t 10000 -a ${access} &> /dev/null &
			done

			sleep 2
			printf "[STATUS] Running DNN on %s with %d corunners\n" ${execution} ${num_of_corunners}
			if [ "${execution}" == "CPU" ]; then
				CUDA_VISIBLE_DEVICES='' taskset -c 0 python test-model.py 1 0 2>&1 | tee tx2/${execution}_bw${num_of_corunners}_${access}.perf
			else
				taskset -c 0 python test-model.py 1 0 2>&1 | tee tx2/${execution}_bw${num_of_corunners}_${access}.perf
			fi
			echo '-------------------------------------------------'
			killall bandwidth
		done
		echo
	done
	echo
done

cd tx2
mv ../*.perf .
