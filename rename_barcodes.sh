#!/usr/bin/env bash


filename=$1
replacement=$2			# 2 col file with barcodes and names fields

barcode=`echo $filename | cut -d'.' -f2`
name=`cat $replacement | grep $barcode | cut -f2`
exp=`echo $filename | cut -d'.' -f1`
suffix=`echo $filename | cut -d'.' -f3`
newname=${exp}.${name}.${suffix}
cp $filename $newname

