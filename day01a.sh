#!/bin/bash

paste <( head -n -1 "$1" ) <( tail -n +2 "$1" ) |
   while read a b; do
      if [[ $a -lt $b ]]; then
         echo y
      fi
   done |
   grep -c y
