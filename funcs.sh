#!/bin/bash

pDebugFs=/sys/kernel/debug
pTrace=${pDebugFs}/tracing

flush_trace () {
	echo > ${pTrace}/trace;
}

setup () {
	flush_trace;
	echo 16384 > ${pTrace}/buffer_size_kb;
	echo nop > ${pTrace}/current_tracer;
	echo 1 > ${pTrace}/tracing_on;
}

# $1 : Enable (1) | Disable (0) logging sched events in ftrace
set_sched_events () {
	echo ${1} > ${pTrace}/events/sched/enable;
}

show_setup () {
	echo "========= Trace Buffer";
	cat ${pTrace}/trace;
	echo

	echo "========= Buffer Size KB";
	cat ${pTrace}/buffer_size_kb;
	echo

	echo "========= Tracing On";
	cat ${pTrace}/tracing_on;
	echo
}

show_sched_feats () {
	echo "========= Sched Features";
	cat ${pDebugFs}/sched_features;
	echo
}

set_sched_feat () {
	echo ${1} > ${pDebugFs}/sched_features;
}

set_rt_lock () {
	choice=${1}
	case ${choice} in
		yes)
			set_sched_feat RT_GANG_LOCK;
			;;
		no)
			set_sched_feat NO_RT_GANG_LOCK;
			;;
		*)
			echo "Invalid option. Please specify 'yes' or 'no'"
			;;
	esac
}

alias vitrc='vi /sys/kernel/debug/tracing/trace'
