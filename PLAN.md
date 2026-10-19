# ML103 rework plan

**ML103: AI-Assisted Coding with R** (working subtitle)

Status: DRAFT for review (updated 2026-10-20). Replaces the Python/Jupyter
LLM-on-HPC workshop. A parallel Python version of the notes is included.

## 1. Goal

Learners who can already do basic R (or Python) use a generative AI assistant to
write a complete, reproducible tidyverse (or pandas) report on the penguins dataset,
plus a Slurm job script. They learn to judge, verify and disclose what the AI produced.

Core teaching device: every coding step shows a **weak prompt**, what typically goes
wrong, then a **better prompt** and why it works. Learners write their own prompt
before seeing the better one.

## 2. Delivery principles

- **Standalone and usable anywhere.** Plain Markdown notes that read on GitHub, print
  to PDF, or drop into any site generator. No dependency on Carpentries tooling, Open
  OnDemand, the training environment or Mahuika.
- Works on any R ≥ 4.3 with RStudio: a local install, Posit Cloud or RStudio Server.
  The Python notes work on any Python ≥ 3.10 with Jupyter or VS Code.
- Packages install from CRAN/PyPI with one command. No preinstalled environment assumed.
- Self-paced or instructor-led. Instructor notes live in a separate folder.
- **3 hours total**, including one 10-minute break.
- Prerequisites are stated as skills: base R, data frames and basic ggplot2. GA
  [Introduction to R](https://genomicsaotearoa.github.io/Introduction-to-R/) is
  linked as the recommended route (ends at base R + ggplot2; no pipes, dplyr or
  reports). For Python: basic pandas and matplotlib.
- REANNZ policy content is self-contained. It applies directly on REANNZ systems and
  serves as a worked example of institutional AI rules for everyone else.

## 3. Two tracks, run together in the same room

| | Track A: Web AI (everyone) | Track B: Agents (Claude access) |
|---|---|---|
| Tool | Google Search **AI Mode** (no sign-in). Backups: Duck.ai, logged-out ChatGPT | Claude Code (terminal, RStudio terminal or IDE) |
| Workflow | Write prompt → copy code → paste into RStudio → run → verify | Agent reads the project, edits files and runs R; learner approves each action |
| Data exposure | Learner pastes only code, errors and `glimpse()` output | Agent reads project files, so the project dir holds only shareable data |
| Rules | Ethics + institution's AI/acceptable-use policy | Same, plus agent rules (REANNZ `AGENTS.md` as worked example) |

Every episode is written for Track A and has an **Agent extension** callout for
Track B. That callout covers the same task done as an agent task with acceptance
criteria, and goes further: it has the agent render, review and fix. Track B
learners work through the same episodes at the same time. `extras/agent-track.md`
holds the deeper material (project `CLAUDE.md`/`AGENTS.md`, plan mode, permissions)
for after the workshop.

## 4. Episode outline (180 min)

| # | Episode | Min | Weak → better prompt example |
|---|---|---|---|
| 00 | Welcome & setup: project, packages, open the AI tool | 10 | n/a |
| 01 | How LLMs work (briefly) and AI ethics in research | 20 | n/a (discussion + disclosure-statement draft) |
| 02 | Rules of the road: REANNZ Acceptable Use, AI Agent Rules, Agent Guidelines | 15 | n/a (scenario cards) |
| 03 | Anatomy of a good prompt | 10 | "make a graph" → context + data shape + package + style + output |
| 04 | Load & explore penguins | 15 | "analyse penguins in R" → R version, tidyverse, `glimpse()` output pasted, specific question |
| 05 | Wrangle with dplyr (bridge from base R `[ , ]`), with debugging folded in | 25 | "clean the data" → named verbs, NA policy, `|>`, ask for a base-R cross-check |
| — | Break | 10 | |
| 06 | Visualise with ggplot2 | 20 | "plot penguins" → variables, colour-blind palette, labels, facets, `ggsave` size |
| 07 | Statistics: code you can run but don't understand | 15 | "is there a difference?" → "explain each line of output, the assumptions, and what would make this wrong" |
| 08 | Assemble the Quarto report + AI-use statement | 20 | "write a report" → section skeleton, chunk options, disclosure paragraph |
| 09 | AI for Slurm scripts: review and write | 15 | "write a slurm script" → scheduler facts, resources, modules, paths; "review this script against the docs" |
| 10 | Verify & wrap-up: human checklist, where next | 5 | "is this right?" → "review for X, Y, Z; list your assumptions" |
| | **Total** | **180** | |

Timing is tight. Episodes 04 to 08 build one report, so a learner who falls behind
copies the checkpoint file for that episode from `checkpoints/` and carries on.

### Per-episode template

1. Questions, objectives and time
2. **Prompt 1 (weak)**: learners try it themselves
3. *What typically goes wrong*: failure patterns, not pasted output (AI output varies)
4. **Prompt 2 (better)**: annotated, showing which part fixes which problem
5. **Check it**: verify the AI code against something known (base R result, row
   counts, a hand-drawn expectation)
6. Reference solution: instructor-verified code in a collapsible `<details>` block
7. **Agent extension (Track B)**
8. Key points

## 5. Episode 01: AI and ethics (content outline)

- How LLMs produce text: next-token prediction, and why they hallucinate (invented
  functions, wrong argument names, made-up column names)
- Bias and representativeness: fluent is not the same as correct
- **Data sovereignty and privacy:** anything pasted into a web AI leaves NZ. Do not
  paste Māori data (Te Mana Raraunga, CARE principles), health/personal data,
  ethics-restricted data or commercial data. Penguins is used because it is safe.
- Research integrity: authorship, disclosure, reproducibility (record prompts, pin
  versions). Royal Society Te Apārangi *Guidelines for the best-practice use of GenAI
  in research* (2025).
- Licensing and IP of generated code; citing tools
- Environmental cost; when *not* to use AI (learning fundamentals, sensitive data)
- Exercise: draft an AI-use disclosure statement (reused in episode 08)

## 6. Episode 02: REANNZ rules (content outline)

Sources:

- Acceptable Use Policy: https://docs.nesi.org.nz/Policy/Acceptable_Use_Policy/
- New Rules for AI Agents: https://docs.nesi.org.nz/Announcements/AI_Agent_Rules/
- AI Agent Guidelines: https://docs.nesi.org.nz/Software/AI_Agents/AI_Agent_Guidelines/
- Access Policy (data-sharing conditions): https://docs.nesi.org.nz/Policy/Access_Policy/

Teach:

- You are responsible for everything an agent does under your account.
- The five rules:
  - Agents must be **supervised**.
  - No **independent access**: no passwords, keys or tokens, and no self-login.
  - No **inbound tunnels** (ngrok, VS Code tunnels, remote-control features).
  - Limit **scope and load**: own jobs and files only, slow polling, heavy work in
    jobs and not on login nodes.
  - Follow the REANNZ **`AGENTS.md`** rules file.
- Install the rules with `/opt/nesi/share/mahuika-agents/install.sh` (`--skills`,
  `--project DIR`). Repo: https://github.com/nesi/mahuika-agents
- Data sensitivity: everything an agent reads goes to an offshore provider.
- Unsupervised means loops after you stop watching, cron/scrontab, or tmux/nohup after
  logout. Those need a service account (in development; contact support).
- Timeline: system-wide install Fri 23 Oct 2026; enforcement contact from 1 Nov 2026.
- REANNZ does not support third-party AI tools. Verify generated commands against the
  docs (https://docs.nesi.org.nz/llms.txt).
- Exercise: "Is this allowed?" scenario cards:
  - Claude Code left running in tmux overnight
  - patient metadata pasted into a web chatbot
  - `watch -n 1 squeue`
  - an agent asking for your SSH key

## 7. Episode 07: statistics (content outline)

The point: AI makes it trivial to produce statistical output you cannot interpret.

- **Simpson's paradox in penguins.** Across all species, bill depth vs bill length
  has a *negative* slope. Within each species it is *positive*. A weak prompt gives a
  confident, wrong conclusion; the better prompt asks about grouping and confounders.
- `lm(body_mass_g ~ species)` / ANOVA: learners ask the AI to explain each part of
  `summary()` output, then check one claim themselves.
- A t-test on unchecked assumptions, and the AI's answer to "when would this be wrong?"
- Message: if you can't explain it, you can't put it in the report. The report's
  Limitations section must say so.

## 8. Episode 09: Slurm scripts (content outline)

- **Review:** learners get a flawed script based on the old `examples/train.sl` (wrong
  partition, missing account, deprecated env vars, `source activate`, unchecked
  memory/time). Weak prompt "is this ok?" → better prompt "review against these
  scheduler facts and docs; list each problem with line number and fix".
- **Write:** a job that renders the Quarto report or runs `Rscript analysis.R`. Weak:
  "write a slurm script for my R code". Better: cluster/scheduler facts, account,
  CPUs/mem/time, module names, working directory, output and error paths.
- Show the AI inventing module names, then check them with `module spider` (or the docs).
- Agent extension: the agent may write the script and run `sbatch --test-only`, under
  supervision and following the REANNZ agent rules (no polling loops; use
  `squeue --me` sparingly).
- Usable without a cluster: review and write are paper exercises. Running is optional.

## 9. Python parallel notes

- Same episodes, numbering and prompt pairs, rewritten for Python. Shared episodes
  (01 ethics, 02 rules, 03 prompting, 09 Slurm, 10 wrap-up) are not duplicated. They
  live in `episodes/` and link to the language-specific steps.
- Stack: `pandas`, `seaborn`/`matplotlib`, `scipy`/`statsmodels`, `palmerpenguins`
  (pip). Report as a Quarto `.qmd` with the Jupyter engine, or a notebook rendered
  to HTML.
- Old LLM-on-HPC notebooks go to `archive/python-llm/`. Not taught.

## 10. Repo layout (proposed)

```
ml103_dev/
├── README.md                 # ML103: AI-Assisted Coding with R (+ Python notes)
├── PLAN.md
├── LICENSE.md                # CC-BY 4.0 (prose) + MIT (code)
├── setup.md                  # R and Python; local / Posit Cloud / server; AI tools
├── episodes/                 # shared, language-agnostic
│   ├── 00-welcome.md
│   ├── 01-ai-and-ethics.md
│   ├── 02-rules-of-the-road.md
│   ├── 03-prompt-anatomy.md
│   ├── 09-slurm-scripts.md
│   └── 10-verify-wrap-up.md
├── r/
│   ├── 04-explore.md … 08-report.md
│   ├── checkpoints/          # catch-up files per episode
│   └── solutions/penguins_report.qmd
├── python/
│   ├── 04-explore.md … 08-report.md
│   ├── checkpoints/
│   └── solutions/penguins_report.qmd
├── prompts/                  # copy-paste prompt library (weak + better)
├── slurm/                    # flawed script to review + reference scripts
├── extras/
│   ├── agent-track.md        # deeper Track B material
│   ├── AGENTS.md             # example project rules for agents
│   └── CLAUDE.md
├── instructors/              # timing, known AI failure modes, demo script
└── archive/python-llm/       # old notebooks + examples
```

Reference report sections: Introduction and data source; Data cleaning; Summary
tables by species/island/sex; Figures; Simple comparison (with the Simpson's paradox
caveat); Limitations; **AI-use statement**; `sessionInfo()`.

## 11. Known pitfalls to design around

- **Two penguins datasets.** R ≥ 4.5 ships `datasets::penguins` with short names
  (`bill_len`, `flipper_len`, `body_mass`). The `palmerpenguins` package uses
  `bill_length_mm` etc. Use `palmerpenguins` as the canonical dataset. One "check it"
  exercise uses the mismatch to show an AI confidently using the wrong column names.
- AI output is non-deterministic, so never script exact outputs. Teach failure patterns.
- AIs mix base R and tidyverse and use superseded functions (`gather`/`spread`,
  `size=` vs `linewidth=`, `%>%` vs `|>`). Specify the style in the prompt.
- Copy/paste damage from web UIs (smart quotes, truncated code).
- Google AI Mode answers are search-grounded and short. Long code may need "give the
  complete code in one block". Check signed-out availability before each run.
- Learners skipping "check it". Make verification visible in every episode.

## 12. Decisions

- 2026-10-20: Standalone Markdown notes, usable anywhere.
- 2026-10-20: 3 hours. Name "ML103", subtitle "AI-Assisted Coding with R".
- 2026-10-20: Tracks A and B run together.
- 2026-10-20: Scope is wrangle → plot → report, plus basic stats framed as "code you
  can write but don't understand", plus Slurm script review and writing.
- 2026-10-20: Licence CC-BY 4.0 (prose) + MIT (code).
- 2026-10-20: Track A tool is Google Search AI Mode (available in NZ).
- 2026-10-20: Parallel Python notes. Old LLM notebooks archived.
- Defaults (not objected to): `palmerpenguins` canonical; Quarto `.qmd` → HTML.

## 13. Open questions

1. Slurm examples: generic Slurm with REANNZ/Mahuika as the worked example (module
   names, `--account`, no partition needed)? Assumed yes.
2. Python stack: pandas (assumed, most AI-familiar) or polars?
3. Build order: R notes first, then the Python port? Assumed yes.
