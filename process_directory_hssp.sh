#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast param: evalue
# $4 ... psiblast param: num_iterations
# $5 ... number of threads
#

DIR=$1
OUT=$2
THREADS=$3


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


process_dir() {
    print PROCESSING DIR $DIR
    print OUTDIR: $OUT
    print xargs threads: $THREADS
    print -----------------------------------------------------
    start=`date +%s`

    find $DIR -name "*.fasta" -type f \
    | xargs -i -P$THREADS bash process_file_hssp.sh {} $OUT 2>&1 

    end=`date +%s`
    runtime=$((end-start))
    print -----------------------------------------------------
    print OUTDIR: $OUT 
    print FINISHED IN `format_time runtime`
    print DONE.
}

mkdir -p $OUT
mkdir -p $OUT/log

process_dir 2>&1 | tee $OUT/debug.log







