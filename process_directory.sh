
#
# calculate conservation score for all fasta files in the directory
#
# $1 ... input dir (containing fasta files)
# $2 ... outdir (doesn't have to exist)
# $3 ... psiblast evalue
# $4 ... psiblast num_iterations
#

process_dir() {
    echo PROCESSING DIR $1
    echo OUTDIR: $2
    echo psiblast evalue: $3
    echo psiblast num_iterations: $4
    echo start: `date`
    echo -----------------------------------------------------

    for file in `find $DIR -name "*.fasta" -type f`; do
        echo "> PROCESSING [$file]"
        #bash -e -x calc_conservation.sh $file $2 $3 $4 

        if [ $? -eq 0 ]; then
            echo OK
            echo $file > $2/done.list
        else
            echo FAILED
            echo $file > $2/failed.list
        fi

    done

    echo ----------------------------------------------------- 
    echo end: `date`
    echo DONE
}

mkdirs -p $2

process_dir $1 $2 $3 $4 | tee $2/log







