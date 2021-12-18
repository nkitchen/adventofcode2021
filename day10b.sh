#!/bin/bash

shopt -s lastpipe

source lib.sh

declare -A openerOf
openerOf=(
	[')']='('
	[']']='['
	['}']='{'
	['>']='<'
)

declare -A closerOf
for cl in ${!openerOf[@]}; do
	op=${openerOf[$cl]}
	closerOf[$op]=$cl
done

main() {
	while read line; do
		stack=()
		for i in $( seq 0 $(( ${#line} - 1 )) ); do
			c=${line:$i:1}
			op=${openerOf[$c]}
			if [[ -n "$op" ]]; then
				if [[ "${stack[-1]}" == "$op" ]]; then
					unset stack[-1]
				else
					# Corrupted
					continue 2
				fi
			else
				stack+=( "$c" )
			fi
		done
		while [[ ${#stack[@]} -gt 0 ]]; do
			c=${stack[-1]}
			cl=${closerOf[$c]}
			echo "$cl"
			unset stack[-1]
		done |
			score
	done |
		sort -n |
		readarray -t scores
	n=${#scores[@]}
	echo ${scores[$(( n / 2 ))]}
}

declare -A charPts
charPts=(
	[')']=1
	[']']=2
	['}']=3
	['>']=4
)

score() {
	t=0
	while read c; do
		x=${charPts[$c]}
		t=$(( 5 * t + $x ))
	done
	echo $t
}

main

# 0.79s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
