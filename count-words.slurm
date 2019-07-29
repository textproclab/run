#!/bin/bash
#SBATCH --ntasks 30
#SBATCH --output count-words-output.txt
#SBATCH --dependency singleton
#SBATCH --job-name count-words

if [ -z "$2" ]; then
    echo "Usage: srun count-words.slurm [corpus dir] [output dir]"
    exit 1
fi

CORPUS_DIR=$1
OUTPUT_DIR=$2

mkdir -p $OUTPUT_DIR

PARALLEL_OPTS=$(~/run/parallel-opts.sh)

find $CORPUS_DIR -type f | parallel $PARALLEL_OPTS \
    "wc -w {} > $OUTPUT_DIR/{/.}-words.txt"

rm count-words-hosts.txt

echo "Completed job $SLURM_JOB_ID in $(sacct -nXj $SLURM_JOB_ID -o elapsed)"
