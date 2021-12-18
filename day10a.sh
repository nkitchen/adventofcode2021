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

declare -A charPts
charPts=(
	[')']=3
	[']']=57
	['}']=1197
	['>']=25137
)

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
					echo ${charPts[$c]}
					break
				fi
			else
				stack+=( "$c" )
			fi
		done
	done |
		sum
}

main

# 0.3s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
