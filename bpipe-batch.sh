#!/bin/bash
#bpipe-batch is a program intended to wrap bpipe for use on the scinet gpc cluster
#Invocation:
#bpipe-batch.sh /path/to/my/pipeline <list of inputs> | qbatch 1 24:00:00
#It should be invoked in the directory that will contain the output

pipeline=$1
shift
args=( "$@" )


for (( i=0; i<${#args[@]}; i++ ));
do
  args[$i]=$(readlink -f ${args[$i]})
done

for slices in $(seq 0 $(( ${#args[@]} / 8 )))
do
    begin=$(( $slices * 8  ))
    mkdir -p output${slices}
    echo "cd output${slices}; bpipe run -n 8 -m 13930 $pipeline ${args[@]:$begin:8}"
done
