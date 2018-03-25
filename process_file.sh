#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input file (fasta)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast evalue
# $4 ... psiblast num_iterations
#

FILE=$1
OUT=$2
E=$3
ITER=$4

fname=$(basename $FILE)
LOGFILE=$OUT/log/$fname.log 

format_time() {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d days ' $D
  (( $H > 0 )) && printf '%d hours ' $H
  (( $M > 0 )) && printf '%d min ' $M
  (( $D > 0 || $H > 0 || $M > 0 ))
  printf '%d s\n' $S
}

print() {
    echo $@ | tee -a $OUT/main.log    
}

process_file() {
  fstart=`date +%s`

  print "PROCESSING [$FILE]" 
  print "LOG: $LOGFILE"

  # main call
  bash -e -x calc_conservation.sh $FILE $OUT $E $ITER 2>&1 
  RET=$?

  fend=`date +%s`
  fruntime=$((fend-fstart))

  print "TIME: `format_time fruntime`" 

  if [ $RET -eq 0 ]; then
      print DONE 
      echo $FILE >> $OUT/done.list
  else
      print FAILED 
      echo $FILE >> $OUT/failed.list
  fi
}

process_file > $LOGFILE









