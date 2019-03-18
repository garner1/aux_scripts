#!/usr/bin/env bash

file1=$1			# first vcf file
file2=$2			# second vcf file
var=$3				# DEL or DUP

temp_file_1=$(mktemp)
temp_file_2=$(mktemp)

bash ~/Work/pipelines/aux.scripts/my_vcf2bed.sh $file1 | grep $var > ${temp_file_1}
bash ~/Work/pipelines/aux.scripts/my_vcf2bed.sh $file2 | grep $var > ${temp_file_2}

echo $file1 $file2
bedtools jaccard -a ${temp_file_1} -b ${temp_file_2}

rm ${temp_file_1} ${temp_file_2}
