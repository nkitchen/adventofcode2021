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
			echo ${line#fold along} | tr '=' ' ' | read axis value
			fold $axis $value
			echo ${#dots[@]}
			break
		fi
	done
}

fold() {
	local axis=$1
	local value=$2
	local xy x y
	for xy in "${!dots[@]}"; do
		echo $xy | read x y
		case $axis in
			x)
				if [[ $x -gt $value ]]; then
					unset dots["$x $y"]
					d=$(( x - value ))
					nx=$(( value - d ))
					dots["$nx $y"]=1
				fi
				;;
			y)
				if [[ $y -gt $value ]]; then
					unset dots["$x $y"]
					d=$(( y - value ))
					ny=$(( value - d ))
					dots["$x $ny"]=1
				fi
				;;
		esac
	done
}

main "$@"

# 3s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
