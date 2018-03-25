#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast evalue
# $4 ... psiblast num_iterations
#

DIR=$1
OUT=$2
E=$3
ITER=$4

print() {
    echo $@ | tee -a $OUT/main.log    
}

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

process_file() {
    I=$1
    F=$2
    print "PROCESSING [$I] [$F]" | tee -a $OUT/main.log
    fstart=`date +%s`
    bash -e -x calc_conservation.sh $F $OUT $E $ITER 
    RET=$?
    fend=`date +%s`
    fruntime=$((fend-fstart))
    print TIME `format_time fruntime` | tee -a $OUT/main.log
    if [ $RET -eq 0 ]; then
        print DONE | -a tee $OUT/main.log 
        echo $file > $OUT/done.list
    else
        print FAILED | -a tee $2/main.log
        echo $file > $OUT/failed.list
    fi
}

process_dir() {
    echo PROCESSING DIR $DIR
    echo OUTDIR: $OUT
    echo psiblast evalue: $E
    echo psiblast num_iterations: $ITER
    echo -----------------------------------------------------
    start=`date +%s`

    I=1
    for F in `find $1 -name "*.fasta" -type f`; do
        fname=$(basename "$F")
        process_file $I $F | tee $OUT/log/$fname.log
        ((I++))
    done

    end=`date +%s`
    runtime=$((end-start))
    echo ----------------------------------------------------- 
    echo FINISHED IN `format_time runtime`
    echo DONE.
}

mkdir -p $OUT
mkdir -p $OUT/log

process_dir $1 $2 $3 $4 | tee $2/debug.log







