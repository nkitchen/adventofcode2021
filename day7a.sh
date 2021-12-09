#!/bin/bash

# Let x1 < x2 < ... < xn be the crab positions.
# Any position x in [x1, xn] has the same cost for those two crabs
# -- moving it toward either of them just trades a unit of fuel
# used by one for a unit used by the other.
#
# [x1 ................................ xn]
#     [x2 .................... x{n-1}]
#         etc.
#         [x{n/2-1} .. x{n/2}]
#                      ^^^^^^
#                      best

shopt -s lastpipe

tr ',' ' ' |
   xargs -n 1 |
   sort -n |
   readarray -t crabs
n=${#crabs[@]}
best=${crabs[$(( n / 2 ))]}

abs() {
   if [[ $1 -lt 0 ]]; then
      echo $(( -$1 ))
   else
      echo $1
   fi
}

fuel=0
for c in ${crabs[@]}; do
   fuel=$(( fuel + $( abs $(( c - best )) ) ))
done
echo $fuel
