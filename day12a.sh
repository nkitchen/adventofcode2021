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

	if [[ $u == end ]]; then
		echo 1
		return
	fi

    local n=0
	local v
	for v in ${neighbors[$u]}; do
		if [[ $v =~ ^[a-z]+$ ]] && [[ " $visited " == *" $v "* ]]; then
			continue
		fi

		local k=$( pathsFrom $v $visited $v )
		let n+=k
	done
	echo $n
}

main "$@"

# 11s
# vim: set shiftwidth=4 tabstop=4 noexpandtab :
