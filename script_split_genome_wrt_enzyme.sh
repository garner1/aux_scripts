#!/usr/bin/env bash

ref=$1				# reference fasta file
cutsite=$2			# restriction enzyme cutsite

awk '/>/{x="F"++i;}{print > x;}' $ref #search for lines starting with > and split the file at that point into a new one

rm -f $cutsite.bed
touch $cutsite.bed

for ii in $(seq 1 25)
do
    file=F$ii
    chr=`head -1 $file | cut -d' ' -f1 | tr -d '>'`
    echo $chr
    cat $file | grep -v ">" | tr -d "\n" | grep -aob $cutsite | cut -d':' -f1 | awk -v chr="$chr" -v cutsite="$cutsite" '{print chr, $1, $1}' | tr " " "\t" >> $cutsite.bed
done

rm F*
