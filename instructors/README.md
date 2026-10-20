# Instructor Notes

These notes support the instructor running ML103 in a room, with learners on both tracks. Learner content lives in [episodes/](../episodes/), [r/](../r/) and its full Python parallel, [python/](../python/README.md). Learners choose one language; the shared episodes and Slurm scripts cover both. Read [timing.md](timing.md) and [ai-failure-modes.md](ai-failure-modes.md) before the session, and keep [demo-script.md](demo-script.md) open while you teach.

| File | Use it for |
|---|---|
| [timing.md](timing.md) | The minute-by-minute plan, and what to cut when you run late |
| [ai-failure-modes.md](ai-failure-modes.md) | Common AI mistakes with this workshop, and how to turn each into a teaching moment |
| [demo-script.md](demo-script.md) | Live-coding demo for episodes 03 to 08, and how to run Track B alongside it |

## Pre-Workshop Checklist

Complete these steps the day before, and again on the morning if the room or network has changed.

- [ ] **Test Google Search AI Mode signed out.** Open a private window, sign out of any Google account, and connect from an NZ network. Run the Prompt 1 block from episode 04 and the Prompt 2 block from episode 05. Check that each returns code in a single block. If AI Mode cuts code short or gives no code, prepare the fallback in [ai-failure-modes.md](ai-failure-modes.md#truncated-code-in-ai-mode).
- [ ] **Check the backups.** Confirm that Duck.ai and logged-out ChatGPT both load and answer a simple question for Track A learners who cannot use AI Mode.
- [ ] **Check R, Quarto and the packages on a clean machine.** Run these commands in an R session:

  ```r
  R.version.string
  packageVersion("palmerpenguins")
  packageVersion("tidyverse")
  ```

  R must report 4.3.0 or later. Install any missing package with `install.packages(c("tidyverse", "palmerpenguins"))`. In a terminal, run `quarto --version` to confirm that Quarto is on the path.

- [ ] **Check Python, the venv and Quarto's Jupyter engine on a clean machine.** In a terminal:

  ```bash
  python3 --version
  python3 -m venv .venv && source .venv/bin/activate
  python -m pip install -r python/requirements.txt
  quarto check jupyter
  ```

  Python must report 3.10 or later, and `quarto check jupyter` must find the `.venv` Python.

- [ ] **Confirm Track B access.** Each Track B learner has Claude access, and has read [episodes/02-rules-of-the-road.md](../episodes/02-rules-of-the-road.md) before the session.
- [ ] **Install the REANNZ agent rules on Mahuika.** If learners work on Mahuika, install the rules with `/opt/nesi/share/mahuika-agents/install.sh` and the `--project DIR` option for each project folder. Add `--skills` if you want the skills as well. Source: [github.com/nesi/mahuika-agents](https://github.com/nesi/mahuika-agents).
- [ ] **Check the catch-up checkpoints.** In a fresh R session for each file, run `r/checkpoints/after-04.R`, `after-05.R`, `after-06.R`, `after-07.R` and `after-08.qmd`. Do the same for the files in `python/checkpoints/`, each in a fresh Python session with `.venv` active. Each file must run without help. Learners rely on them to catch up.
- [ ] **Check the Python Slurm scripts.** If learners use Mahuika, run `module spider Python` and confirm that the version in `slurm/run_analysis_py.sl` and `slurm/render_report_py.sl` still exists.
- [ ] **Print or share the references.** Make the schedule in [timing.md](timing.md) and the failure list in [ai-failure-modes.md](ai-failure-modes.md) available to you on paper or on a second screen.

## Helpers

Helpers support learners at their desks. These habits are adapted from [GenAI in Workshops: Instructor Training Bonus Module](https://carpentries.github.io/instructor-training-genai/feedback.html).

- Ask what the learner tried before they asked the AI.
- If a learner's AI answer differs from the one on the projector, compare the two aloud. AI output varies, so a different answer is not a wrong answer.
- Watch for signs of pasted code the learner has not read: functions not yet taught, heavy comments on every line, or a learner who cannot explain a line.
- Note the common AI mistakes you see, and pass them to the instructor to share with the room.
