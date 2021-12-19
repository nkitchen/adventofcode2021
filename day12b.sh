#!/bin/bash

shopt -s lastpipe

source lib.sh

declare -A neighbors

main() {
	readCave

	local n=$( pathsFrom start start )
	echo $n
}

readCave() {
	tr '-' ' ' |
	while read u v; do
		neighbors[$u]="${neighbors[$u]} $v"
		neighbors[$v]="${neighbors[$v]} $u"
	done
}

pathsFrom() {
	local u=$1
	shift
	local visited="$*"

	#for i in $( seq $( echo $visited | wc -w ) ); do
	#	dprint -n '  '
	#done
	#dprint pathsFrom $u $visited

	if [[ $u == end ]]; then
		echo 1
		return
	fi

    local n=0
	local v
	for v in ${neighbors[$u]}; do
		if [[ $v == start ]]; then
			continue
		fi

		local nextVisited=$visited
		if [[ $v =~ ^[a-z] ]]; then
			if [[ " $visited " == *" $v "* ]]; then
				if [[ $visited != *=2* ]]; then
					nextVisited+=" $v=2"
				else
					continue
				fi
			else
				nextVisited+=" $v"
			fi
		fi

		local k=$( pathsFrom $v $nextVisited )
		let n+=k
	done
	echo $n
}

main "$@"

# 4m56s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
