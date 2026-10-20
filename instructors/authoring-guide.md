# Authoring guide (contract for all ML103 content)

Read `PLAN.md` first. This file fixes the conventions every episode must share.

## Language and tone

- NZ English spelling (organise, colour, behaviour). Use te reo Māori where natural
  (Aotearoa New Zealand), with correct macrons.
- Plain, direct and active voice. Address the learner as "you". No marketing language.
- Assume a researcher who knows base R, data frames and basic ggplot2 (GA
  Introduction to R), but has not used pipes, dplyr or Quarto.
- Tool-agnostic: say "your AI assistant". Track A demos use Google Search AI Mode.
  Never claim a specific AI response. AI output varies, so describe *typical* failure
  patterns ("often…", "may…").

## Markdown

Plain GitHub-flavoured Markdown only. No Jekyll/Workbench/Quarto-site syntax.
Callouts use GitHub alerts:

```markdown
> [!NOTE]
> Background info.

> [!TIP]
> Helpful hint.

> [!WARNING]
> Data safety / policy warning.
```

## Episode template (exact headings, in this order)

```markdown
# NN. Title

**Time:** NN min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- …

**Objectives**
- …

## <Task section, repeat as needed>

### Prompt 1: the quick version

```text
<weak prompt exactly as a learner might type it>
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- …

### Prompt 2: a better version

```text
<better prompt>
```

| Part of the prompt | What it fixes |
|---|---|
| … | … |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool] · **Date tested:** [YYYY-MM-DD]

**Code returned:** <code block>

**Output when run:** <text block>

**Notes:** [What worked, what needed fixing]

</details>

### Check it

<Concrete verification task: compare with base R, count rows, inspect a value…>

<details>
<summary>Reference solution</summary>

```r
# instructor-verified code
```

</details>

> [!TIP]
> **Agent extension (Track B)**
> <The same task as an agent task with acceptance criteria. The learner approves
> each action.>

## Key points

- …
```

Shared (language-agnostic) episodes may drop the prompt-pair sections where they do
not apply (01, 02, 10), but keep the header block and Key points.

## Shared R project contract (episodes 04 to 09 depend on these names)

- Project folder: `ml103-penguins/` (an RStudio Project, `ml103-penguins.Rproj`)
- Data: `palmerpenguins::penguins` (canonical). Mention base R 4.5
  `datasets::penguins` (short names `bill_len`, `bill_dep`, `flipper_len`,
  `body_mass`) only as the hallucination check in episode 04.
- Style: tidyverse, native pipe `|>`, R ≥ 4.3, `library(tidyverse)` +
  `library(palmerpenguins)`. ggplot2 `linewidth=` not `size=` for lines.
- Working script: `analysis.R` (episodes 04 to 07). Report: `penguins_report.qmd`
  (episode 08), rendered with `quarto render penguins_report.qmd` to HTML.
- Objects:
  - `penguins_clean`: rows with missing `sex` removed (the 11 incomplete rows, which
    include the 2 rows with missing measurements), plus column `body_mass_kg`
  - `species_summary`: n, mean and sd of bill length, flipper length and body mass by
    species
  - `p_bill`: bill length vs depth scatter, coloured by species, + per-species `lm`
    lines
  - `p_mass`: body mass by species, boxplot + jittered points, faceted or filled by sex
  - `mass_model <- lm(body_mass_g ~ species, data = penguins_clean)`
- Figures saved to `figures/` with `ggsave(width = 7, height = 5, dpi = 300)`.
- Checkpoints: `r/checkpoints/after-04.R` … `after-07.R`, `after-08.qmd`. Each file
  runs on its own from a fresh session.

## Python equivalents (later port)

`python/` mirrors `r/` with pandas, seaborn and statsmodels: `analysis.py`,
`penguins_report.qmd` (Jupyter engine), and the same object names in snake_case.

## Files are owned by one writer

Do not edit files outside your assigned list. If you need something from another
area, write it in your final report.

## Example AI output sections

Every better prompt that generates code is followed by a collapsed
"Example AI output (instructor testing)" block. These hold real results from an
instructor's own run of the prompt. To update one, find the
`<!-- example-output -->` marker (`grep -rn "example-output" r python episodes`),
paste the tool, date, code and console output, and add notes. Keep the
"Reference solution" separate: that is verified code, while the example shows
what an AI actually returned.
