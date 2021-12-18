#!/bin/bash

#set -x
shopt -s lastpipe

declare -A vents

main() {
    # x1,y1 -> x2,y2  ==>  x1 y1 x2 y2
    tr ',' ' ' |
        tr -d '>-' |
        while read x1 y1 x2 y2; do
            if [[ "${DIAG:-0}" == 0 ]] &&
                [[ $x1 != $x2 ]] && [[ $y1 != $y2 ]]; then
                continue
            fi

            linePts $x1 $y1 $x2 $y2 |
                while read xx yy; do
                    pp=$xx,$yy
                    vents[$pp]=$(( 1 + ${vents[$pp]:-0} ))
                done

            #display
        done

    n=0
    for k in ${vents[@]}; do
        if [[ $k -ge 2 ]]; then
            let n++
        fi
    done
    echo $n
}

linePts() {
    x1=$1
    y1=$2
    x2=$3
    y2=$4

    if [[ $x1 -lt $x2 ]]; then
        dx=1
    elif [[ $x1 -gt $x2 ]]; then
        dx=-1
    else
        dx=0
    fi
    if [[ $y1 -lt $y2 ]]; then
        dy=1
    elif [[ $y1 -gt $y2 ]]; then
        dy=-1
    else
        dy=0
    fi

    xx=$x1
    yy=$y1
    while true; do
        echo $xx $yy
        if [[ $xx == $x2 ]] && [[ $yy == $y2 ]]; then
            return
        fi
        xx=$(( xx + dx ))
        yy=$(( yy + dy ))
    done
}

display() {
   for y in {0..9}; do
      for x in {0..9}; do
         echo -n ${vents[$x,$y]:-.}
      done
      echo
   done
}

main

# vim: set shiftwidth=4 tabstop=4 :
