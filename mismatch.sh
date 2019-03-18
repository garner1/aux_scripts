#!/usr/bin/env bash

str1len=$((${#1}))
str2len=$((${#2}))
for i in $(seq 0 $(((str1len+1)*(str2len+1)))); do
    d[i]=0
done
for i in $(seq 0 $((str1len)));do
    d[$((i+0*str1len))]=$i
done
for j in $(seq 0 $((str2len)));do
    d[$((0+j*(str1len+1)))]=$j
done

for j in $(seq 1 $((str2len))); do
    for i in $(seq 1 $((str1len))); do
	[ "${1:i-1:1}" = "${2:j-1:1}" ] && cost=0 || cost=1
	alt=$((d[(i-1)+str1len*(j-1)]+cost))
	d[i+str1len*j]=$(echo -e "$alt")
    done
done
echo ${d[str1len+str1len*(str2len)]}


