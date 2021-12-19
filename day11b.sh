#!/bin/bash

shopt -s lastpipe

source lib.sh

declare -A map
m=0
n=0

main() {
	if [[ -n "$1" ]]; then
		STEPS=$1
	else
		STEPS=2000
	fi

    readMap
    ddisplay
    for t in $( seq $STEPS ); do
        bump
		flash
		local f=$( echo ${map[@]} | xargs -n 1 | grep -c 0 )
		if [[ $f == $(( m * n )) ]]; then
			echo $t
			break
		fi
        ddisplay
    done
}

readMap() {
    local i=0
    while read line; do
        levels=( $( echo $line | grep -o . ) )
        local j
        for j in ${!levels[@]}; do
            map[$i,$j]=${levels[$j]}
        done
        let i++
        n=${#levels[@]}
    done
    let m=i
}

bump() {
    local i j
    for i in $( seq 0 $(( $m - 1 )) ); do
        for j in $( seq 0 $(( $n - 1 )) ); do
            map[$i,$j]=$(( 1 + ${map[$i,$j]} ))
        done
    done
}

flash() {
	local flashes=0
	local flashers=()
	local i j
    for i in $( seq 0 $(( $m - 1 )) ); do
        for j in $( seq 0 $(( $n - 1 )) ); do
			if [[ ${map[$i,$j]} -gt 9 ]]; then
				flashers+=( "$i $j" )
			fi
		done
	done

	while [[ ${#flashers[@]} -gt 0 ]]; do
		let flashes+=${#flashers[@]}
		local nextFlashers=()
		for ij in "${flashers[@]}"; do
			local ii jj
			echo $ij | read i j
			neighbors $i $j |
				while read ii jj; do
					map[$ii,$jj]=$(( 1 + ${map[$ii,$jj]} ))
					if [[ ${map[$ii,$jj]} == 10 ]]; then
						nextFlashers+=( "$ii $jj" )
					fi
				done
		done
		flashers=( "${nextFlashers[@]}" )
	done

    for i in $( seq 0 $(( $m - 1 )) ); do
        for j in $( seq 0 $(( $n - 1 )) ); do
			if [[ ${map[$i,$j]} -gt 9 ]]; then
				map[$i,$j]=0
			fi
		done
	done
}

neighbors() {
    local i=$1 j=$2
    for ii in $( seq $(( i > 0     ? i - 1 : i )) \
                     $(( i < m - 1 ? i + 1 : i )) ); do
         for jj in $( seq $(( j > 0     ? j - 1 : j )) \
                          $(( j < m - 1 ? j + 1 : j )) ); do
            echo $ii $jj
		 done
	 done
}

declare -A code=( [10]=A [11]=B [12]=C [13]=D \
                  [14]=E [15]=F [16]=G [17]=H )
ddisplay() {
    for i in $( seq 0 $(( $m - 1 )) ); do
        for j in $( seq 0 $(( $n - 1 )) ); do
            level=${map[$i,$j]}
			dprint -n "$(printf %2d $level) "
        done
        dprint
    done
    dprint
}

main "$@"

# 2m26s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
