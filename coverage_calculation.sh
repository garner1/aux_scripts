#!/usr/bin/env bash

bamfile=$1

bedtools genomecov -ibam $bamfile -bga > $bamfile.coverage.tsv
