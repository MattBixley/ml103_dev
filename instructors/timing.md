# Timing Plan

The workshop runs for 180 minutes, including one 10-minute break. The table counts elapsed time from the start. Adjust the clock times to suit your session.

| Elapsed | Episode | Minutes | Notes |
|---|---|---|---|
| 00:00 to 00:10 | [00 Welcome and setup](../episodes/00-welcome.md) | 10 | Check that every learner can open RStudio and run `library(tidyverse)`, `library(palmerpenguins)` and `head(penguins)` |
| 00:10 to 00:30 | [01 How LLMs work and AI ethics](../episodes/01-ai-and-ethics.md) | 20 | Discussion, then draft the disclosure statement |
| 00:30 to 00:45 | [02 Rules of the road](../episodes/02-rules-of-the-road.md) | 15 | Scenario cards. Track B learners lead the discussion |
| 00:45 to 00:55 | [03 Anatomy of a good prompt](../episodes/03-prompt-anatomy.md) | 10 | Live demo, see [demo-script.md](demo-script.md) |
| 00:55 to 01:10 | [04 Load and explore penguins](../r/04-explore.md) | 15 | Include the `datasets::penguins` column-name check |
| 01:10 to 01:35 | [05 Wrangle with dplyr](../r/05-wrangle.md) | 25 | The longest episode. Keep the base R cross-check |
| 01:35 to 01:45 | Break | 10 | Check the clock. See the rule for a late break below |
| 01:45 to 02:05 | [06 Visualise with ggplot2](../r/06-visualise.md) | 20 | Learners often lose time on palette and size arguments |
| 02:05 to 02:20 | [07 Statistics](../r/07-statistics.md) | 15 | Focus on Simpson's paradox and reading `summary()`. Tight: the t-test section is optional and the first part to cut if you are running late |
| 02:20 to 02:40 | [08 Assemble the Quarto report](../r/08-report.md) | 20 | Learners reuse the disclosure statement from episode 01 |
| 02:40 to 02:55 | [09 AI for Slurm scripts](../episodes/09-slurm-scripts.md) | 15 | Review task first. Write task only if time allows |
| 02:55 to 03:00 | [10 Verify and wrap up](../episodes/10-verify-wrap-up.md) | 5 | Hand out the human checklist and the next-steps list |

### Absorbing the short additions

The Carpentries-derived additions add about 4 learner minutes in total, and the total stays at 180 minutes:

- **00** (+1 min, tutor not autopilot): absorbed by a quicker AI tool check.
- **01** (+1 min, varying output and the 30-second bias probe): absorbed by trimming the Exercise 2 partner discussion.
- **03** (+1 min, three follow-up prompts): absorbed by showing the follow-ups on screen rather than running each one.
- **05** (+1 to 2 min, quick check): optional when you run late.
- **10**: "Where next" is now a pointer to [resources.md](../resources.md), which frees time for the sticky-note feedback.

## Where to Cut When You Run Late

Cut in this order. Each cut saves time without removing the verification step, which the workshop depends on.

1. **Episode 09, write task.** Set it as homework. Learners still review the flawed script in class.
2. **Episode 07, t-test section.** Keep the `lm()` model and the `summary()` walk-through. Move the t-test to homework.
3. **Episode 02, scenario cards.** Use three of the eight cards, not all eight. Choose Card 1 (the overnight session), Card 2 (the patient records) and Card 4 (the SSH key).
4. **Episode 01, disclosure draft.** Ask learners to write it after the session. Show one example in class.
5. **Episode 05, extra debugging.** Skip the optional debugging step. Keep the base R cross-check.
6. **Episode 08, chunk options.** Give learners the chunk options as a handout.

Do not cut the **Check it** steps in episodes 04, 05, 06 and 08. Learners who skip them produce reports that are not reliable.

**Break rule.** If you are more than 10 minutes behind at the break, shorten the break to 5 minutes. Do not drop a whole episode to make up the time.

**Catch-up rule.** A learner who falls behind copies the checkpoint for the episode they missed from `r/checkpoints/` (Python: `python/checkpoints/`) and carries on. Do not wait for them.

**Episode 10 is fixed.** Keep it to 5 minutes, even if the session runs late. Its checklist is short, so learners can finish it later.
