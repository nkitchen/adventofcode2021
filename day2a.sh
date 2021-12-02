#!/bin/bash

hpos=0
depth=0

while read dir units; do
   case $dir in
      forward)
         hpos=$(( hpos + units ))
         ;;
      down)
         depth=$(( depth + units ))
         ;;
      up)
         depth=$(( depth - units ))
         ;;
   esac
done

echo $(( hpos * depth ))
