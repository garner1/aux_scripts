#!/usr/bin/env bash

# GIVEN 2 DATASETS, FILTERS EACH OF THEM WRT UMI VALUES, AND THEN IT SEPARATES EXCLUSIVES VS COMMON LOCATIONS

exp1=$1				# rm53T
exp2=$2				# rm53NT
exp3=$3
file1=$4			# full path to rm53T
file2=$5			# full path to rm53NT
file3=$6
max=$7				# max allowed UMI
min=$8				# length of the loop

for min in $(seq 1 "$min");
do
    bedtools intersect -a $file1 -b $file2 -wb | awk '{OFS="\t";print $1,$2,$3,$4+$8}' | 
    awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=2*max) print}' > "$exp1"_and_"$exp2".bed
    bedtools intersect -a $file2 -b $file3 -wb | awk '{OFS="\t";print $1,$2,$3,$4+$8}' | 
    awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=2*max) print}' > "$exp2"_and_"$exp3".bed
    bedtools intersect -a $file1 -b $file3 -wb | awk '{OFS="\t";print $1,$2,$3,$4+$8}' | 
    awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=2*max) print}' > "$exp1"_and_"$exp3".bed
    bedtools intersect -a $file2 -b "$exp1"_and_"$exp3".bed -wb | awk '{OFS="\t";print $1,$2,$3,$4+$8}' | 
    awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=3*max) print}' > "$exp1"_and_"$exp2"_and_"$exp3".bed

    cat $file1 | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > dataset1 & pid1=$!
    cat $file2 | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > dataset2 & pid2=$!
    cat $file3 | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' > dataset3 & pid3=$!
    wait $pid1
    wait $pid2
    wait $pid3

    bedtools subtract -a dataset1 -b "$exp1"_and_"$exp2".bed -A |cut -f-3|LC_ALL=C sort -u > aux1
    bedtools subtract -a aux1 -b "$exp1"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > aux2
    bedtools subtract -a aux2 -b "$exp1"_and_"$exp2"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > "$exp1"_only.bed

    bedtools subtract -a dataset2 -b "$exp1"_and_"$exp2".bed -A |cut -f-3|LC_ALL=C sort -u > aux1
    bedtools subtract -a aux1 -b "$exp2"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > aux2
    bedtools subtract -a aux2 -b "$exp1"_and_"$exp2"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > "$exp2"_only.bed

    bedtools subtract -a dataset3 -b "$exp1"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > aux1
    bedtools subtract -a aux1 -b "$exp2"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > aux2
    bedtools subtract -a aux2 -b "$exp1"_and_"$exp2"_and_"$exp3".bed -A |cut -f-3|LC_ALL=C sort -u > "$exp3"_only.bed
    rm -f aux{1,2}

    # bedtools window -w 5000 -b "$exp1"_only.bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_only.bed & pid1=$!
    # bedtools window -w 5000 -b "$exp2"_only.bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp2"_only.bed & pid2=$!
    # bedtools window -w 5000 -b "$exp3"_only.bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp2"_only.bed & pid3=$!
    # bedtools window -w 5000 -b "$exp1"_and_"$exp2".bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_and_"$exp2".bed & pid4=$!
    # bedtools window -w 5000 -b "$exp1"_and_"$exp3".bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_and_"$exp3".bed & pid5=$!
    # bedtools window -w 5000 -b "$exp2"_and_"$exp3".bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp2"_and_"$exp3".bed & pid6=$!
    # bedtools window -w 5000 -b "$exp1"_and_"$exp2"_and_"$exp3".bed -a ~/Work/pipelines/data/TSS_uniq_chr-loc-gene.bed|cut -f5-7|LC_ALL=C sort -u > tss_"$exp1"_and_"$exp2"_and_"$exp3".bed & pid7=$!
    # wait $pid1
    # wait $pid2
    # wait $pid3
    # wait $pid4
    # wait $pid5
    # wait $pid6
    # wait $pid7
    
    _1and2=$(cat "$exp1"_and_"$exp2".bed | wc -l)
    _1and3=$(cat "$exp1"_and_"$exp3".bed | wc -l)
    _2and3=$(cat "$exp2"_and_"$exp3".bed | wc -l)
    _1and2and3=$(cat "$exp1"_and_"$exp2"_and_"$exp3".bed | wc -l)
    _1=$(cat "$exp1"_only.bed | wc -l)
    _2=$(cat "$exp2"_only.bed | wc -l)
    _3=$(cat "$exp3"_only.bed | wc -l)
    # tss1and2=$(cat tss_"$exp1"_and_"$exp2".bed | wc -l)
    # tss1and3=$(cat tss_"$exp1"_and_"$exp3".bed | wc -l)
    # tss2and3=$(cat tss_"$exp2"_and_"$exp2".bed | wc -l)
    # tss1and2and3=$(cat tss_"$exp1"_and_"$exp2"_and_"$exp3".bed | wc -l)
    # tss1=$(cat tss_"$exp1"_only.bed | wc -l)
    # tss2=$(cat tss_"$exp2"_only.bed | wc -l)
    # tss3=$(cat tss_"$exp3"_only.bed | wc -l)

    echo "$_1" "$_2" "$_3" "$_1and2" "$_1and3" "$_2and3" "$_1and2and3" "$tss1" "$tss2" "$tss3" "$tss1and2" "$tss1and3" "$tss2and3" "$tss1and2and3" 
    rm -f dataset{1,2,3} *_and_*.bed *_only.bed *_only.bed tss_*_and_*.bed tss_*_only.bed tss_*_only.bed 
done
