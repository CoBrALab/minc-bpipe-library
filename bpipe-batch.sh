#!/bin/bash
#bpipe-batch is a program intended to wrap bpipe for use on the Niagara cluster
#Invocation:
#bpipe-batch.sh /path/to/my/pipeline <list of inputs> | qbatch -N bpipe-mycohort --chunksize 1 --walltime=5:00:00 -
#It should be invoked in the directory that will contain the output

set -euo pipefail

pipeline=$(readlink -f $1)
shift

abspathlist=""

for item in "$@"
do
  abspathlist+="$(readlink -f $item) "
done

n=0
while read -r line
do
  echo "mkdir -p run-${n}; cd run-${n}; bpipe run -n 80 ${pipeline} ${line}"
  ((++n))
done < <(xargs -n 40 <<< ${abspathlist})
