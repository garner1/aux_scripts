#!/usr/bin/env bash

#execute from dataset dir!!!

window=$1			# size of the window
bedfile=$2			# file where each row represent a unique feature
genome=$3
sliding=$4			# how much to slide before starting the second window

if [ ! -f "$window"_"$genome" ]; then
    ~/Work/pipelines/aux.scripts/make-windows.sh $window $genome $sliding > "$window"_"$genome"
fi

bedtools intersect -a "$window"_"$genome" -b $bedfile -c | 
grep -v "_" | grep -v "_\|chrM" | sed -e 's/chrX/chr23/g' | sed -e 's/chrY/chr24/g' | 
LC_ALL=C sort -k1.4n -k2,2n | sed -e 's/chr23/chrX/' | sed -e 's/chr24/chrY/'

# rm -f "$window"_"$genome"
