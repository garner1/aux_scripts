#!/usr/bin/env bash

# GIVEN A DATASET, FORMATTED AS: CHR START END UMI-COUNT
# IT PROVIDES THE NUMBER OF DSB WITH AT LEAST A GIVEN VALUE OF UMI, TOGETHER WITH THE NUMBER OF DSB IN THE VICINITY OF TSS

file=$1				# absolute path to the file with UMI counts on the 4th col
max=$2				# max allowed UMI
min=$3				# length of the loop
for min in $(seq 1 "$min");
do
    y=$(cat "$file" | awk -v min="$min" -v max="$max" '{if ($4>=min && $4<=max) print}' | wc -l)
    echo "$min" "$y"
done
