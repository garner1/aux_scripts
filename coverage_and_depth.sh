#!/usr/bin/env bash

tsvfile=$1

coverage=`cat $tsvfile | grep "^1\|^2\|^3\|^4\|^5\|^6\|^7\|^8\|^9\|^10\|^11\|^12\|^13\|^14\|^15\|^16\|^17\|^18\|^19\|^20\|^21\|^22" | awk '{if ($4>0) print $3-$2}' |datamash sum 1`
size=`cat $tsvfile | grep "^1\|^2\|^3\|^4\|^5\|^6\|^7\|^8\|^9\|^10\|^11\|^12\|^13\|^14\|^15\|^16\|^17\|^18\|^19\|^20\|^21\|^22" | awk '{print $3-$2}' |datamash sum 1`
depth=`cat $tsvfile | grep "^1\|^2\|^3\|^4\|^5\|^6\|^7\|^8\|^9\|^10\|^11\|^12\|^13\|^14\|^15\|^16\|^17\|^18\|^19\|^20\|^21\|^22" | awk '{if ($4>0) print $4*($3-$2)}' |datamash sum 1`

echo "The absolute coverage is" $coverage
echo "The total relevant genomic size is" $size
echo "The number of bases sequenced is" $depth
echo "The number of times a sequenced base is covered by a read is" `echo $depth $coverage | awk '{print $1/$2}'`
echo "The percentage of the relevant genome which is sequenced is" `echo $coverage $size | awk '{print $1/$2*100}'`
