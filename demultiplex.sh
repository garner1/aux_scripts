#!/usr/bin/env bash

fastq=$1
patfile=$2
barcode=$3

cat $fastq | paste - - - -| cut -f-2 | sed 's/^@/>/' | tr '\t' '\n' |
    parallel --tmpdir $HOME/tmp --block 100M -k --pipe -L 2 "scan_for_matches $patfile - " | paste - - | sed 's/^>/@/' | cut -d':' -f-7 | LC_ALL=C sort > "$fastq"."$barcode"
