#!/bin/bash

shopt -s lastpipe

source lib.sh

main() {
	map=()
	readarray -t map

	m=${#map[@]}
	n=${#map[0]}

	risk=0
	for i in $( seq 0 $(( m - 1 )) ); do
		for j in $( seq 0 $(( n - 1 )) ); do
			dprint check: $i $j
			if isLow $i $j; then
				dprint low: $i $j
				let risk+=$(( 1 + $( at $i $j ) ))
			fi
		done
	done
	echo $risk
}

at() {
	echo ${map[$1]:$2:1}
}

isLow() {
	i=$1
	j=$2
	h=$( at $i $j )
	adj $i $j |
		while read ii jj; do
			if [[ $( at $ii $jj ) -le $h ]]; then
				return 1
			fi
		done

	a=$(( i == 0 ? 0 : i - 1 ))
	b=$(( i < n - 1 ? i + 1 : i ))
	c=$(( j == 0 ? 0 : j - 1 ))
	d=$(( j < n - 1 ? j + 1 : j ))
	for ii in $( seq $a $b ); do
		for jj in $( seq $c $d ); do
			if [[ $ii == $i ]] && [[ $jj == $j ]]; then
				continue
			fi
		done
	done
	return 0
}

adj() {
	i=$1
	j=$2
	if [[ 0 -lt $i ]]; then
		echo $(( i - 1 )) $j
	fi
	if [[ 0 -lt $j ]]; then
		echo $i $(( j - 1 ))
	fi
	if [[ $(( j + 1 )) -lt $n ]]; then
		echo $i $(( j + 1 ))
	fi
	if [[ $(( i + 1 )) -lt $m ]]; then
		echo $(( $i + 1 )) $j
	fi
}

main

# 1m41s (ChromeBook)
# 17s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
