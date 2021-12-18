#!/bin/bash

shopt -s lastpipe

main() {
    while read line; do
        solve "$line"
    done |
        sum
}

solve() {
    # Segment sets and other data stored as files in this directory
    DIR=$( mktemp -d day8b.tmp.XXXXXXXX )
    trap "rm -r $DIR" RETURN
    (
    # Running in a subshell gets automatic return from this
    # directory.
    cd $DIR

    line=$1
    digits=( $( echo $line | cut -d' ' -f1-10 ) )
    outputs=( $( echo $line | cut -d' ' -f12-15 ) )

    mkdir ds
    for d in ${digits[@]}; do
        # Canonicalize: Sorted, one element per line
        echo $d | grep -o . | sort > ds/$d
    done

    # Segment sets by cardinality
    mkdir ns
    for d in ds/*; do
        n=$( wc -l < $d )
        mkdir -p ns/$n
        ln -s $PWD/$d ns/$n
    done

    ln -s ns/2/* one
    ln -s ns/4/* four
    ln -s ns/3/* seven
    ln -s ns/7/* eight

    # The segment for each signal, or sets of them
    mkdir m

    # One=CF and Seven=ACF differ only in signal A.
    minus seven one > m/A

    # The off signals in Six=ABDEFG, Zero=ABCEFG, and Nine=ABCDFG are C D E.

    # Complements
   mkdir -p c_ns/6
   for s in ns/6/*; do
       minus eight $s > c_ns/6/$(basename $s)
   done

    # CDE & One=CF = C
    union c_ns/6/* > m/CDE
    isect m/CDE one > m/C
    minus m/CDE m/C > m/DE

    minus one m/C > m/F

    # Four=BCDF
    isect four m/DE > m/D
    minus m/DE m/D > m/E

    # Two & Three & Five = ADG
    isect ns/5/* > m/ADG
    minus m/ADG m/A > m/DG
    minus m/DG m/D > m/G

    # Four=BCDF - One=CF = BD
    minus four one > m/BD
    minus m/BD m/D > m/B

    # Translation set
    segs=$( cat m/{A..G} | unsplit )

    for d in ${outputs[@]}; do
        sigs=$( unscramble $d )
        echo -n ${dig[$sigs]}
    done
    echo
    #dbsh
) }

unscramble() {
    echo $1 |
        grep -o . |
        tr $segs A-G |
        sort |
        unsplit
}

declare -A dig
dig=(
    [ABCEFG]=0
    [CF]=1
    [ACDEG]=2
    [ACDFG]=3
    [BCDF]=4
    [ABDFG]=5
    [ABDEFG]=6
    [ACF]=7
    [ABCDEFG]=8
    [ABCDFG]=9
)

dbsh() {
    bash -l -i </dev/tty >&/dev/tty
}

# Set union
union() {
    sort -u "$@"
}

# Set intersection
isect() {
    X=$1
    shift
    if [[ $# == 0 ]]; then
        cat $X
    else
        join $X <( isect $@ )
    fi
}

# Set difference
minus() {
    join -v 1 $1 $2
}

unsplit() {
    tr -d '[:space:]'
}

# Unscrambled segments for each digit:
#
# 0: ABC EFG
# 1:   C  F
# 2: A CDE G
# 3: A CD FG
# 4:  BCD F
# 5: AB D FG
# 6: AB DEFG
# 7: A C  F
# 8: ABCDEFG
# 9: ABCD FG

dprint() {
    echo "$@" 1>&2
}

sum() {
    awk '{s+=$1} END {print s}'
}

main

# 25.5s
# vim: set shiftwidth=4 tabstop=4 :
