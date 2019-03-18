#!/usr/bin/env bash

left=$1				# 0 || 1
right=$2			# 0 || 1
step=$3				# step in spanning tss neightbourood
quality=$4			# quality of the mapped read
tss=$5				# absolute path to list of transcription start sites: a 4 field file with TSS and geneID
read=$6				# abosolute path to list of read for a given dataset
cutsite=$7			# absolute path to cutsite locations
out=$8				# name of output file

if [ $left == 0 ];then
    right=$step
    cat $read|awk -v q="$quality" '$6>=q'|bedtools window -a $tss -b - -r $right -l $left > alloverlap # find the reads near tss
    cut -f 5,6,7,9,11 alloverlap > overlap
    bedtools window -a $tss -b $cutsite -r $right -l $left > allcutsite # find cutsites near tss
    cut -f 5,6,7 allcutsite > cutsite
    cat $read|awk -v q="$quality" '$6>=q'|bedtools subtract -a - -b overlap -A > newread
    bedtools subtract -a $cutsite -b cutsite -A > newcutsite

    rm -f $out
    while [[ ($(cat newread|wc -l) -gt 0) &&  ($right -lt 5000)  ]]
    do
    	echo $right
	cat alloverlap|datamash -s -g4 count 5,6,7,9,11 > file1
	cat allcutsite|datamash -s -g4 count 5,6,7 > file2
    	echo $(join file1 file2 | awk '{print $2/$3}'|sta --mean|tail -1) >> $out # count the total number of fragments and the total number of cutsites in the neighborhood
    	((right = right + $step))
    	bedtools window -a $tss -b newread -r $right -l $left > alloverlap
	cut -f 5,6,7,9,11 alloverlap > overlap
    	bedtools window -a $tss -b newcutsite -r $right -l $left > allcutsite
	cut -f 5,6,7 allcutsite > cutsite
    	bedtools subtract -a newread -b overlap -A > aux && mv aux newread
    	bedtools subtract -a newcutsite -b cutsite -A > aux2 && mv aux2 newcutsite
    done
    rm -f $out file{1,2} alloverlap newread newcutsite allcutsite cutsite overlap
    nl -i $step -v 1 $out > ~/$out
fi
if [ $right == 0 ];then
    left=$step
    cat $read|awk -v q="$quality" '$6>=q'|bedtools window -a $tss -b - -r $right -l $left  > alloverlap # find the reads near tss
    cut -f 5,6,7,9,11 alloverlap > overlap
    bedtools window -a $tss -b $cutsite -r $right -l $left > allcutsite # find cutsites near tss
    cut -f 5,6,7 allcutsite > cutsite
    cat $read|awk -v q="$quality" '$6>=q'|bedtools subtract -a - -b overlap -A > newread
    bedtools subtract -a $cutsite -b cutsite -A > newcutsite
   
    rm -f $out
    while [[ ($(cat newread|wc -l) -gt 0) && ($left -lt 5000)  ]]
    do
    	echo $left
	cat alloverlap|datamash -s -g4 count 5,6,7,9,11 > file1
	cat allcutsite|datamash -s -g4 count 5,6,7 > file2
    	echo $(join file1 file2 | awk '{print $2/$3}'|sta --mean|tail -1) >> $out # count the total number of fragments and the total number of cutsites in the neighborhood
    	((left = left + $step))
    	bedtools window -a $tss -b newread -r $right -l $left > alloverlap
	cut -f 5,6,7,9,11 alloverlap > overlap
    	bedtools window -a $tss -b newcutsite -r $right -l $left > allcutsite
	cut -f 5,6,7 allcutsite > cutsite
    	bedtools subtract -a newread -b overlap -A > aux && mv aux newread
    	bedtools subtract -a newcutsite -b cutsite -A > aux2 && mv aux2 newcutsite
    done
    nl -i $step -v 1 $out |awk '{print -$1,$2}' > ~/$out
    rm -f $out file{1,2} alloverlap newread newcutsite allcutsite cutsite overlap
fi
