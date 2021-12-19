dprint() {
	prevSetting=$-
	set +x

	if [[ -n "$DEBUG" ]]; then
		echo "$@" 1>&2
	fi

	if [[ $prevSetting == *x* ]]; then
		set -x
	fi
}

sum() {
    awk '{s+=$1} END {print s}'
}

split() {
	grep -o .
}

unsplit() {
    tr -d '[:space:]'
}


# vim: set shiftwidth=4 tabstop=4 noexpandtab :
