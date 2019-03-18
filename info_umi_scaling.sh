#!/usr/bin/env bash

# GIVEN 2 DATASET (treated and non-treated), FORMATTED AS A LIST OF UNIQUE FEATURES WITH FIRST 3 COLS AS: CHR START END
# IT PRODUCES 3 FILES CONTAINING THE LIST OF UNIQUE FEATURES TO DATASET 1, UNIQUE FEATURES TO DATASET 2, COMMON FEATURES
# FORMATTED AS: CHR START END COUNT
# THE COUNT IN THE COMMON FILE IS THE SUM OF THE COUNTS IN THE 2 DATASET

exp=$1
win=$2				
gen=$3				# mm9 hg19
tag=$4				# entropy or purity
umax=$5

cd ~/Work/dataset/"$exp" 
~/Work/pipelines/aux.scripts/coverage.sh $win ~/Work/dataset/"$exp"/outdata/q10_chr-loc-strand-umi-pcr $gen > ~/Work/dataset/"$exp"/bin
cd ~/Work/dataset

for val in $(seq 0 $umax); do
    norma=$(cat ~/Work/dataset/"$exp"/bin | awk -v val="$val" '{OFS="\t"; if ($4>val) print $4}' | numsum)
    dim=$(cat ~/Work/dataset/"$exp"/bin | awk -v val="$val" '{OFS="\t"; if ($4>val) print $4}' | wc -l)
    if [ "$tag" = "entropy" ];then
	shannon=$(cat ~/Work/dataset/"$exp"/bin | awk -v val="$val" -v norma="$norma" -v dim="$dim" '{OFS="\t"} {if ($4>val) e+=(-$4/norma)*log($4/norma)} END {print e}')
	echo $shannon
    fi
    if [ "$tag" = "purity" ];then
	purity=$(cat ~/Work/dataset/"$exp"/bin | awk -v val="$val" -v norma="$norma" '{OFS="\t"} {if ($4>val) e+=($4/norma)**2} END {print e}')
	echo $purity
    fi
done

mv ~/Work/dataset/"$exp"/bin ~/Work/dataset/"$exp"_w"$win".bed
