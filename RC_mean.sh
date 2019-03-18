#!/usr/bin/env bash

# GIVEN 1 DATASET, FORMATTED AS A LIST OF UNIQUE COMBINATION OF 3 FEATURES: CHR START END 
# RETURNS THE MEAN, SSTDEV AND THE COEFF OF VAR OF ALL READ COUNTS

exp=$1				# absolute path to the input file (tyepically is the loc-str-umi-pcr file)
win=$2				# size of the window for binning
gen=$3				# mm9 hg19

~/Work/pipelines/aux.scripts/coverage.sh $win $exp $gen > "$exp"_"$win"
cat "$exp"_"$win" | datamash mean 4 sstdev 4 | tr ',' '.' | awk '{OFS="\t";if ($1!=0) print $1,$2,$2/$1; else print $1,$2}'

rm "$exp"_"$win" "$win"_"$gen" 
