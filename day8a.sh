#!/bin/bash

shopt -s lastpipe

main() {
   cut -d'|' -f 2 |
      grep --perl-regexp -o '\b(\w{2}|\w{4}|\w{3}|\w{7})\b' |
      wc -w
}

main
