#!/bin/bash

. funcs.sh

traceDir="kernTraces"
dataDir="datafiles/kshark"

dnnThreads=4
corunners=3
dnnPrio=15

mkdir -p ${traceDir}
mkdir -p ${dataDir}

# This is to make sure that we don't use the GPU on TX-2
export CUDA_VISIBLE_DEVICES=''

# Set trace params
setup

# Run experiment without co-runners
echo "########## Starting Experiment..."
echo "========== Executing DNN Unlocked (Solo)"
trace-cmd record -e  'sched_wakeup*' -e sched_switch -e 'sched_migrate*' \
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} 0 		 \
| tee ${dataDir}/nn${dnnThreads}_unlocked.solo
mv trace.dat ${traceDir}/unlocked.solo
echo "========== Run Complete..."
echo "========== Waiting 5 seconds..."
echo
sleep 5

# Run experiment with co-runners
echo "========== Executing DNN Unlocked (Corun)"
flush_trace
trace-cmd record -e  'sched_wakeup*' -e sched_switch -e 'sched_migrate*' \
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} ${corunners} write \
| tee ${dataDir}/nn${dnnThreads}_unlocked.corun${corunners}
mv trace.dat ${traceDir}/unlocked.corun${corunners}
echo "========== Run Complete..."
echo "========== Waiting 5 seconds..."
echo
sleep 5

# Run experiment with co-runners and gang-lock
echo "========== Executing DNN Locked (Corun)"
flush_trace
set_rt_lock yes
trace-cmd record -e  'sched_wakeup*' -e sched_switch -e 'sched_migrate*' \
chrt -f ${dnnPrio} python test-model.py ${dnnThreads} ${corunners} write \
| tee ${dataDir}/nn${dnnThreads}_locked.corun${corunners}
set_rt_lock no
mv trace.dat ${traceDir}/locked.corun${corunners}
echo "========== Run Complete..."
echo "########## Experiment Complete!"
