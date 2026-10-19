# Agent Track: Going Further with Claude Code

This page is for after the workshop. It assumes you worked through the Track B
**Agent extension** callouts and want to use a coding agent on your own R or Python projects.
The examples use Claude Code and the `ml103-penguins/` project, but the habits apply
to any coding agent.

Official documentation:

- Claude Code overview: <https://docs.claude.com/en/docs/claude-code/overview>
- Claude Code on Mahuika (REANNZ): <https://docs.nesi.org.nz/Software/AI_Agents/Claude_Code_on_Mahuika/>
- REANNZ AI Agent Guidelines: <https://docs.nesi.org.nz/Software/AI_Agents/AI_Agent_Guidelines/>

Commands and keys change between versions. If something here does not match what
you see, the official docs win.

## 1. Run Claude Code Inside Your RStudio Project

Claude Code runs in a terminal and works on the folder you start it in. Starting it
from your RStudio Project keeps its view of files the same as yours.

1. Install Claude Code by following the
   [overview page](https://docs.claude.com/en/docs/claude-code/overview).
2. Open `ml103-penguins.Rproj` in RStudio.
3. Open a terminal tab: **Tools > Terminal > New Terminal**. RStudio starts it in the
   project folder.
4. Run `claude`. Sign in when it asks.

You now have RStudio's editor, console and Viewer on one side and the agent in the
Terminal tab. When the agent edits a file, RStudio reloads it, so you can read every
change in the editor you already know.

**Python learners:** open the `ml103-penguins/` folder in VS Code (or a terminal next
to Jupyter), activate the venv with `source .venv/bin/activate`, then run `claude`
from that folder. Starting the agent with `.venv` active means `python` and `pip`
point at the project's environment, not your system Python.

> [!WARNING]
> The agent reads files in this folder and sends their contents to an offshore
> provider. Keep only data you could publish in the project folder. Never point an
> agent at Māori data, health or personal data, ethics-restricted data or commercial
> data unless your data agreement and your institution explicitly allow it.

## 2. Give the Project a Memory File

Each session starts with no memory of the last one. A project memory file fixes
that. Claude Code reads `CLAUDE.md` from the project folder at the start of every
session. Many other agents read `AGENTS.md` instead.

A practical pattern:

- Put the rules in `AGENTS.md`, so any agent can use them.
- Make `CLAUDE.md` short: one line, `@AGENTS.md`, which imports the rules, plus facts
  only Claude Code needs.

Examples for this workshop: [`AGENTS.md`](AGENTS.md) and [`CLAUDE.md`](CLAUDE.md).
Copy both into `ml103-penguins/` and edit them.

The `/init` command asks Claude Code to read the project and draft a `CLAUDE.md`.
Treat the draft as a starting point. Delete anything vague and add the rules that
matter to you: the code style, which files it may touch, and what to do before it
claims success. Keep the file short; every line uses up context in every session.
Run `/context` to see what the agent has loaded.

## 3. Approve Actions Yourself

By default Claude Code asks before it edits a file or runs a command. Read each
request before you approve it:

- **File edits:** read the diff. Does it change only what you asked for?
- **Commands:** do you know what the command does? `Rscript analysis.R` (or
  `python analysis.py`) is harmless; `rm -rf figures/` is not.
- **Package installs:** would you install this package yourself? In Python, check
  that `pip install` runs inside `.venv`, and that the package is also added to
  `requirements.txt`.

You can pre-approve safe commands and block risky ones in `.claude/settings.json`
(see the permissions section of the official docs, or run `/permissions`). The
Mahuika page linked above gives a worked example: it allows `squeue --me`,
`sacct -j` and `module`; asks for `make`, `sbatch`, `scancel`, `rm`, `find` and `du`
(`find` and `du` can scan shared filesystems); and denies reading `~/.ssh/` and
`~/.bashrc`.

> [!WARNING]
> Do not use `--dangerously-skip-permissions`, auto mode, or any other mode that
> approves commands for you. On REANNZ systems this breaks the supervision rule.
> Anywhere else, it hands an agent your account with no checks.

## 4. Plan First, Then Edit

For anything bigger than a one-line fix, ask for a plan before any edits. Claude
Code has a **plan mode** for this (press Shift+Tab to cycle modes). In plan mode the
agent reads files and proposes steps but changes nothing.

```text
Plan only, do not edit yet. I want analysis.R to save p_bill and p_mass to
figures/ as PNG files. List the files you would change, the code you would add,
and how you will check it worked.
```

For Python, swap in `analysis.py`. Read the plan. Correct it if it is wrong ("use
`ggsave()`, not `png()`", or "use `fig.savefig()`, not `plt.show()`") and only then
let it make the edits. Fixing a plan costs far less than unpicking a wrong edit.

## 5. Give Acceptance Criteria

An agent stops when it believes it has finished. Tell it what "finished" means in
terms it can check:

```text
Add a summary table of body mass by species and sex to penguins_report.qmd.

Done means:
- the table uses penguins_clean, not penguins
- it shows n, mean and sd, rounded to 1 decimal place
- `quarto render penguins_report.qmd` finishes with no errors or warnings
- you show me the rendered table's first rows from the HTML or the R output
```

For the Python report, the same criteria apply with "the R output" replaced by "the
Python output"; also require that `quarto check jupyter` finds `.venv`.

Each criterion is something you can confirm yourself in under a minute.

## 6. Make the Agent Run and Check Its Own Work

The rule "always run the code before you claim success" catches most agent
mistakes: misspelt columns, missing packages and code that was never executed. Put
it in `AGENTS.md`, and ask for evidence:

- "Run `Rscript analysis.R` and show me the last 20 lines of output."
- "Render the report and tell me the size of the HTML file and any warnings."
- "Check that `nrow(penguins_clean)` is 333 and show me the output."
- Python: "Run `python analysis.py`, check that `len(penguins_clean)` is 333 and
  show me the output."

Evidence from a command is not the same as correctness. A plot can render and still
show the wrong variable. You still open the HTML and look.

## 7. Review the Diff

Before you accept a change, see exactly what changed. In RStudio, the **Git** pane
shows a diff for each file. In the terminal, `git diff` does the same. Look for:

- changes to files you did not ask about
- deleted code or comments
- new packages in `library()` calls (Python: `import` lines and `requirements.txt`)
- hard-coded paths, especially to someone else's home folder

## 8. Use Git Commits as Checkpoints

Commit before you hand the agent a task, and again when you accept the result.
If the agent makes a mess, you can return to the last good state with
`git restore <file>` or `git checkout -- <file>`.

```text
Before you start, show me `git status`. If there are uncommitted changes, stop and
ask me what to do.
```

Write the commit messages yourself, or read the agent's suggested message before
you accept it. Record AI help in the message if your group expects that (for
example, "Summary table drafted with Claude Code, checked by hand").

## 9. On REANNZ Systems

REANNZ has [rules for AI agents](https://docs.nesi.org.nz/Announcements/AI_Agent_Rules/)
on Mahuika. Episode 02 covers them; the practical steps are:

1. Install the REANNZ rules and skills once:
   `/opt/nesi/share/mahuika-agents/install.sh --skills`. This links
   `~/.claude/CLAUDE.md` to the REANNZ rules (or adds an import line to your existing
   file). Run `/context` in Claude Code to check the rules loaded.
2. **Stay supervised.** Run one session at a time, watch it, and quit Claude Code
   before you log out. Using `tmux` so a dropped connection does not kill the
   session is fine while you are there; leaving an agent running in `tmux` or
   under `nohup` after you log out is unsupervised and needs a service account.
3. **No independent access.** Never give an agent passwords, SSH keys or tokens.
4. **No inbound tunnels or remote control** (for example `/remote-control`).
5. **Limit scope and load.** Your own jobs and files only. Heavy work goes in Slurm
   jobs, not on the login node. No polling loops: check a job with `squeue --me`
   once, with minutes between checks, or chain jobs with
   `sbatch --dependency=afterok:<jobid>`.
6. **You choose the project and approve every `sbatch`.** The agent asks which
   project code to charge; it never guesses.
7. Check generated commands against the docs. The REANNZ docs index for AI tools
   is <https://docs.nesi.org.nz/llms.txt>.

REANNZ does not support third-party AI tools. If the agent gets something wrong,
REANNZ support can help with the cluster, not with the agent.

## A Session Checklist

1. Commit, or check `git status` is clean.
2. Start `claude` in the project folder. Check `/context` shows your rules.
3. Ask for a plan. Correct it.
4. Give the task with acceptance criteria.
5. Approve or refuse each action after reading it.
6. Ask for evidence that it ran: output, row counts, render log.
7. Read the diff. Open the output yourself.
8. Commit with a message you wrote or checked.
9. Quit the agent before you walk away.
