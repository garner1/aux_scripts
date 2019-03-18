#!/usr/bin/env bash

# GIVEN 2 DATASET (treated and non-treated), FORMATTED AS A LIST OF UNIQUE FEATURES WITH FIRST 3 COLS AS: CHR START END
# IT PRODUCES 3 FILES CONTAINING THE LIST OF UNIQUE FEATURES TO DATASET 1, UNIQUE FEATURES TO DATASET 2, COMMON FEATURES
# FORMATTED AS: CHR START END COUNT
# THE COUNT IN THE COMMON FILE IS THE SUM OF THE COUNTS IN THE 2 DATASET

exp1=$1				# absolute path to the q10_chr-loc-strand-umi-pcr file #1
exp2=$2				# absolute path to the q10_chr-loc-strand-umi-pcr file #2
win=$3
gen=$4

~/Work/pipelines/aux.scripts/coverage.sh $win $exp1 $gen > file1
~/Work/pipelines/aux.scripts/coverage.sh $win $exp2 $gen > file2

bedtools intersect -a file1 -b file2 -wb > 1and2

cat 1and2 | awk '{OFS="\t"; if ($4>0 && $8>0) print $1,$2,$3,$4+$8}' > exp1_and_exp2.bed & pid1=$!
cat 1and2 | awk '{OFS="\t"; if ($4>0 && $8==0) print $1,$2,$3,$4+$8}' > exp1_only.bed & pid2=$!
cat 1and2 | awk '{OFS="\t"; if ($8>0 && $4==0) print $1,$2,$3,$4+$8}' > exp2_only.bed & pid3=$!
wait $pid1
wait $pid2
wait $pid3

mv file1 exp1_w"$win".bed
mv file2 exp2_w"$win".bed
rm 1and2
