#!/usr/bin/env bash

# GIVEN 1 DATASET, FORMATTED AS A LIST OF UNIQUE COMBINATION OF 3 FEATURES: CHR START END 
# RETURNS THE MEAN, SSTDEV AND THE COEFF OF VAR OF ALL READ COUNTS

exp=$1				# absolute path to the input file (typically is the chr-start-end-countUMI file)
win=$2				# size of the window for binning
gen=$3				# mm9 hg19
min=$4				# min umi for a location

cat $exp | awk -v min="$min" '{OFS="\t"; if ($4>min) print $0}' > ./file_"$win"_"$min"
~/Work/pipelines/aux.scripts/coverage.sh $win ./file_"$win"_"$min" $gen > "$exp"_"$win"

norma=$(cat "$exp"_"$win" | awk '{OFS="\t"; if ($4>0) print $4}' | numsum)
dim=$(cat "$exp"_"$win" | awk '{OFS="\t"; if ($4>0) print $4}' | wc -l)
shannon=$(cat "$exp"_"$win" | awk -v norma="$norma" -v dim="$dim" '{OFS="\t"} {if ($4>0) e+=(-$4/norma)*log($4/norma)} END {print e/log(dim)}')

echo $win $shannon

rm "$exp"_"$win" "$win"_"$gen" ./file_"$win"_"$min"
