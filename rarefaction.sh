#!/usr/bin/env bash

file=$1

# size has to be at most (wc -l file) * ave_pcr
x1=$(cat $file|LC_ALL=C grep -v "_"|wc -l)
x2=$(cat $file|LC_ALL=C grep -v "_"|datamash mean 6|numround)
let size=x1*x2

function rarefact {
    cat $1 | LC_ALL=C grep -v "_" | awk '{for (i=0; i< $6; i++) print}' | cut -f-5 | shuf -n $2 |
    LC_ALL=C sort -k1,1 -k2,2n -k4,4 -k5,5 -u | wc -l
}

let min=size/32

min=100000
size=5000000
export -f rarefact
parallel -k "echo {} && rarefact $file {}" ::: $(seq $min $min $size) | paste - -
