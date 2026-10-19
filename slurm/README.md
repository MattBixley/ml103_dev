# Slurm Scripts for Episode 09

These files go with [episode 09](../episodes/09-slurm-scripts.md). They use REANNZ's
Mahuika cluster as the worked example. On another cluster, change the account,
module names and partition to match your site's docs.

| File | Purpose |
|---|---|
| [`review-me.sl`](review-me.sl) | A deliberately flawed job script for Task A. Do not submit it. The answer key is in the episode. |
| [`run_analysis.sl`](run_analysis.sl) | Reference answer: runs `Rscript analysis.R`. |
| [`render_report.sl`](render_report.sl) | Reference answer: runs `quarto render penguins_report.qmd`. |

To use a reference script, copy it into your `ml103-penguins/` folder, then:

1. Replace `nesi99999` with your project code.
2. Run `module spider R` (and `module spider quarto`) and fix the `module load` lines.
3. Run `mkdir -p logs`. Slurm does not create it.
4. Run `bash -n <script>` and `sbatch --test-only <script>`.
5. Submit with `sbatch <script>` and check it with `squeue --me`.
