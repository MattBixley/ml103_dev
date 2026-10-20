# 08. Assemble the Quarto Report

**Time:** 20 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do I turn `analysis.R` into a report that anyone can re-run?
- What goes in an AI-use statement?

**Objectives**
- Create `penguins_report.qmd` from the code in `analysis.R`, with a section
  skeleton you choose.
- Render it to a single HTML file with `quarto render penguins_report.qmd`.
- Add a Limitations section, an AI-use statement and `sessionInfo()`.

## What a Quarto Report Is

A Quarto document (`.qmd`) mixes text written in Markdown with R code chunks.
When you render it, Quarto starts a **fresh R session**, runs every chunk from
top to bottom and writes an HTML file with your text, code, tables and
figures. Objects in your RStudio Environment do not exist in that session, so
the report must load the packages and create every object itself.

In RStudio: *File > New File > Quarto Document*, untick "Use visual markdown
editor", and save it as `penguins_report.qmd` in your project folder.

## Build the Report

### Prompt 1: the quick version

```text
write a report about the penguins data
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **Prose instead of a document.** You get an essay about penguins with
  invented numbers, not a `.qmd` file that computes them.
- **R Markdown header in a Quarto file.** `output: html_document` is R Markdown.
  Quarto uses `format: html`. Old answers also use `self-contained: true`,
  which Quarto replaced with `embed-resources: true`.
- **Objects that do not exist at render time.** Chunks use `penguins_clean`
  or `p_bill` without creating them, because they existed in your Environment.
  The render fails with `object 'penguins_clean' not found`.
- **Things that should never be in a report:** `install.packages()`,
  `setwd("C:/Users/...")` or `rm(list = ls())`.
- **Hard-coded numbers in the text** ("344 penguins") that go out of date
  when the data change. Inline R code, such as `` `r nrow(penguins)` ``, keeps
  them correct.
- **Old chunk options** (`{r, echo=FALSE}`) mixed with Quarto's `#|` options.
  Both work in Quarto; mixing them makes the file harder to read.

### Prompt 2: a better version

```text
I have an R script analysis.R (tidyverse, palmerpenguins, native pipe |>) that
creates penguins_clean, species_summary, p_bill, p_mass and
mass_model <- lm(body_mass_g ~ species, data = penguins_clean).
Here is the script:

<paste analysis.R>

Turn it into a Quarto document penguins_report.qmd that renders to HTML with
`quarto render penguins_report.qmd`.
- YAML header: title, author, date: today, format: html with
  embed-resources: true, code-fold: true and toc: true
- A setup chunk that loads the packages (message: false)
- Sections: Introduction and data source; Data cleaning; Summary tables
  (by species, island and sex, using knitr::kable); Figures; Simple comparison
  (overall vs per-species slopes, mass_model); Limitations; AI-use statement;
  Session information (sessionInfo())
- Use Quarto #| chunk options with labels, figure captions and fig-width: 7,
  fig-height: 5
- Create every object inside the document. No install.packages(), setwd() or
  rm(list = ls()).
- Use inline R code for every number in the text.
Leave the Limitations and AI-use statement sections as headings with a
placeholder sentence: I will write those myself.
```

| Part of the prompt | What it fixes |
|---|---|
| Pasted `analysis.R` and the object names | The AI reuses your checked code, not new code |
| `quarto render penguins_report.qmd` and `format: html` | A Quarto file, not R Markdown |
| `embed-resources: true` | One HTML file you can email or upload, with figures inside it |
| `code-fold: true` | Readers see results first; code is one click away |
| The section list | Your report structure, not the AI's |
| `Create every object inside the document` | The report renders in a fresh session |
| `inline R code for every number` | Numbers in the text match the data |
| `I will write those myself` | The judgement sections stay yours |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

````markdown
---
title: "Palmer penguins report"
author: "Your Name"
date: today
format:
  html:
    embed-resources: true
    code-fold: true
    toc: true
---

```{r}
#| label: setup
#| message: false
library(tidyverse)
library(palmerpenguins)
```

## Introduction and data source

The data come from the palmerpenguins package (`r nrow(penguins)` penguins).

## Data cleaning

```{r}
#| label: clean
penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)
```

We removed `r nrow(penguins) - nrow(penguins_clean)` rows with missing sex,
leaving `r nrow(penguins_clean)` penguins.

## Limitations

*I will write this section myself.*

## AI-use statement

*I will write this section myself.*

## Session information

```{r}
#| label: session-info
sessionInfo()
```
````

**Output when run:**

```text
metadata
  document-css: false
  link-citations: true
  date-format: long
  lang: en
  title: Palmer penguins report
  author: Your Name
  date: today

Output created: penguins_report.html
```

**Notes:** Rendered first time with no errors and no `penguins_report_files/` folder. Shortened here: the full answer also had Summary tables, Figures and Simple comparison sections.

</details>

### Write the Limitations and AI-use statement yourself

**Limitations.** Use what you found in episode 07. At minimum: the data are
observational; species and island are confounded (Chinstrap only on Dream,
Gentoo only on Biscoe); the body mass model ignores sex; which rows you removed
and why; which assumptions you did not check. If you left out an analysis
because you could not explain it, say so here.

Also ask: could more data change this conclusion, or is it variation that more
data would not remove
([Carpentries: FAIR explainable ML](https://carpentries-incubator.github.io/fair-explainable-ml/6-uncertainty-overview.html))?

**Describe the data.** Datasheets and model cards
([Carpentries: FAIR explainable ML](https://carpentries-incubator.github.io/fair-explainable-ml/8-releasing-a-model.html))
ask the same four things your report should answer:

- [ ] Where the data came from (citation and licence)
- [ ] Who or what it covers, and what it leaves out
- [ ] Which rows you removed, and why
- [ ] Known biases or gaps

**AI-use statement.** Use the statement you drafted in episode 01:

```text
Generative AI tools were used in this analysis. [Tool name and version, and
date accessed] was used to [task, for example: draft R code for data cleaning,
summary tables, figures and the linear model]. All AI-generated code was run,
read and checked against [method, for example: base R results and row counts]
by the author, who takes responsibility for the final content. Prompts used
are recorded in [file or appendix]. No sensitive or identifiable data was
entered into any AI tool.
```

If you used an agent (Track B), add one sentence:

```text
An AI agent ([tool name and version]) read files, edited code and ran commands
in the project folder; the author approved each action.
```

Edit it so it is true for you: name the actual tool, version and date, and list
what you actually used it for.

### Render it

In the RStudio Terminal (not the Console), from your project folder:

```bash
quarto render penguins_report.qmd
```

Or click **Render** in RStudio. Quarto writes `penguins_report.html` next to
the `.qmd`. Open it in your browser.

> [!NOTE]
> **R Markdown fallback.** If Quarto is not installed, save the file as
> `penguins_report.Rmd`, change the header to
> `output: html_document` with `self_contained: true` and `code_folding: hide`,
> replace `date: today` with ``date: "`r Sys.Date()`"``, and render with
> `rmarkdown::render("penguins_report.Rmd")` in the Console. The chunks and
> text stay the same. Remove the `@fig-` cross-references, which R Markdown
> does not support.

### Check it

- **Fresh session.** Restart R (*Session > Restart R*), clear the Environment
  and render again. If it still renders, the report does not depend on objects
  you created by hand.
- **Numbers match.** The Data cleaning section should say 11 rows removed and
  333 rows left. The species table should match `species_summary` from
  `analysis.R`. The Simple comparison should report an overall slope of −0.082.
- **One file.** There should be no `penguins_report_files/` folder next to the
  HTML. If there is, `embed-resources: true` is missing or mis-indented.
- **Every section present**, including Limitations, the AI-use statement and
  the `sessionInfo()` output at the end.
- **Read your Limitations aloud.** Can you explain every number and model in
  the report? If not, take it out or say why it is uncertain.

<details>
<summary>Reference solution</summary>

The full reference report is in
[`solutions/penguins_report.qmd`](solutions/penguins_report.qmd) (also
[`checkpoints/after-08.qmd`](checkpoints/after-08.qmd)). Its header and the
start of the body:

````markdown
---
title: "Body size of Palmer penguins"
author: "Your Name"
date: today
format:
  html:
    embed-resources: true
    code-fold: true
    toc: true
---

```{r}
#| label: setup
#| message: false

library(tidyverse)
library(palmerpenguins)
```

## Introduction and data source

... the `palmerpenguins` R package, which has `r nrow(penguins)` rows ...

## Data cleaning

```{r}
#| label: clean

penguins_clean <- penguins |>
  filter(!is.na(sex)) |>
  mutate(body_mass_kg = body_mass_g / 1000)
```
````

The report ends with:

````markdown
## Session information

```{r}
#| label: session-info
#| code-fold: false

sessionInfo()
```
````

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Create penguins_report.qmd from analysis.R with the YAML header and section
> list in episode 08. Render it with `quarto render penguins_report.qmd`, read
> any errors, fix them and render again. Acceptance: the render finishes with
> no errors or warnings; no penguins_report_files/ folder; every number in the
> text comes from inline R code; the Limitations and AI-use statement sections
> contain only a placeholder. Then review the rendered report against
> analysis.R and list any number that differs.
> ```
>
> Write the Limitations and AI-use statement yourself, and approve each edit
> and each render. Add the agent sentence from episode 01 to your AI-use
> statement: "An AI agent ([tool name and version]) read files, edited code and
> ran commands in the project folder; the author approved each action."

## Key points

- Quarto renders in a fresh R session, so the report must create every object it uses.
- Specify the YAML header (`format: html`, `embed-resources: true`,
  `code-fold: true`) and the section list in your prompt.
- Use inline R code for numbers in the text.
- Write the Limitations and AI-use statement yourself. End with `sessionInfo()`.
- Render with `quarto render penguins_report.qmd`.
