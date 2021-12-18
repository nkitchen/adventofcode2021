#!/bin/bash

readarray -t bnums
k=${#bnums[0]}

sift() {
   local op=$1
   shift
   local cands=( $@ )

   local b=0
   while [[ $b -lt $k ]] && [[ ${#cands[*]} -gt 1 ]]; do
      local bitsum=0
      local cands0=()
      local cands1=()
      for word in ${cands[@]}; do
         bit=${word:$b:1}
         case $bit in
            0)
               cands0+=( $word )
               ;;
            1)
               cands1+=( $word )
               ;;
         esac
      done

      local m0=${#cands0[*]}
      local m1=${#cands1[*]}
      local cmp=$(( m0 $op m1 ))
      if [[ $(( m0 $op m1 )) == 1 ]]; then
         cands=( ${cands0[*]} )
      else
         cands=( ${cands1[*]} )
      fi

      let b++
   done
   echo ${cands[0]}
}

oxBin=$( sift ">" ${bnums[@]} )
co2Bin=$( sift "<=" ${bnums[@]} ) 
lifeSupport=$(( 2#$oxBin * 2#$co2Bin ))
echo $lifeSupport
