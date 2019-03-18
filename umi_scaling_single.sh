#!/usr/bin/env bash

# GIVEN A DATASET, FORMATTED AS: CHR START END UMI-COUNT
# IT PROVIDES THE NUMBER OF DSB WITH AT LEAST A GIVEN VALUE OF UMI, TOGETHER WITH THE NUMBER OF DSB IN THE VICINITY OF TSS

file=$1				# absolute path to the file with UMI counts on the 4th col
ref=$2 				# hg19 or mm9
max=$3				# max allowed UMI
# min=$4				# length of the loop

min=$(cat $file|datamash max 4)
for min in $(seq 1 10 "$min");
do
    cat $file | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > "$file"-dataset

    # if [ "$ref" = "hg19" ]; then
    # 	bedtools window -w 5000 -b "$file"-dataset -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > "$file"-tss_dataset.bed
    # fi
    # if [ "$ref" = "mm9" ]; then
    # 	bedtools window -w 5000 -b "$file"-dataset -a ~/Work/pipelines/data/TSS_mm9.bed|cut -f4-6|LC_ALL=C sort -u > "$file"-tss_dataset.bed
    # fi

    _1=$(cat "$file"-dataset | wc -l)
    # tss1=$(cat "$file"-tss_dataset.bed | wc -l)

    # echo "$_1" "$tss1"
    echo $min "$_1"
    rm -f "$file"-dataset "$file"-tss_dataset.bed 
done
