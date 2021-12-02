#!/bin/bash

window () {
   local n=$1
   local window=()

   while read line; do
      window=( "${window[@]}" "$line" )
      if [[ ${#window[@]} -gt $n ]]; then
         unset window[0]
      fi
      if [[ ${#window[@]} -eq $n ]]; then
         echo "${window[@]}"
      fi
   done
}

cat $1 |
   window 3 |
   while read a b c; do
      echo $(( a + b + c ))
   done |
   window 2 |
   while read a b; do
      if [[ $a -lt $b ]]; then
         echo y
      fi
   done |
   grep -c y
