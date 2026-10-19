# Slurm Scripts for Episode 09

These files go with [episode 09](../episodes/09-slurm-scripts.md). They use REANNZ's
Mahuika cluster as the worked example. On another cluster, change the account,
module names and partition to match your site's docs.

| File | Purpose |
|---|---|
| [`review-me.sl`](review-me.sl) | A deliberately flawed job script for Task A. Do not submit it. The answer key is in the episode. |
| [`run_analysis.sl`](run_analysis.sl) | Reference answer: runs `Rscript analysis.R`. |
| [`render_report.sl`](render_report.sl) | Reference answer: runs `quarto render penguins_report.qmd`. |
| [`run_analysis_py.sl`](run_analysis_py.sl) | Python reference answer: activates `.venv` and runs `python analysis.py`. |
| [`render_report_py.sl`](render_report_py.sl) | Python reference answer: renders `penguins_report.qmd` with Quarto's Jupyter engine. |

To use a reference script, copy it into your `ml103-penguins/` folder, then:

1. Replace `nesi99999` with your project code.
2. Run `module spider R` (Python: `module spider Python`) and `module spider quarto`, and fix the `module load` lines.
3. Run `mkdir -p logs`. Slurm does not create it.
   Python only: create `.venv` on a login node with the same Python module loaded
   (the steps are in the comments at the top of `run_analysis_py.sl`).
4. Run `bash -n <script>` and `sbatch --test-only <script>`.
5. Submit with `sbatch <script>` and check it with `squeue --me`.
