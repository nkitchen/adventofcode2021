#!/bin/bash

shopt -s lastpipe

count=()
reproDays=7
if [[ -z "$DAYS" ]]; then
   DAYS=80
fi

tr ',' ' ' |
   readarray -t timers
for t in ${timers[@]}; do
   count[$t]=$(( 1 + ${count[$t]:-0} ))
done

for day in $( seq 1 $DAYS ); do
   nextCount=()
   for t in ${!count[@]}; do
      n=${count[$t]}
      case $t in
         0)
            tPar=$(( reproDays - 1 ))
            nextCount[$tPar]=$(( $n + ${nextCount[$tPar]:-0} ))
            tChi=$(( reproDays + 1 ))
            nextCount[$tChi]=$n
            ;;
         *)
            tn=$(( t - 1 ))
            nextCount[$tn]=$(( $n + ${nextCount[$tn]:-0} ))
            ;;
      esac
   done

   count=()
   for t in ${!nextCount[@]}; do
      count[$t]=${nextCount[$t]}
   done

   #for t in $( seq 0 $(( reproDays + 1 )) ); do
   #   for i in $( seq ${count[$t]:-0} ); do
   #      echo -n $t
   #   done
   #done
   #echo
done

s=0
for n in ${count[@]}; do
   let s+=n
done
echo $s
