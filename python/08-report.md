# 08. Assemble the Quarto Report

**Time:** 20 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do I turn `analysis.py` into a report that anyone can re-run?
- What goes in an AI-use statement?

**Objectives**
- Create `penguins_report.qmd` from the code in `analysis.py`, with a section
  skeleton you choose.
- Render it to a single HTML file with `quarto render penguins_report.qmd`.
- Add a Limitations section, an AI-use statement and the Python and package
  versions.

## What a Quarto Report Is

A Quarto document (`.qmd`) mixes text written in Markdown with Python code
cells. The line `jupyter: python3` in its header tells Quarto to use the
Jupyter engine. When you render it, Quarto starts a **fresh Python kernel**,
runs every cell from top to bottom and writes an HTML file with your text,
code, tables and figures. Variables from your terminal or VS Code session do
not exist in that kernel, so the report must import the packages and create
every object itself.

Quarto has to find the Python that has your packages. Activate the `.venv`
environment before you render (`source .venv/bin/activate`, or
`.venv\Scripts\activate` on Windows) and run `quarto check jupyter`. It
should report the Python inside `.venv`. If it reports another one, set the
`QUARTO_PYTHON` environment variable to the full path of `.venv`'s Python.

In VS Code, install the Quarto extension, then create a new file and save it
as `penguins_report.qmd` in your project folder.

## Build the Report

### Prompt 1: the quick version

```text
write a report about the penguins data
```

Try it in your AI assistant before reading on.

### What typically goes wrong

- **Prose instead of a document.** You get an essay about penguins with
  invented numbers, not a `.qmd` file that computes them.
- **The wrong kind of file.** Answers may give a Jupyter notebook as JSON, an
  R Markdown header (`output: html_document`) or R chunks (```` ```{r} ````).
  A plain ```` ```python ```` fence, without the braces, is shown as text and
  never run. Quarto runs ```` ```{python} ```` cells. Old answers also use
  `self-contained: true`, which Quarto replaced with `embed-resources: true`.
- **Objects that do not exist at render time.** Cells use `penguins_clean`
  or `p_bill` without creating them, because they existed in your session.
  The render fails with `NameError: name 'penguins_clean' is not defined`.
- **The wrong Python.** The render stops with
  `ModuleNotFoundError: No module named 'palmerpenguins'` because Quarto found
  a Python without your packages. See the note on `quarto check jupyter` above.
- **Things that should never be in a report:** `!pip install` or
  `%pip install`, `os.chdir("C:/Users/...")` or `%reset -f`.
- **Hard-coded numbers in the text** ("344 penguins") that go out of date
  when the data change. Inline Python expressions, such as
  `` `{python} len(penguins)` ``, keep them correct (Quarto 1.4 or later).
  With numpy 2, a raw result can appear as `np.float64(-0.082)`; wrap it in
  `float()` or `round()` first.
- **Figures shown twice.** Ending a cell with the figure object (`p_bill`)
  after drawing it shows the plot twice. End figure cells with `plt.show()`.
- **R-style cell options** (`{python, echo=FALSE}`) mixed with Quarto's `#|`
  options. Mixing them makes the file harder to read. Use `#|` options, such
  as `#| echo: false`, at the top of each cell.

### Prompt 2: a better version

```text
I have a Python script analysis.py (pandas, seaborn, matplotlib, statsmodels,
palmerpenguins) that creates penguins, penguins_clean, species_summary,
p_bill, p_mass and
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit().
Here is the script:

<paste analysis.py>

Turn it into a Quarto document penguins_report.qmd that renders to HTML with
`quarto render penguins_report.qmd` using the Jupyter engine.
- YAML header: title, author, date: today, jupyter: python3, format: html
  with embed-resources: true, code-fold: true and toc: true
- A setup cell that imports the packages and loads the data
- Sections: Introduction and data source; Data cleaning; Summary tables
  (by species, island and sex, shown as data frames); Figures; Simple
  comparison (overall vs per-species slopes, mass_model); Limitations;
  AI-use statement; Session information (Python and package versions)
- Use ```{python} cells with Quarto #| options: labels, figure captions and
  table captions. Keep figsize=(7, 5) and end each figure cell with plt.show().
- Create every object inside the document. No pip install, os.chdir() or
  %reset.
- Use inline `{python}` expressions for every number in the text, rounded
  with round().
Leave the Limitations and AI-use statement sections as headings with a
placeholder sentence: I will write those myself.
```

| Part of the prompt | What it fixes |
|---|---|
| Pasted `analysis.py` and the object names | The AI reuses your checked code, not new code |
| `quarto render`, `jupyter: python3` and ```` ```{python} ```` cells | A Quarto file that runs Python, not R Markdown or a notebook |
| `embed-resources: true` | One HTML file you can email or upload, with figures inside it |
| `code-fold: true` | Readers see results first; code is one click away |
| The section list | Your report structure, not the AI's |
| `end each figure cell with plt.show()` | Each figure appears once |
| `Create every object inside the document` | The report renders in a fresh kernel |
| `inline {python} expressions for every number` | Numbers in the text match the data |
| `I will write those myself` | The judgement sections stay yours |

<!-- example-output: replace with your own test results -->
<details>
<summary>Example AI output (instructor testing)</summary>

**Tool:** [AI tool, e.g. Google Search AI Mode] · **Date tested:** [YYYY-MM-DD]

**Code returned:**

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
jupyter: python3
---

```{python}
#| label: setup
import pandas as pd
import statsmodels.formula.api as smf
from palmerpenguins import load_penguins

penguins = load_penguins()
penguins_clean = penguins.dropna(subset=["sex"])
mass_model = smf.ols("body_mass_g ~ species", data=penguins_clean).fit()
```

## Data cleaning

We removed `{python} len(penguins) - len(penguins_clean)` rows with missing sex,
leaving `{python} len(penguins_clean)` penguins.

## Limitations

I will write this section myself.

## AI-use statement

I will write this section myself.
````

**Output when run:**

```text
Starting python3 kernel...Done

Executing 'penguins_report.quarto_ipynb'
  Cell 1/1: 'setup'...Done

...

Output created: penguins_report.html
```

**Notes:** [What worked, what needed fixing, anything worth showing learners]

</details>

### Write the Limitations and AI-use statement yourself

**Limitations.** Use what you found in episode 07. At minimum: the data are
observational; species and island are confounded (Chinstrap only on Dream,
Gentoo only on Biscoe); the body mass model ignores sex; which rows you removed
and why; which assumptions you did not check. If you left out an analysis
because you could not explain it, say so here.

**AI-use statement.** Use the statement you drafted in episode 01:

```text
Generative AI tools were used in this analysis. [Tool name and version, and
date accessed] was used to [task, for example: draft Python code for data
cleaning, summary tables, figures and the linear model]. All AI-generated code
was run, read and checked against [method, for example: plain pandas results
and row counts] by the author, who takes responsibility for the final content.
Prompts used are recorded in [file or appendix]. No sensitive or identifiable
data was entered into any AI tool.
```

If you used an agent (Track B), add one sentence:

```text
An AI agent ([tool name and version]) read files, edited code and ran commands
in the project folder; the author approved each action.
```

Edit it so it is true for you: name the actual tool, version and date, and list
what you actually used it for.

### Render it

In a terminal, from your project folder, with `.venv` active:

```bash
quarto render penguins_report.qmd
```

Or click **Render** in VS Code with the Quarto extension. Quarto writes
`penguins_report.html` next to the `.qmd`. Open it in your browser.

ipykernel 7 prints
`[IPKernelApp] WARNING | Kernel is running over TCP without encryption`
when Quarto starts the kernel. It refers to the local link between Quarto and
the kernel on your own machine and does not stop the render.

> [!NOTE]
> **Notebook fallback.** If Quarto is not installed, put the same cells in a
> Jupyter notebook, `penguins_report.ipynb`, with the text in Markdown cells.
> Render it with
> `jupyter nbconvert --to html --execute --embed-images penguins_report.ipynb`.
> Inline `{python}` expressions and `@fig-` cross-references do not work in a
> notebook: print those numbers from a code cell instead.

### Check it

- **Fresh kernel.** Render again with
  `quarto render penguins_report.qmd --execute-daemon-restart`. If it still
  renders, the report does not depend on objects left over from an earlier run.
- **Numbers match.** The Data cleaning section should say 11 rows removed and
  333 rows left. The species table should match `species_summary` from
  `analysis.py`. The Simple comparison should report an overall slope of −0.082.
- **One file.** There should be no `penguins_report_files/` folder next to the
  HTML. If there is, `embed-resources: true` is missing or mis-indented.
- **Every section present**, including Limitations, the AI-use statement and
  the package versions at the end.
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
jupyter: python3
---

```{python}
#| label: setup

import sys
from importlib.metadata import version

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import statsmodels.api as sm
import statsmodels.formula.api as smf
from palmerpenguins import load_penguins

penguins = load_penguins()
```

## Introduction and data source

... the `palmerpenguins` Python package, which has `{python} len(penguins)` rows ...

## Data cleaning

```{python}
#| label: clean

penguins_clean = (
    penguins
    .dropna(subset=["sex"])
    .assign(body_mass_kg=lambda df: df["body_mass_g"] / 1000)
)
```
````

The report ends with:

````markdown
## Session information

```{python}
#| label: session-info
#| code-fold: false

print(f"Python {sys.version}")
for package in ["pandas", "numpy", "seaborn", "matplotlib", "statsmodels",
                "scipy", "palmerpenguins"]:
    print(f"{package} {version(package)}")
```
````

</details>

> [!TIP]
> **Agent extension (Track B)**
> ```text
> Create penguins_report.qmd from analysis.py with the YAML header and section
> list in episode 08. Render it with `quarto render penguins_report.qmd`, read
> any errors, fix them and render again. Acceptance: the render finishes with
> no errors and no Python warnings; no penguins_report_files/ folder; every
> number in the text comes from an inline {python} expression and none shows
> as np.float64(...); the Limitations and AI-use statement sections contain
> only a placeholder. Then review the rendered report against analysis.py and
> list any number that differs.
> ```
>
> Write the Limitations and AI-use statement yourself, and approve each edit
> and each render. Add the agent sentence from episode 01 to your AI-use
> statement: "An AI agent ([tool name and version]) read files, edited code and
> ran commands in the project folder; the author approved each action."

## Key points

- Quarto renders in a fresh Python kernel, so the report must import every
  package and create every object it uses.
- Specify the YAML header (`jupyter: python3`, `format: html`,
  `embed-resources: true`, `code-fold: true`) and the section list in your prompt.
- Use inline `{python}` expressions for numbers in the text.
- Write the Limitations and AI-use statement yourself. End with the Python and
  package versions.
- Render with `quarto render penguins_report.qmd`, with `.venv` active.
