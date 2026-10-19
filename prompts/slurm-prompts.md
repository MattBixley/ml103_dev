# Slurm Prompts (Episode 09)

Copy-paste prompts for [episode 09](../episodes/09-slurm-scripts.md). Replace
`nesi99999` with your project code. On a cluster other than Mahuika, replace the
scheduler facts with your site's facts.

## Review a Script

Weak:

```text
is this slurm script ok?
<paste the script>
```

Better:

```text
Review this Slurm job script for the REANNZ Mahuika cluster. It runs a small
R script (analysis.R) that takes about 2 minutes on 1 CPU, needs under 1 GB of
memory and uses no GPU.

Scheduler facts for this cluster:
- Jobs must be charged to a project with --account (mine is nesi99999).
- No --partition is needed; the scheduler picks one. Only hugemem is requested by name.
- GPUs are requested with --gpus-per-node=<type>:<n>, but this job needs none.
- R is loaded with an environment module named like R/<version>-foss-<year>.
  Do not guess a version; write R/<version> and tell me to check `module spider R`.
- There is no conda environment for this job; R packages are in my user library.
- Slurm does not create output directories.

Return a table with columns: line number, problem, fix. Include missing lines
(use "missing" as the line number). Then give the corrected script.
Do not invent module versions, partitions or paths. List any assumptions you made.

<paste the script>
```

## Write Job Scripts

Weak:

```text
write a slurm script for my R code
```

Better:

```text
Write two Slurm batch scripts for the REANNZ Mahuika cluster.

Job 1 runs `Rscript analysis.R`. Job 2 runs `quarto render penguins_report.qmd`
to HTML. Both run from my project folder ml103-penguins/ (the folder I submit from).

Cluster facts:
- Account: --account=nesi99999 (placeholder, I will replace it).
- No --partition (the scheduler chooses). No GPU.
- Size: 1 CPU, 2 GB memory, 15 minutes for job 1; 1 CPU, 4 GB, 20 minutes for job 2.
- Load R with `module purge` then `module load R/<version>`; do not guess the version.
  Tell me to check it with `module spider R`.
- I do not know if Quarto is a module. Write a commented line for it and tell me
  how to check (`module spider quarto`). Make the job stop with a clear error if
  the quarto command is missing.
- Run R with `srun Rscript`.
- cd to $SLURM_SUBMIT_DIR. Write stdout to logs/%x_%j.out and stderr to
  logs/%x_%j.err, and remind me that Slurm does not create logs/.
- R packages are already installed; do not install anything in the job.

Use `#!/bin/bash -e`. Comment each #SBATCH line. List anything you assumed.
```

## Check a Module Name

```text
You suggested `module load <name>`. I ran `module spider <software>` on the
cluster and got this output:
<paste output>
Which exact module name should the script load? Do not suggest a name that is
not in this output.
```

## Agent Task (Track B)

```text
Write slurm/run_analysis.sl and slurm/render_report.sl for the REANNZ Mahuika
cluster, using the cluster facts below.
<paste the cluster facts from "Write Job Scripts">

Before you write anything, ask me which project code to charge.
Run `module spider R` and `module spider quarto` and use the exact names you find.
After writing, run `bash -n` and `sbatch --test-only` on both scripts and show me
the output. Do not run `sbatch` without asking me first. Do not poll the queue in
a loop; if you need a job's status, run `squeue --me` once and tell me.
```
