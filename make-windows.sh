#!/usr/bin/env bash

window=$1
genome=$2			# hg19 or mm9
sliding=$3


if [ ! -f ./sizes ]; then
    ~/Work/pipelines/aux.scripts/fetchChromSizes.sh $genome | grep -v "_" > sizes
fi

if [ -z $sliding ]; then
    temp_file=$(mktemp)
    cp sizes ${temp_file}
    bedtools makewindows -g ${temp_file} -w "$window"
fi
if [ ! -z $sliding ]; then
    temp_file=$(mktemp)
    cp sizes ${temp_file}
    bedtools makewindows -g ${temp_file} -w "$window" -s "$sliding"
fi

# rm sizes
