# 02. Rules of the Road: REANNZ Policies for AI Use

**Time:** 15 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What must you do to use an AI agent on a REANNZ system?
- Which actions break the rules, even by accident?
- How do you apply these rules at your own institution?

**Objectives**
- State the five rules for agents on REANNZ systems.
- Decide whether a scenario is allowed, and say why.
- Install the REANNZ agent rules, if you have a Mahuika account.

## Where these rules apply

These rules apply on REANNZ systems, including the Mahuika supercomputer documented at [docs.nesi.org.nz](https://docs.nesi.org.nz/). If you work somewhere else, read them as a worked example. Use them to find the questions to ask about your own institution's acceptable use policy and AI rules.

Two timing points matter:

- The agent rules are installed system-wide on **Friday 23 October 2026**.
- From **1 November 2026**, REANNZ contacts anyone who is not following them.

> [!NOTE]
> **Track A learners:** when you use a web AI tool in a browser on your own laptop, that tool is not an agent. Data sensitivity and your institution's acceptable use policy still apply. REANNZ does not support third-party AI tools, so check any command an AI gives you against the documentation before you run it on a REANNZ system.

Read the [Acceptable Use Policy](https://docs.nesi.org.nz/Policy/Acceptable_Use_Policy/) and the [Access Policy](https://docs.nesi.org.nz/Policy/Access_Policy/), which sets the conditions for sharing data.

## You are responsible for every agent action

Everything an agent does under your account is your responsibility. Read the rules before you start an agent, not after.

## The five rules

Read the official wording on the [AI Agent Rules](https://docs.nesi.org.nz/Announcements/AI_Agent_Rules/) page. In summary:

1. **Agents must be supervised.** You start the agent, stay at the session, and approve its actions as they happen. Loops, scheduled tasks, and sessions left running after you log out do not count as supervised.
2. **Agents must not have independent access.** An agent must not hold your passwords, SSH keys or tokens, and must not log in by itself. SSH means Secure Shell, the protocol that you use to log in to a remote system.
3. **Agents must not open inbound tunnels.** Do not use reverse SSH tunnels, ngrok, VS Code tunnels, or the remote-control features of AI tools. These let connections from outside reach the cluster.
4. **Agents must limit scope and load.** Work only on your own jobs and files. Poll the scheduler slowly, use job dependencies instead of polling, and keep heavy work off the login node.
5. **Agents must follow `AGENTS.md`.** This is the REANNZ agent rules file.

### Check the scheduler slowly

A login node is shared by every user, so keep checks light. Check your jobs with `squeue --me`, then wait at least 60 seconds before the next check:

```bash
squeue --me
sleep 60
squeue --me
```

Better still, chain jobs so that the second one starts only when the first finishes successfully. Replace `4018273` with the job ID that `sbatch` printed for your first job:

```bash
sbatch --dependency=afterok:4018273 report.sl
```

Do not run any of these:

| Do not run | Run this instead |
|---|---|
| `watch -n 1 squeue` | `squeue --me`, then `sleep 60` between checks |
| `sacct --allusers` | `sacct -u "$USER"` for your own jobs |
| `find /nesi/project` or `grep -r` over `/home` with no path limit | A named directory, such as `grep -r "bill_length" ./analysis` |
| Submitting many jobs to see what works | One test job, check its output, then scale up. `sbatch --test-only` checks a script without running it |
| `top` or `ps aux`, refreshed without a filter | `top -u "$USER"` or a single `ps -u "$USER"` |

## What agents should do

When you use an agent on a REANNZ system, the agent should:

- work only in the directory you give it;
- ask before deleting files it did not create, and before running `scancel --me`, which cancels all of your jobs;
- ask which project to charge for compute time;
- ask before reading data that may not be shareable;
- never open, print or copy secrets such as keys, tokens or passwords.

### Data sensitivity

Everything an agent reads goes to an offshore model provider. Personal, health, Māori, and ethics, contract or export-restricted data often cannot be shared with a provider at all. Check your data agreement before you point an agent at a dataset.

### Unsupervised work needs a service account

Some tasks keep running after you stop watching. Examples include loops that continue after you walk away, cron or scrontab schedules, and tmux or nohup sessions that survive logout. These need a service account. Service accounts are in development, so contact [support@nesi.org.nz](mailto:support@nesi.org.nz) if you need one.

## Install the rules on Mahuika

On a login node, run:

```bash
/opt/nesi/share/mahuika-agents/install.sh --skills
```

The script links `~/.claude/CLAUDE.md` to the rules, or adds an import line if you already have that file. It never overwrites existing files. The `--skills` flag also adds REANNZ skills, such as `/mahuika-slurm`.

Check that Claude Code loaded the rules. Start `claude` and run `/context`. The file `~/.claude/CLAUDE.md` should appear under **Memory files**.

For other tools, point the agent at `/opt/nesi/share/mahuika-agents/dist/AGENTS.md`. The source code is at [github.com/nesi/mahuika-agents](https://github.com/nesi/mahuika-agents).

On your own computer, install the rules locally as well. The [AI Agent Guidelines](https://docs.nesi.org.nz/Software/AI_Agents/AI_Agent_Guidelines/) explain how.

If your tool only reads rules from the project folder (for example Cursor CLI), add `--project DIRECTORY` to link `AGENTS.md` into that folder.

Agents can start from the documentation index at https://docs.nesi.org.nz/llms.txt. The Claude Code setup guide for Mahuika is at [Claude Code on Mahuika](https://docs.nesi.org.nz/Software/AI_Agents/Claude_Code_on_Mahuika/).

## Is this allowed?

Decide each scenario before you open its answer. Check the answer against the five rules.

### Card 1: the overnight session

You start Claude Code in a tmux session on a login node. You close your laptop and leave it running overnight so it can keep submitting jobs.

<details>
<summary>Answer</summary>

**Not allowed.** Nobody supervises the session once you stop watching or log out. tmux sessions that survive logout need a service account. Stop the session, or wait for a service account.

</details>

### Card 2: the patient records

A colleague's dataset has patient ages, postcodes and diagnoses. You paste the first 20 rows into a web chatbot to ask for plot code.

<details>
<summary>Answer</summary>

**Not allowed.** Health and personal data often cannot leave New Zealand, and web AI tools send your text to an offshore provider. Ask the data owner about an approved route, or practise with openly licensed data such as penguins.

</details>

### Card 3: the watch loop

Your job is queued, so you run `watch -n 1 squeue` in a second terminal to see when it starts.

<details>
<summary>Answer</summary>

**Not allowed as written.** The command checks the scheduler every second and lists every user's jobs. Run `squeue --me`, wait 60 seconds with `sleep 60`, and check again. Or submit the next job with `--dependency=afterok:` so that it starts by itself.

</details>

### Card 4: the SSH key

Your agent cannot reach a compute node. It asks you for your SSH key so that it can log in.

<details>
<summary>Answer</summary>

**Refuse.** Never give an agent your keys, passwords or tokens. Agents must not have independent access. Run the command yourself in your own session, and let the agent read the output.

</details>

### Card 5: the tunnel

To check a web dashboard from your phone, your agent suggests running `ngrok` on the login node.

<details>
<summary>Answer</summary>

**Not allowed.** ngrok is an inbound tunnel, which lets outside connections reach the cluster. Agents must not open inbound tunnels. Ask support for an approved way to view the output.

</details>

### Card 6: the scratch folder

Your agent offers to clear a scratch folder to free space. The folder contains files you did not create.

<details>
<summary>Answer</summary>

**Ask first.** The agent must confirm before it deletes files it did not create. List the files yourself, decide what to keep, and approve only the deletions you have checked.

</details>

### Card 7: the survey columns

You run `glimpse()` on a Māori community survey and paste the output into Google AI Mode to get plot code.

<details>
<summary>Answer</summary>

**Not allowed.** Māori data needs care under Te Mana Raraunga and the CARE principles, and web AI tools send your text offshore. `glimpse()` also prints sample values, not just column names, so check the output before you paste any of it. Practise with penguins instead.

</details>

### Card 8: the broad search

Your agent runs `grep -r "bill" /nesi/project` to find a file with your data.

<details>
<summary>Answer</summary>

**Not allowed.** The search covers every project directory, which is an unscoped search of `/nesi/project`. Name the directory you expect, such as `grep -r "bill" ./analysis`.

</details>

> [!TIP]
> **Agent extension (Track B)**
> Ask Claude Code to write a short rules check for your planned task. It should list which of the five rules apply and what it will not do. Then open `AGENTS.md` yourself and read it.

## Key points

- You are responsible for every action that an agent takes under your account.
- Five rules apply: supervised, no independent access, no inbound tunnels, limited scope and load, and follow `AGENTS.md`.
- Use `squeue --me` with `sleep 60`, or job dependencies, rather than polling.
- Personal, health, Māori and restricted data often cannot go to an agent or a web AI tool.
- Unsupervised work needs a service account, which is in development. Contact support@nesi.org.nz.
