#!/bin/sh
# usage: runrows.sh first last  -> appends "m S S4 par tA tB1 tB2 tR | list c L wall" lines to rows.log
P=../../../units/0641-corner-residues/run/pi_2pow.txt   # run from this folder
export OMP_NUM_THREADS=4
m=$1
while [ $m -le $2 ]; do
  lc=$(python3 -c "print(round(0.29*$m))"); lL=$(python3 -c "print(round(0.415*$m))")
  t0=$(date +%s.%N); f=$(./fast4 $m $lc $lL); t1=$(date +%s.%N)
  tp=$(python3 -c "print($(sed -n "$((m+1))p" $P)%2)" 2>/dev/null)
  echo "$f | list=$tp c=2^$lc L=2^$lL wall=$(python3 -c "print(round($t1-$t0,1))")" >> rows.log
  m=$((m+1))
done
