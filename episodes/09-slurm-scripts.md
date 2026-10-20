# 09. AI for Slurm Scripts: Review and Write

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- Can I trust an AI-written Slurm script for my cluster?
- What does my AI assistant need to know about the cluster before it can help?

**Objectives**
- Review a flawed job script with an AI assistant and check its claims against the cluster docs.
- Write prompts that give the AI the scheduler facts it cannot guess.
- Check module names with `module spider` and check scripts with `bash -n` and `sbatch --test-only`.

> [!NOTE]
> You do not need a cluster account for this episode. Reviewing and writing are
> paper exercises. Running the checks on a cluster is optional.
>
> The examples use REANNZ's Mahuika cluster. Every Slurm cluster differs in the same
> places: account, partitions, module names, file system paths and limits. Swap in
> your own site's facts and the prompts still work.

## Mahuika Facts Used in This Episode

An AI assistant has no way to know these facts about your cluster unless you tell it.
Each one below comes from the REANNZ docs (checked October 2026).

| Fact | Source |
|---|---|
| Charge jobs to a project with `--account`. The docs use `nesi99999` as the example code. You can leave it out only if you belong to a single project. | [Batch Computing Guide](https://docs.nesi.org.nz/Batch_Computing/Batch_Computing_Guide/), [Slurm reference sheet](https://docs.nesi.org.nz/Getting_Started/Cheat_Sheets/Slurm-Reference_Sheet/) |
| No `--partition` needed. Mahuika chooses one automatically. Only `hugemem` must be requested by name. | [Mahuika HPC3 differences](https://docs.nesi.org.nz/Getting_Started/FAQs/Mahuika_HPC3_Differences/) |
| GPUs are requested with `--gpus-per-node=<type>:<n>` (types `a100`, `h100`, `l4`, `pro_6000`). | [Using GPUs](https://docs.nesi.org.nz/Batch_Computing/Using_GPUs/) |
| R modules are named like `R/4.6.0-foss-2026`. Find them with `module spider R` (ignores case) or `module avail` (case-sensitive). | [Environment and modules](https://docs.nesi.org.nz/Tutorials/Introduction_To_HPC/Environment_And_Modules/), [R](https://docs.nesi.org.nz/Software/Available_Applications/R/) |
| The R examples run scripts with `srun Rscript script.R`. | [R](https://docs.nesi.org.nz/Software/Available_Applications/R/) |
| Python modules are named like `Python/3.14.4-foss-2026`. The docs recommend a virtual environment for your packages, activated in the job script. | [Python](https://docs.nesi.org.nz/Software/Available_Applications/Python/) |
| File systems: `/home/<username>`, `/nesi/project/<code>`, `/nesi/nobackup/<code>`. | [Filesystems and quotas](https://docs.nesi.org.nz/Storage/Filesystems_and_Quotas/) |
| Check your own jobs with `squeue --me`. Plain `squeue` lists every user's jobs. | [Batch Computing Guide](https://docs.nesi.org.nz/Batch_Computing/Batch_Computing_Guide/) |
| The REANNZ docs do not list a Quarto module. Check with `module spider quarto` before you rely on one. | [docs.nesi.org.nz/llms.txt](https://docs.nesi.org.nz/llms.txt) (no Quarto page) |

One fact is general Slurm behaviour: Slurm does not create the folder named in
`--output` or `--error`. If `logs/` does not exist, the job fails and you get no log
file to tell you why. Run `mkdir -p logs` before you submit.

## Task A: Review a Flawed Script

Open [`slurm/review-me.sl`](../slurm/review-me.sl). Someone adapted it from an old
GPU training script to run `analysis.R`. The job takes about two minutes on one CPU.

```bash
 1  #!/bin/bash
 2  #SBATCH --job-name=penguins
 3  #SBATCH --partition=gpu_p100
 4  #SBATCH --gres=gpu:1
 5  #SBATCH --cpus-per-task=8
 6  #SBATCH --mem=32G
 7  #SBATCH --time=24:00:00
 8  #SBATCH --output=logs/penguins_%j.log
 9
10  # Load required modules
11  module load r/4.3
12
13  # Activate environment
14  source activate r-env
15
16  # Set cache directories
17  export TRANSFORMERS_CACHE=$HOME/.cache/huggingface
18  export HF_HOME=$HOME/.cache/huggingface
19
20  # Run the analysis
21  cd /home/jsmith/ml103-penguins
22  Rscript analysis.R
```

### Prompt 1: the quick version

```text
is this slurm script ok?
<paste the script>
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- The AI often says the script "looks good" and suggests small style changes. It
  checks the script against generic Slurm, not against your cluster.
- It may keep `--partition=gpu_p100` because the partition name looks plausible. It
  has no way to know that Mahuika has no such partition.
- It rarely notices that the job asks for a GPU, 8 CPUs, 32 GB and 24 hours for a
  two-minute, single-threaded R script.
- It may "fix" the module line by inventing another plausible name, such as
  `module load R/4.3.1`, which may not exist on the cluster.
- It seldom mentions that Slurm will not create the `logs/` folder.
- The answer comes as prose, so you cannot easily tick off each problem.

### Prompt 2: a better version

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
```

| Part of the prompt | What it fixes |
|---|---|
| "REANNZ Mahuika", plus the job's real size | The AI can judge whether 8 CPUs, 32 GB, a GPU and 24 hours make sense |
| Scheduler facts list | Replaces generic Slurm advice with your cluster's rules: account, partitions, GPUs |
| "Do not guess a version… check `module spider R`" | Stops the AI from inventing a module name and hands the check back to you |
| "No conda environment" | Flags `source activate` as left over from the Python script |
| "Slurm does not create output directories" | Points the AI at a failure that leaves no log behind |
| Table of line, problem, fix | Gives you a checklist you can verify one row at a time |
| "List any assumptions" | Shows you which parts of the answer the AI guessed |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```bash
#!/bin/bash -e
#SBATCH --job-name=penguins            # name shown in squeue
#SBATCH --account=nesi99999            # your project code
#SBATCH --cpus-per-task=1              # analysis.R is single-threaded
#SBATCH --mem=2G                       # needs under 1 GB
#SBATCH --time=00:15:00                # job takes about 2 minutes
#SBATCH --output=logs/%x_%j.out        # run `mkdir -p logs` first
#SBATCH --error=logs/%x_%j.err

module purge
module load R/VERSION                  # replace VERSION using: module spider R
cd "$SLURM_SUBMIT_DIR"
srun Rscript analysis.R
```

**Output when run:**

```text
$ bash -n review-fixed.sl && echo "syntax OK"
syntax OK
[paste sbatch --test-only output from the cluster here]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Check it

Compare the AI's table with the answer key below. For each row the AI got wrong or
missed, find the fact in the [Mahuika facts table](#mahuika-facts-used-in-this-episode)
or the linked docs page. If you have a Mahuika account, run `module spider R` and
compare the real module names with what the AI suggested.

<details>
<summary>Reference solution: answer key</summary>

| Line | Problem | Fix |
|---|---|---|
| 1 | Without `-e`, the script carries on after a failed command, such as a failed `module load`. | `#!/bin/bash -e` |
| missing | No `--account`. If you belong to more than one project, Slurm cannot tell which one to charge. | `#SBATCH --account=nesi99999` (your project code) |
| 3 | `gpu_p100` is not a Mahuika partition. Mahuika picks partitions automatically. | Delete the line |
| 4 | Requests a GPU that R never uses. The job waits longer in the queue and wastes a scarce GPU. `--gres` is also not the syntax the Mahuika docs use. | Delete the line |
| 5 | 8 CPUs for a single-threaded script; 7 sit idle and count against your allocation. | `--cpus-per-task=1` |
| 6 | 32 GB for a job that needs under 1 GB. | `--mem=2G` |
| 7 | 24 hours for a 2-minute job. Long requests queue longer and hide runaway jobs. | `--time=00:15:00` |
| 8 | `logs/` may not exist, and Slurm will not create it. The job then fails with no log. No separate error file. | Run `mkdir -p logs` before submitting; add `--error=logs/%x_%j.err` |
| missing | No `module purge`, so modules loaded in your login session leak into the job. | `module purge` before `module load` |
| 11 | `r/4.3` does not match Mahuika's naming (`R/<version>-foss-<year>`). The load fails. | `module load R/<version>`, with the version from `module spider R` (the docs show `R/4.6.0-foss-2026`) |
| 14 | `source activate` is old conda syntax copied from the Python script. No conda environment exists, and R does not need one. | Delete the line |
| 17 | `TRANSFORMERS_CACHE` is a Hugging Face (Python) setting, deprecated even there. R ignores it. | Delete the line |
| 18 | `HF_HOME` is also irrelevant to R. | Delete the line |
| 21 | Hard-coded home path for another user (`jsmith`). It breaks for anyone else. | `cd "$SLURM_SUBMIT_DIR"` |
| 22 | Works, but the [REANNZ R docs](https://docs.nesi.org.nz/Software/Available_Applications/R/) show R run with `srun Rscript`. | `srun Rscript analysis.R` |

The corrected script is [`slurm/run_analysis.sl`](../slurm/run_analysis.sl).

</details>

> [!TIP]
> **Agent extension (Track B)**
> Ask the agent to review `slurm/review-me.sl` with the same scheduler facts and to
> write its table to the chat, not to a file. Acceptance criteria: every row cites
> a line number; it does not edit `review-me.sl`; it marks any module version it
> could not confirm as `<version>`. If you are on Mahuika, let it run
> `module spider R` (approve the command) and update its answer with what it finds.

## Task B: Write Two Job Scripts

Now write two jobs from scratch: one runs `Rscript analysis.R`, the other runs
`quarto render penguins_report.qmd`. Both run from your `ml103-penguins/` folder.

### Prompt 1: the quick version

```text
write a slurm script for my R code
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- The AI invents a partition (`compute`, `normal`, `standard`) and module names
  (`module load R`, `module load r/4.2.0`, `module load quarto`) that look right but
  may not exist on your cluster.
- It leaves out `--account`, or uses a made-up placeholder you might not notice.
- Resources are generic guesses: often 4 or more CPUs, 8 to 16 GB and several hours,
  whatever the job really needs.
- It writes output to a folder that may not exist, or to the default
  `slurm-<jobid>.out` with errors mixed in.
- It may install packages inside the job (`install.packages(...)`), which repeats a
  slow download every run and can fail on compute nodes.
- For Quarto, it often forgets that rendering R chunks needs the `knitr` and
  `rmarkdown` packages as well as the Quarto tool.

### Prompt 2: a better version

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

| Part of the prompt | What it fixes |
|---|---|
| Cluster name and "account placeholder" | The account line is present and obviously yours to replace |
| "No `--partition`. No GPU." | Stops invented partitions and wasted GPU requests |
| Explicit CPUs, memory and time | Sizes the job for what it does, so it queues quickly |
| "Do not guess the version… `module spider R`" | Turns a likely hallucination into a check you run |
| Quarto check and fail-fast line | Handles a tool you have not confirmed exists |
| `$SLURM_SUBMIT_DIR`, log paths, `logs/` reminder | Fixes the working directory and makes failures visible |
| "Do not install anything in the job" | Keeps package installs in your interactive session |
| "List anything you assumed" | Shows what to check before you submit |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

```bash
#!/bin/bash -e
#SBATCH --job-name=penguins-analysis   # name shown in squeue
#SBATCH --account=nesi99999            # replace with your project code
#SBATCH --time=00:15:00                # 15 minutes
#SBATCH --mem=2G                       # 2 GB memory
#SBATCH --cpus-per-task=1              # single-threaded R
#SBATCH --output=logs/%x_%j.out        # stdout
#SBATCH --error=logs/%x_%j.err         # stderr

module purge
module load R/<version>                # check with: module spider R
cd "$SLURM_SUBMIT_DIR"
srun Rscript analysis.R
```

**Output when run:**

```text
$ bash -n run_analysis.sl && echo "syntax OK"
run_analysis.sl: line 11: syntax error near unexpected token `newline'
run_analysis.sl: line 11: `module load R/<version>                # check with: module spider R'
[paste sbatch --test-only output from the cluster here]
```

**Notes:** [What worked, what needed fixing, anything worth showing learners. Job 1 shown; job 2 (Quarto) omitted. The `<version>` placeholder is read by bash as a redirect, so `bash -n` fails until it is replaced with the real module name.]

</details>

### Check it

AIs invent module names. Check every `module load` line before you trust it:

1. **Read the docs.** Look up the software page, for example
   [R on Mahuika](https://docs.nesi.org.nz/Software/Available_Applications/R/).
2. **Ask the cluster.** On a login node, run `module spider R` and
   `module spider quarto`. `module spider` ignores case; `module avail` does not.
   Copy the exact name it prints.
3. **Check the shell syntax.** `bash -n run_analysis.sl` prints nothing if the
   syntax is valid.
4. **Ask the scheduler.** `sbatch --test-only run_analysis.sl` checks the
   `#SBATCH` options against the cluster (account, partition, limits) and
   estimates a start time. It does not submit the job.
5. **Make the log folder.** `mkdir -p logs`.

Then compare your script with the reference answers.

<details>
<summary>Reference solution</summary>

Full commented versions: [`slurm/run_analysis.sl`](../slurm/run_analysis.sl) and
[`slurm/render_report.sl`](../slurm/render_report.sl).

```bash
#!/bin/bash -e
#SBATCH --job-name=penguins-analysis
#SBATCH --account=nesi99999            # replace with your project code
#SBATCH --time=00:15:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

module purge
module load R/4.6.0-foss-2026          # check with: module spider R
cd "$SLURM_SUBMIT_DIR"
srun Rscript analysis.R
```

```bash
#!/bin/bash -e
#SBATCH --job-name=penguins-report
#SBATCH --account=nesi99999            # replace with your project code
#SBATCH --time=00:20:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

module purge
module load R/4.6.0-foss-2026          # check with: module spider R
# module load Quarto/<version>         # only if `module spider quarto` finds one
command -v quarto >/dev/null || { echo "quarto not found on PATH" >&2; exit 1; }
cd "$SLURM_SUBMIT_DIR"
srun quarto render penguins_report.qmd --to html
```

</details>

### Python learners

Task A is the same for everyone: `review-me.sl` runs an R script, and the answer key
does not change. For Task B, write the jobs for `python analysis.py` and the Jupyter
engine render of `penguins_report.qmd`. Adapt Prompt 2 with the differences below. The
reference answers are [`slurm/run_analysis_py.sl`](../slurm/run_analysis_py.sl) and
[`slurm/render_report_py.sl`](../slurm/render_report_py.sl).

| | R job | Python job |
|---|---|---|
| Module | `module load R/<version>`, from `module spider R` | `module load Python/<version>`, from `module spider Python` (the docs show `Python/3.14.4-foss-2026`) |
| Packages | Already in your R user library | In a virtual environment, `.venv/` in the project folder. Create it once on a login node with the same module loaded, then `source .venv/bin/activate` in the job. |
| Run line | `srun Rscript analysis.R` | `srun python analysis.py` |
| Report render | Quarto plus `knitr` and `rmarkdown` | Quarto plus `jupyter` in the venv. Check with `quarto check jupyter`. |

The AI often adds `pip install` lines inside the job, or uses `conda activate` when
you have a venv. Both are the same mistake as `install.packages()` in an R job: install
once, interactively, and only activate in the job.

> [!TIP]
> **Agent extension (Track B)**
> Give the agent the same cluster facts and ask it to write
> `slurm/run_analysis.sl` and `slurm/render_report.sl` (Python: `run_analysis_py.sl`
> and `render_report_py.sl`), then check them.
> Acceptance criteria:
>
> - It asks you which project code to charge. It does not guess one.
> - It runs `module spider R` (or `module spider Python`) and uses the exact name it finds.
> - It runs `bash -n` and `sbatch --test-only` on both scripts and shows you the output.
> - It asks before running `sbatch`. You approve each submission yourself.
>
> REANNZ agent rules apply on Mahuika. Stay at the keyboard while the agent works.
> Do not let it poll the queue in a loop (`watch squeue`, `while sleep …`). If it
> needs to check a job, it runs `squeue --me` once, with minutes between checks, or
> chains the jobs with `sbatch --dependency=afterok:<jobid>` so Slurm does the
> waiting. Running `/opt/nesi/share/mahuika-agents/install.sh --skills` adds the
> REANNZ rules and a `/mahuika-slurm` skill
> ([Claude Code on Mahuika](https://docs.nesi.org.nz/Software/AI_Agents/Claude_Code_on_Mahuika/)).

## Key points

- An AI writes generic Slurm. Your cluster's account, partitions, modules and paths
  have to come from you or from the docs.
- AIs invent module names. Check each one with `module spider` and the docs.
- Size jobs to what they do: a two-minute R script needs 1 CPU, a few GB and minutes,
  not a GPU and a day.
- Check before you submit: `bash -n`, `sbatch --test-only`, `mkdir -p logs`.
- Ask for a table of line, problem and fix when you want a review you can verify.
- An agent may write and test a script, but you choose the project and approve every
  `sbatch`.
