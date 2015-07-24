#!/bin/bash
#bpipe-batch is a program intended to wrap bpipe for use on the scinet gpc cluster
#Invocation:
#bpipe-batch.sh /path/to/my/pipeline <list of inputs> | qbatch 1 24:00:00
#It should be invoked in the directory that will contain the output

pipeline=$1
shift
args=( "$@" )

echo ${args[@]} | parallel --no-notice --recend "" --delimiter ' ' -N8 "echo bpipe run -n 8 -m 13930 $pipeline {1} {2} {3} {4} {5} {6} {7} {8}" | awk NF
