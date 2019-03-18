#!/usr/bin/env bash

#execute from dataset dir!!!

window=$1			# size of the window
bedfile=$2			# file where each row represent a unique feature
genome=$3

if [ ! -f "$window"_"$genome" ]; then
    ~/Work/pipelines/aux.scripts/make-windows.sh $window $genome > "$window"_"$genome"
fi

bedtools intersect -a "$window"_"$genome" -b $bedfile -c | cut -f4 > $window.out 
python /home/garner1/Work/pipelines/aux.scripts/shannon.py $window.out 

# rm -f "$window"_"$genome"
