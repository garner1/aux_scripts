#!/usr/bin/env bash

vcffile=$1

vcf2bed < $vcffile | tr ';' '\t' | cut -f-2,9,10 | sed 's/END=//' | awk '{OFS="\t";print $1,$2,$4,$3}'
