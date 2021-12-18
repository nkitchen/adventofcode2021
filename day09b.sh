#!/bin/bash

shopt -s lastpipe

source lib.sh

declare -A drainMap

main() {
	map=()
	readarray -t map

	m=${#map[@]}
	n=${#map[0]}

	# Merge adjacent basins.
	local i j
	for i in $( seq 0 $(( m - 1 )) ); do
		for j in $( seq 0 $(( n - 1 )) ); do
			local hij=$( at $i $j )
			if [[ $hij == 9 ]]; then
				continue
			fi
			local dij=$( drain $i $j )

			local u v
			adjAfter $i $j |
				while read u v; do
					local duv=$( drain $u $v )
					if [[ $dij == $duv ]]; then
						continue
					fi
					merge $i $j $u $v
				done
		done
	done

	declare -A basinSize
	for i in $( seq 0 $(( m - 1 )) ); do
		for j in $( seq 0 $(( n - 1 )) ); do
			if [[ $( at $i $j ) == 9 ]]; then
				dprint -n "... "
				continue
			fi
			d=$( drain $i $j )
			dprint -n "$d "
			basinSize[$d]=$(( 1 + ${basinSize[$d]:-0} ))
		done
		dprint
	done

	dprint ${basinSize[@]}
	echo ${basinSize[@]} |
		xargs -n 1 |
		sort -n |
		tail -n 3 |
		awk 'BEGIN { p=1 }
	         { p *= $1 }
			 END { print p }'
}

at() {
	echo ${map[$1]:$2:1}
}

adjAfter() {
	local i=$1
	local j=$2
	local u v
	(
		if [[ $(( j + 1 )) -lt $n ]]; then
			echo $i $(( j + 1 ))
		fi
		if [[ $(( i + 1 )) -lt $m ]]; then
			echo $(( $i + 1 )) $j
		fi
	) |
		while read u v; do
			if [[ $( at $u $v ) != 9 ]]; then
				echo $u $v
			fi
		done
}

drain() {
	local i=$1
	local j=$2
	local d=${drainMap[$i,$j]:=$i,$j}
	if [[ $d != $i,$j ]]; then
		d=$( drain ${d/,/ } )
		drainMap[$i,$j]=$d
	fi
	echo $d
}

merge() {
	local i=$1
	local j=$2
	local u=$3
	local v=$4
	local hij=$( at $i $j )
	local huv=$( at $u $v )
	if [[ $hij -le $huv ]]; then
		# Drain of i,j becomes drain of u,v
		drainMap[$u,$v]=$( drain $i $j )
	else
		# Drain of u,v becomes drain of i,j
		drainMap[$i,$j]=$( drain $u $v )
	fi
}

main

# 1m41s (ChromeOS)
# 1m2s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
