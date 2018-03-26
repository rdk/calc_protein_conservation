#!/bin/bash

#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... done.list (containing files with already calculated scores)
#
# output: list of files from $1 that don't have scores calculated 
#

DIR=$1
DONEF=$2

ALLF=$(tempfile)
DONESF=$(tempfile)

find $DIR -name "*.fasta" -type f | sort > $ALLF
cat $DONEF | sort > $DONESF 

# lines in A but not B
comm -23 $ALLF $DONESF

rm $ALLF
rm $DONESF


