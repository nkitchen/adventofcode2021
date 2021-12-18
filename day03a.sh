#!/bin/bash

bitsum=()
n=0

while read bits; do
   let n++
   k=${#bits}
   max=$(( k - 1 ))
   for i in $( seq 0 $(( k - 1 )) ); do
      b=${bits:$i:1}
      bitsum[$i]=$(( $b + ${bitsum[$i]:-0} ))
   done
done

gammaBits=()
for i in $( seq 0 $(( k - 1 )) ); do
   m=${bitsum[$i]} 
   if [[ $m -gt $(( n - m )) ]]; then
      gammaBits[$i]=1
   else
      gammaBits[$i]=0
   fi
done
gammaBin=$( echo "${gammaBits[*]}" | tr -d ' ' )
epsilonBin=$( echo $gammaBin | tr 01 10 )
power=$(( 2#$gammaBin * 2#$epsilonBin ))
echo $power
