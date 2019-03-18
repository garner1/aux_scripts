#!/usr/bin/env bash

# GIVEN 2 DATASET (treated and non-treated), FORMATTED AS A LIST OF UNIQUE FEATURES WITH FIRST 3 COLS AS: CHR START END
# IT PRODUCES 3 FILES CONTAINING THE SCALING OF COUNTS WRT UMI

exp1=$1 			# absolute path to the q10_chr-loc-strand-umi file #1
exp2=$2				# absolute path to the q10_chr-loc-strand-umi file #2
win=$3
gen=$4
max=$5				# max allowed UMI number (for outliers)
min=$6				# number of element in the list of threshold UMIs 

~/Work/pipelines/aux.scripts/binned_coverage.sh $exp1 $exp2 $win $gen

~/Work/pipelines/aux.scripts/umi_scaling_single.sh exp1_and_exp2.bed $gen $max $min > exp1_and_exp2.dat & pid1=$!
~/Work/pipelines/aux.scripts/umi_scaling_single.sh exp1_only.bed $gen $max $min > exp1_only.dat & pid2=$!
~/Work/pipelines/aux.scripts/umi_scaling_single.sh exp2_only.bed $gen $max $min > exp2_only.dat & pid3=$!
~/Work/pipelines/aux.scripts/umi_scaling_single.sh exp1_w"$win".bed $gen $max $min > exp1_w"$win".dat & pid4=$!
~/Work/pipelines/aux.scripts/umi_scaling_single.sh exp2_w"$win".bed $gen $max $min > exp2_w"$win".dat & pid5=$!
