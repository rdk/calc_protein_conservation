
# copy this file to local-setenv.sh and edit

# edit this

PSIBLAST_DIR=/mnt/ssd/conservation/conservation-workbench/ncbi-blast/bin
CDHIT_DIR=/mnt/ssd/conservation/conservation-workbench/cd-hit
MUSCLE_DIR=/mnt/ssd/conservation/conservation-workbench

JSD_DIR=/mnt/ssd/conservation/conservation-workbench/conservation_code
PYTHON_CMD=python

BLASTDB_DIR=/mnt/ssd/conservation/blastdb
PSIBLAST_THREADS=8

# leave this

export PATH=$PSIBLAST_DIR:$CDHIT_DIR:$MUSCLE_DIR:$PATH
export JSD_DIR=$JSD_DIR
export BLASTDB=$BLASTDB_DIR
export PYTHON_CMD=$PYTHON_CMD
export PSIBLAST_THREADS=$PSIBLAST_THREADS
