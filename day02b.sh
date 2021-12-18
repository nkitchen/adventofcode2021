#!/bin/bash

hpos=0
depth=0
aim=0

while read dir units; do
   case $dir in
      forward)
         hpos=$(( hpos + units ))
         depth=$(( depth + aim * units ))
         ;;
      down)
         aim=$(( aim + units ))
         ;;
      up)
         aim=$(( aim - units ))
         ;;
   esac
done

echo $(( hpos * depth ))
