#!/usr/bin/env bash

if [ "$5" == "pe" ]; then
	r1=$1
	r2=$2
	refgen=$3
	dir=$4

	gunzip -c $r1 > $dir/r1.fq & pid1=$!
	gunzip -c $r2 > $dir/r2.fq & pid2=$!
	wait $pid1
	wait $pid2

	bwa mem -t 32 $refgen $dir/r1.fq $dir/r2.fq > $dir/experiment.sam
fi
if [ "$4" == "se" ]; then
	r1=$1
	refgen=$2
	dir=$3

	gunzip -c $r1 > $dir/r1.fq

	bwa mem -t 32 $refgen $dir/r1.fq > $dir/experiment.sam
fi

