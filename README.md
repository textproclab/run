# Run

This repository contains the set up for running text processing jobs on
Hopper using SLURM to reserve nodes and GNU parallel to assign file names to
the nodes and enable resuming interrupted jobs.


## Use

1. Clone this repository to `~/run`:

```
cd
git clone git@github.com:textproclab/run.git
```

2. Install the `clustershell` Python module:

```
pip install clustershell
```

3. In the repository with your code, make a new SLURM script. For an
example, see `count-words.slurm` in this repository.

4. In your code's documentation, add instructions directing users to this
repository.

5. Submit the SLURM script:

```
sbatch count-words.slurm \
    /data/textproclab/corpora/Gutenberg/text-clean \
    /data/textproclab/tmp
```

In addition to the files explicitly created (e.g., the `-words.txt` files
with word counts), this creates three files related to the job:
- `count-words-output.txt` is the log file containing any output written to
  the standard output or error streams by the jobs.
- `count-words-jobs.txt` is used by parallel to keep track of which of the
  sub-jobs (files being processed) completed successfully. If the job is
  interrupted, this can be used to re-run only those parts that weren't
  successfully completed. If you want to run a new job or re-run everything
  from scratch, delete this file.
- `count-words-hosts.txt` is used by parallel to keep track of the nodes
  it's running on. It can be deleted when the job is finished, even if you
  want to resume later.


## Acknowledgements

This set up is derived from that made for the University of Connecticut HPC
by Pariksheet Nanda: https://github.uconn.edu/HPC/parallel-slurm
