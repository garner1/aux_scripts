#!/usr/bin/env bash

## install bcl2fastq with: conda install -c dranew bcl2fastq
## install fastp with conda

datadir=$1			# the directory where data is located

cd ${datadir}

mkdir -p fastq_files

# bcl2fastq -i Data/BaseCalls -R . -o fastq_files --no-lane-splitting --mask-short-adapter-reads 0 --use-bases-mask Y75,I8,Y10,Y75 #from agilent instructions
# bcl2fastq -i Data/BaseCalls -R . -o fastq_files --no-lane-splitting # NEED TO PROVIDE THE PROPER LOCATION OF BCL FILES (BASECALLS DIR)
bcl2fastq -i Data/Intensities/BaseCalls -R . -o fastq_files --no-lane-splitting --tiles s_[3] #only lane 3

# R1-2-3 are produced with UMI in R2
# cd fastq_files
# parallel --link "fastp -i {1} -I {2} -o {1}.out.fq --umi --umi_loc=read2 --umi_len=10 -Q -A -L -w 1" ::: *R1*fastq.gz ::: *R2*fastq.gz
# parallel --link "fastp -i {1} -I {2} -o {1}.out.fq --umi --umi_loc=read2 --umi_len=10 -Q -A -L -w 1" ::: *R3*fastq.gz ::: *R2*fastq.gz

