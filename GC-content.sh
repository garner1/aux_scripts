#!/usr/bin/env bash

bamfile=$1

samtools sort "$bamfile" "$bamfile"-sorted
bedtools bamtobed -i "$bamfile"-sorted.bam -ed > "$bamfile"-sorted.bed
bedtools nuc -seq -fi ~/igv/genomes/hg19.fasta -bed "$bamfile"-sorted.bed > "$bamfile"-sorted-GC.bed
rm "$bamfile"-sorted.bam "$bamfile"-sorted.bed
