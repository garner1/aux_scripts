#!/usr/bin/env bash
# Evaluates the Shannon entropy of cnv profiles in tsv format (the signal is in the 5th field)

tsv=$1				# input tsv file
min=`tail -n+2 ${tsv} | datamash min 5`
tfile=$(mktemp /tmp/foo.XXXXXXXXX)
tail -n+2 ${tsv} | awk -v min=${min} '{print $5-min}' > ${tfile}
python shannon.py ${tfile}
