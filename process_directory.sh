#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast evalue
# $4 ... psiblast num_iterations
# $5 ... threads
#

DIR=$1
OUT=$2
E=$3
ITER=$4
THREADS=$5


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


process_dir() {
    echo PROCESSING DIR $DIR
    echo OUTDIR: $OUT
    echo psiblast evalue: $E
    echo psiblast num_iterations: $ITER
    echo xargs threads: $THREADS
    echo -----------------------------------------------------
    start=`date +%s`

    find $DIR -name "*.fasta" -type f \
    | xargs -i -P$THREADS bash process_file.sh {} $OUT $E $ITER

    end=`date +%s`
    runtime=$((end-start))
    echo -----------------------------------------------------
    echo OUTDIR: $OUT 
    echo FINISHED IN `format_time runtime`
    echo DONE.
}

mkdir -p $OUT
mkdir -p $OUT/log

process_dir 2>&1 | tee $2/debug.log







