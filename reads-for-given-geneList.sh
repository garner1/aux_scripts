#!/usr/bin/env bash

quality=$1			# quality of the mapped read
read=$2				# abosolute path to list of read for a given dataset
tss=$3				# full path to tss location for the ref genome
genes=$4			# full path to the list of genes
cutsite=$5			# absolute path to cutsite locations
output=$6			# name of output file

join -1 3 -2 1 $tss $genes|awk '{OFS="\t"; print $2,$3,$3+1,$4}' > tss

cat $read | awk -v q="$quality" '$6>=q'|bedtools window -a tss -b $read -w 5000 -c|datamash -s -g4 mean 5|tr ',' '.' > tss-RC

bedtools window -a tss -b $cutsite -w 5000 -c|datamash -s -g4 mean 5|tr ',' '.' > tss-CScount # find cutsites near tss
paste tss-RC tss-CScount | awk '$4>0'|awk '{printf "%s\t %2.2f\n",$1, $2/$4}'|LC_ALL=C sort -k2,2nr > $output

rm -f tss-{RC,CScount}
