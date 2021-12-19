#!/bin/bash

shopt -s lastpipe

source lib.sh

declare -A dots

main() {
	local line
	while read line; do
		if [[ $line == *,* ]]; then
			echo $line | tr ',' ' ' | read x y
			dots["$x $y"]=1
		elif [[ $line == 'fold along'* ]]; then
			dprint $line
			echo ${line#fold along} | tr '=' ' ' | read axis value
			fold $axis $value
			if [[ -n "$DEBUG" ]]; then
				display
			fi
		fi
	done
	display
}

fold() {
	local axis=$1
	local value=$2
	local xy x y
	local folded=()
	for xy in "${!dots[@]}"; do
		echo $xy | read x y
		case $axis in
			x)
				if [[ $x -gt $value ]]; then
					folded+=( "$xy" )
				fi
				;;
			y)
				if [[ $y -gt $value ]]; then
					folded+=( "$xy" )
				fi
				;;
		esac
	done
	for xy in "${folded[@]}"; do
		echo $xy | read x y
		unset dots["$x $y"]
		case $axis in
			x)
				d=$(( x - value ))
				nx=$(( value - d ))
				dots["$nx $y"]=1
				;;
			y)
				d=$(( y - value ))
				ny=$(( value - d ))
				dots["$x $ny"]=1
				;;
		esac
	done
}

display() {
	local x y xy m=0 n=0
	for xy in "${!dots[@]}"; do
		echo $xy | read x y
		let m=$(( x > m ? x : m ))
		let n=$(( y > n ? y : n ))
	done

	for y in $( seq 0 $n ); do
		for x in $( seq 0 $m ); do
			if [[ -n "${dots[$x $y]}" ]]; then
				echo -n '#'
			else
				echo -n '.'
			fi
		done
		echo
	done
	echo
}

main "$@"

# 5s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
