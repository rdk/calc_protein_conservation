#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast evalue
# $4 ... psiblast num_iterations
#

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
    echo PROCESSING DIR $1
    echo OUTDIR: $2
    echo psiblast evalue: $3
    echo psiblast num_iterations: $4
    echo -----------------------------------------------------
    start=`date +%s`

    I=1
    for file in `find $1 -name "*.fasta" -type f`; do
        echo "> PROCESSING [$I] [$file]"
        fstart=`date +%s`
        #bash -e -x calc_conservation.sh $file $2 $3 $4 

        fend=`date +%s`
        fruntime=$((end-start))
        if [ $? -eq 0 ]; then
            echo DONE [`format_time fruntime`]
            echo $file > $2/done.list
        else
            echo FAILED [`format_time fruntime`]
            echo $file > $2/failed.list
        fi
        ((I++))
    done

    end=`date +%s`
    runtime=$((end-start))
    echo ----------------------------------------------------- 
    echo FINISHED IN `format_time runtime`
    echo DONE.
}

mkdir -p $2

process_dir $1 $2 $3 $4 | tee $2/log







