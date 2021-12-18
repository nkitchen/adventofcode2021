#!/bin/bash

shopt -s lastpipe

declare -a draws
declare -A cell
declare -A coords
declare -A marked
declare -A wonBoards
boards=0

main() {
   readGame

   for n in ${draws[@]}; do
      mark $n

      for brc in ${coords[$n]}; do
         echo ${brc//,/ } | read b r c
         if won $b $r $c && [[ -z "${wonBoards[$b]}" ]]; then
            # Just won now
            if [[ ${#wonBoards[*]} -eq $(( boards - 1 )) ]]; then
               # Last board
               score=$(( n * $( unmarkedSum $b ) ))
               echo $score
               exit
            fi
            wonBoards[$b]=1
         fi
      done
   done
}

readGame() {
   read drawLine
   draws=( ${drawLine//,/ } )

   b=0
   while true; do
      # blank line
      read || break
      for r in {0..4}; do
         read line
         row=( $line )
         for c in {0..4}; do
            brc="$b,$r,$c"
            n=${row[$c]}
            cell[$brc]=$n
            coords[$n]+=" $brc"
         done
      done

      unwonBoards[$b]=1
      let b++
   done
   boards=$b
}

mark() {
   n=$1

   for brc in ${coords[$n]}; do
      marked[$brc]=1
   done
}

won() {
   local b=$1 r=$2 c=$3

   k=0
   for rr in {0..4}; do
      let k+=${marked[$b,$rr,$c]:-0}
   done
   if [[ $k -eq 5 ]]; then
      return 0
   fi

   k=0
   for cc in {0..4}; do
      let k+=${marked[$b,$r,$cc]:-0}
   done
   if [[ $k -eq 5 ]]; then
      return 0
   fi

   return 1
}

unmarkedSum() {
   local b=$1

   local s=0
   for r in {0..4}; do
      for c in {0..4}; do
         brc=$b,$r,$c
         if [[ ${marked[$brc]} != 1 ]]; then
            let s+=${cell[$brc]}
         fi
      done
   done
   echo $s
}

main
