#!/usr/bin/env bash

# In RunInfo.xml change:
# <Read Number="1" NumCycles="75" IsIndexedRead="N" />
# <Read Number="2" NumCycles="8" IsIndexedRead="Y" />
# <Read Number="3" NumCycles="10" IsIndexedRead="Y" />
# <Read Number="4" NumCycles="85" IsIndexedRead="N" />
# into:
# <Read Number="1" NumCycles="75" IsIndexedRead="N" />
# <Read Number="2" NumCycles="8" IsIndexedRead="Y" />
# <Read Number="4" NumCycles="85" IsIndexedRead="N" />

# SampleSheet.csv:
# [Header],,,,,,,,,
# IEMFileVersion,4,,,,,,,,
# Investigator Name,MN,,,,,,,,
# Experiment Name,bicro129,,,,,,,,
# Date,16/10/18,,,,,,,,
# Workflow,GenerateFASTQ,,,,,,,,
# Application,FASTQ Only,,,,,,,,
# Assay,SureSelect_XT_XS_+_all_exome_V6,,,,,,,,
# Description,exome sequencing,,,,,,,,
# Chemistry,Amplicon,,,,,,,,
# ,,,,,,,,,
# [Reads],,,,,,,,,
# 75,,,,,,,,,
# 75,,,,,,,,,
# ,,,,,,,,,
# [Settings],,,,,,,,,
# Read1StartFromCycle,1,,,,,,,,
# Read1EndWithCycle,75,,,,,,,,
# Read2StartFromCycle,1,,,,,,,,
# Read2EndWithCycle,85,,,,,,,,
# Read2UMIStartFromCycle,1,,,,,,,,
# Read2UMILength,10,,,,,,,,
# TrimUMI,1,,,,,,,,
# ,,,,,,,,,
# [Data],,,,,,,,,
# Sample_ID,Sample_Name,Sample_Plate,Sample_Well,I7_Index_ID,index,I5_Index_ID,index2,Sample_Project,Description
# mn14,mn14,,,,TGAAGAGA,,,,
# mn15,mn15,,,,TTCACGCA,,,,
# mn16,mn16,,,,AACGTGAT,,,,
# mn17,mn17,,,,ACCACTGT,,,,
# mn18,mn18,,,,ACCTCCAA,,,,


## install bcl2fastq with: conda install -c dranew bcl2fastq
## install fastp with conda

datadir=$1			# the directory where data is located
refgen=~/Work/genomes/hg19/hg19.fa # full path to reference genome fasta file
numbproc=4

cd ${datadir}

# mkdir -p fastq_files

# bcl2fastq -i Data/BaseCalls -R . -o fastq_files --no-lane-splitting # producess fastq.gz files with umis in tag

cd fastq_files
# mkdir -p undetermined && mv Undetermined* undetermined

# parallel --link "fastp -i {1} -I {2} -o {1}.out.fq.gz -O {2}.out.fq.gz -h {1}.html" ::: *R1*.fastq.gz ::: *R2*.fastq.gz

# echo "Aligning ..."
# parallel --link "bwa mem -v 1 -t ${numbproc} ${refgen} {1} {2} | samtools view -h -Sb > {1}.bam" ::: *R1*.out.fq.gz ::: *R2*.out.fq.gz
# parallel "samtools sort {} -o {}.sorted.bam" ::: *.bam
# parallel "samtools index {}" ::: *.sorted.bam 
# echo "Done!"

# echo Deduplicating ...
# parallel "umi_tools dedup --umi-separator=: -I {} --paired -S {}.dedup.bam --edit-distance-threshold 2 -L {}.group.log" ::: *.sorted.bam
# parallel "samtools index {}" ::: *.sorted.bam.dedup.bam 

parallel --link "mosdepth -n -t 4 --by ~/Work/pipelines/data/agilent/S07604715_Covered.bed {1} {2}" ::: $(seq 14 18) ::: *.fastq.gz.out.fq.gz.bam.sorted.bam.dedup.bam

# For reads without UMI
# parallel "samtools view -h {} | samblaster -r |
#     samtools view -Sb - | bedtools coverage -hist -abam - -b ~/Work/pipelines/data/agilent/S07604715_Covered.bed > {}.exome.coverage.hist.txt" ::: *.fastq.gz.out.fq.gz.bam

# samtools view -h MN14*.fastq.gz.out.fq.gz.bam | samblaster -r | samtools view -Sb - | bedtools coverage -hist -b - -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > MN14ex.target.coverage.hist.txt
# samtools view -h MN15*.fastq.gz.out.fq.gz.bam | samblaster -r | samtools view -Sb - | bedtools coverage -hist -b - -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > MN15ex.target.coverage.hist.txt
# samtools view -h MN16*.fastq.gz.out.fq.gz.bam | samblaster -r | samtools view -Sb - | bedtools coverage -hist -b - -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > MN16ex.target.coverage.hist.txt
# samtools view -h MN17*.fastq.gz.out.fq.gz.bam | samblaster -r | samtools view -Sb - | bedtools coverage -hist -b - -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > MN17ex.target.coverage.hist.txt
# samtools view -h MN18*.fastq.gz.out.fq.gz.bam | samblaster -r | samtools view -Sb - | bedtools coverage -hist -b - -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > MN18ex.target.coverage.hist.txt

# parallel "bedtools coverage -hist -abam {} -b ~/Work/pipelines/data/agilent/S07604715_Covered.bed > {}.exome.coverage.hist.txt" ::: *.fastq.gz.out.fq.gz.bam.sorted.bam

# bedtools coverage -hist -b mn14*.fastq.gz.out.fq.gz.bam.sorted.bam -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > mn14ex.fastq.gz.out.fq.gz.bam.sorted.bam.coverage.hist.txt
# bedtools coverage -hist -b mn15*.fastq.gz.out.fq.gz.bam.sorted.bam -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > mn15ex.fastq.gz.out.fq.gz.bam.sorted.bam.coverage.hist.txt
# bedtools coverage -hist -b mn16*.fastq.gz.out.fq.gz.bam.sorted.bam -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > mn16ex.fastq.gz.out.fq.gz.bam.sorted.bam.coverage.hist.txt
# bedtools coverage -hist -b mn17*.fastq.gz.out.fq.gz.bam.sorted.bam -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > mn17ex.fastq.gz.out.fq.gz.bam.sorted.bam.coverage.hist.txt
# bedtools coverage -hist -b mn18*.fastq.gz.out.fq.gz.bam.sorted.bam -a ~/Work/pipelines/data/agilent/S07604715_Covered.bed > mn18ex.fastq.gz.out.fq.gz.bam.sorted.bam.coverage.hist.txt

######################
# featureCounts -p -a ~/Work/genomes/Homo_sapiens.GRCh37.75.gtf.gz -o gene_assigned -R BAM mn14_S1_R1_001.fastq.gz.out.fq.gz.bam.sorted.bam -T 24

# bedtools genomecov -ibam input.bam -bga > output_aln.bam

# bedtools coverage -hist -abam mn14_S1_R1_001.fastq.gz.out.fq.gz.bam.sorted.bam.dedup.bam -b targets.numeric.chroms.bed > mn14.exome.coverage.hist.txt

