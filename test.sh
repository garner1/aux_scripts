#!/usr/bin/env bash

# head -10 ~/Work/dataset/restseq/xz23/indata/r1oneline.fq > aux
# AS IT IS IS TOO SLOW; PARALLELIZE THE INPUT FILE AS WELL
count=0
while read -r line
do
    count=$(($count + 1))
    echo $count
    echo $line > aux2
    # agrep -1 CGTGTGAGAAGCTT aux2 >> output
    parallel "LC_ALL=C agrep -1 {} aux2 >> {}.fq-1line" ::: `cat ~/Work/pipelines/restseq/pattern/barcode-cutsite`
done < ~/Work/dataset/restseq/xz23/indata/r1oneline.fq

 
