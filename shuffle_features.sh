#!/usr/bin/env bash

feat=$1
dsb_control=$2
dsb_treat=$3
seed=$4

# exclude repeats and feature regions
cat ~/Work/pipelines/data/hg19-telomere-centromere-telomere.bed | awk '{OFS="\t"; print$1,$2,$3+1 }' | cat - $feat > excluded

bedtools shuffle -excl excluded -seed $seed -i $feat -g mygenome > newfeat_"$seed"

parallel -k "bedtools intersect -a newfeat_"$seed" -b {} -c | datamash sum 4" ::: $dsb_control $dsb_treat
# parallel -k "bedtools intersect -a newfeat_"$seed" -b {} -c | cut -f4 | datamash transpose" ::: $dsb_control $dsb_treat

rm -f excluded newfeat_"$seed"

