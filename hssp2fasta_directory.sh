#!/bin/bash

#
# convert hssp to compressed fasta
#
# $1 ... input dir (containing hssp files)
# $2 ... outdir (doesn't have to exist)
#

export DIR=$1
export OUT=$2
export THREADS=$3

export TMPDIR=$OUT/tmp
echo tmpdir: $TMPDIR

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


process_hssp_bz2_file() {
    HSSP_BZ2_FILE=$1
    FNAME=`basename $HSSP_BZ2_FILE`
    FNAME=${FNAME%.bz2}

    TMPOUT="$TMPDIR/${FNAME}_out"
    mkdir $TMPOUT

    bzcat $HSSP_BZ2_FILE > $TMPDIR/$FNAME  

    ./Hssp2Fasta.pl $FNAME $TMPDIR $TMPOUT
    (
      cd $TMPOUT
      bzip2 -v *
      mv -v * $OUT
    )

    rm -v $TMPDIR/$FNAME
    rm -rfv $TMPOUT
}
export -f process_hssp_bz2_file

process_dir() {
    print PROCESSING DIR $DIR
    print OUTDIR: $OUT
    print xargs threads: $THREADS
    print -----------------------------------------------------
    start=`date +%s`

    find $DIR -name "*.hssp.bz2" -type f \
    | xargs -i -P$THREADS bash -c "process_hssp_bz2_file {}" 

    end=`date +%s`
    runtime=$((end-start))
    print -----------------------------------------------------
    print OUTDIR: $OUT 
    print FINISHED IN `format_time runtime`
    print DONE.
}

mkdir -p $OUT
mkdir -p $TMPDIR


process_dir 2>&1 | tee $OUT/debug.log

rm -rf $TMPDIR



