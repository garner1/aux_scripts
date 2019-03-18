#!/usr/bin/env bash

# GIVEN 2 DATASETS, FILTERS EACH OF THEM WRT UMI VALUES, AND THEN IT SEPARATES EXCLUSIVES VS COMMON LOCATIONS

exp1=$1				# rm53T
exp2=$2				# rm53NT
file1=$3			# full path to rm53T
file2=$4			# full path to rm53NT
ref=$5 				# hg19 or mm9
max=$6				# max allowed UMI
min=$7				# length of the loop

for min in $(seq 1 "$min");
do
    bedtools intersect -a $file1 -b $file2 -wb | awk '{OFS="\t";print $1,$2,$3,$4+$8}' | 
    awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=2*max) print}' > "$exp1"_and_"$exp2".bed

    cat $file1 | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > dataset1 & pid1=$!
    cat $file2 | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > dataset2 & pid2=$!
    wait $pid1
    wait $pid2

    bedtools subtract -a dataset1 -b "$exp1"_and_"$exp2".bed -A |cut -f-3|LC_ALL=C sort -u > "$exp1"_only.bed & pid1=$!
    bedtools subtract -a dataset2 -b "$exp1"_and_"$exp2".bed -A |cut -f-3|LC_ALL=C sort -u > "$exp2"_only.bed & pid2=$!
    wait $pid1
    wait $pid2

    if [ "$ref" = "hg19" ]; then
    	bedtools window -w 5000 -b "$exp1"_only.bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_only.bed & pid1=$!
    	bedtools window -w 5000 -b "$exp2"_only.bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp2"_only.bed & pid2=$!
    	bedtools window -w 5000 -b "$exp1"_and_"$exp2".bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_and_"$exp2".bed & pid3=$!
    	wait $pid1
    	wait $pid2
    	wait $pid3
    fi
    if [ "$ref" = "mm9" ]; then
    	bedtools window -w 5000 -b "$exp1"_only.bed -a ~/Work/pipelines/data/TSS_mm9.bed|cut -f4-6|LC_ALL=C sort -u > tss_"$exp1"_only.bed & pid1=$!
    	bedtools window -w 5000 -b "$exp2"_only.bed -a ~/Work/pipelines/data/TSS_mm9.bed|cut -f4-6|LC_ALL=C sort -u > tss_"$exp2"_only.bed & pid2=$!
    	bedtools window -w 5000 -b "$exp1"_and_"$exp2".bed -a ~/Work/pipelines/data/TSS_mm9.bed|cut -f4-6|LC_ALL=C sort -u > tss_"$exp1"_and_"$exp2".bed & pid3=$!
    	wait $pid1
    	wait $pid2
    	wait $pid3
    fi

    _1and2=$(cat "$exp1"_and_"$exp2".bed | wc -l)
    _1=$(cat "$exp1"_only.bed | wc -l)
    _2=$(cat "$exp2"_only.bed | wc -l)
    tss1and2=$(cat tss_"$exp1"_and_"$exp2".bed | wc -l)
    tss1=$(cat tss_"$exp1"_only.bed | wc -l)
    tss2=$(cat tss_"$exp2"_only.bed | wc -l)

    echo "$_1" "$_2" "$_1and2" "$tss1" "$tss2" "$tss1and2" 
    rm -f dataset{1,2} "$exp1"_and_"$exp2".bed "$exp1"_only.bed "$exp2"_only.bed tss_"$exp1"_and_"$exp2".bed tss_"$exp1"_only.bed tss_"$exp2"_only.bed 
done


