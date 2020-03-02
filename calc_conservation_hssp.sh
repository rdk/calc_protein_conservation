#!/bin/bash

# score hssp alignment from file $1.
# $2 ... output directory


source local-setenv.sh

file=$1
outdir=$2


mkdir -p $outdir/scores

file_base=$(basename "$file")
scores_file="$outdir/scores/$file_base.hom.gz"
conservationExtractorInput=$file


# Run conservation script (Jensen-Shannon divergence: http://compbio.cs.princeton.edu/conservation/)
# must be run in its own dir
(
    cd $JSD_DIR;
    # $PYTHON_CMD $JSD_DIR/score_conservation.py <(bzcat $conservationExtractorInput) | gzip -9 > $scores_file # - | ./getCol.awk | head -n 1 | sed 's/Score,//' | gzip
    $PYTHON_CMD $JSD_DIR/score_conservation.py $conservationExtractorInput | gzip -9 > $scores_file # - | ./getCol.awk | head -n 1 | sed 's/Score,//' | gzip
)  2>&1 



