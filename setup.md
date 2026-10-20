# Setup

This page covers everything you install before the workshop: R and RStudio (or Python), Quarto, the packages, and your AI tool. Work through the sections in order. If you follow the Python notes, skip the R sections and use [Set up Python](#set-up-python) instead.

## Install R and RStudio

You need R 4.3.0 or later and RStudio. Install R first, then RStudio.

1. Download R from [CRAN](https://cran.r-project.org/) and install it for your operating system.
2. Download RStudio Desktop from [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/) and install it.

Check your R version. Open RStudio, and in the Console run:

```r
R.version.string
```

The output must show R version 4.3.0 or later. If it does not, install the newer R, then restart RStudio.

If you cannot install software on your computer, use one of these options instead:

- **Posit Cloud** at [posit.cloud](https://posit.cloud), a hosted RStudio that runs in your browser.
- **Your institution's RStudio Server** or Open OnDemand. Ask your IT team for the address and sign-in details.

## Install Quarto

Quarto builds the report in episode 08 ([R](r/08-report.md) · [Python](python/08-report.md)). Recent versions of RStudio include Quarto. If you follow the Python notes without RStudio, install Quarto from [quarto.org](https://quarto.org/docs/get-started/). To check, open the **Terminal** tab in RStudio (or any terminal) and run:

```bash
quarto check
```

The command reports the Quarto version it finds and checks the supporting software. If it reports that Quarto is missing, install it from [quarto.org](https://quarto.org/docs/get-started/), then run `quarto check` again.

## Install the R packages

In the RStudio Console, run:

```r
install.packages(c("tidyverse", "palmerpenguins"))
```

The tidyverse contains the packages you use for data wrangling and plotting. It can take several minutes. Confirm the install with:

```r
library(palmerpenguins)
head(penguins)
```

## Set up Python

Skip this section if you follow the R notes. The Python notes in [python/](python/) need Python 3.10 or later, Jupyter or VS Code, and Quarto.

Check your Python version in a terminal:

```bash
python3 --version
```

On Windows, run `python --version` instead, and use `python` wherever this page says `python3`.

### 1. Create the project folder and a virtual environment

A virtual environment keeps the workshop packages separate from your other projects. Create the `ml103-penguins` folder, then create the environment inside it:

```bash
mkdir ml103-penguins
cd ml103-penguins
python3 -m venv .venv
```

Activate it. Do this every time you open a new terminal for the workshop:

```bash
source .venv/bin/activate          # macOS and Linux
.venv\Scripts\activate             # Windows (Command Prompt or PowerShell)
```

Your prompt now starts with `(.venv)`.

### 2. Install the packages

Copy [python/requirements.txt](python/requirements.txt) from this repository into your `ml103-penguins` folder, then run:

```bash
python -m pip install -r requirements.txt
```

The file lists pandas, numpy, matplotlib, seaborn, statsmodels, scipy, palmerpenguins and jupyter. Confirm the install:

```bash
python -c "from palmerpenguins import load_penguins; print(load_penguins().head())"
```

You see a table of five rows. The first row has the species `Adelie` and the island `Torgersen`.

### 3. Choose an editor

- **Jupyter.** Run `jupyter lab` (or `jupyter notebook`) with the environment active.
- **VS Code.** Install the Python and Jupyter extensions, open the `ml103-penguins` folder, and choose `.venv` as the interpreter (**Python: Select Interpreter** in the Command Palette).

### 4. Check Quarto's Jupyter engine

The Python report in episode 08 renders with Quarto's Jupyter engine. Install Quarto as described in [Install Quarto](#install-quarto), then, with the environment active, run:

```bash
quarto check jupyter
```

The command must find your `.venv` Python and the Jupyter kernel. If it finds a different Python, activate `.venv` and run it again.

## Set up your AI tools

You need one of the two tracks.

### Track A: Google Search AI Mode

Google Search AI Mode needs no sign-in. Open a private window and search at [google.com](https://www.google.com/). Select **AI Mode**. If it is not available, use Duck.ai at [duck.ai](https://duck.ai), or a logged-out ChatGPT at [chatgpt.com](https://chatgpt.com).

### Track B: Claude Code

Track B requires a Claude account with access to Claude Code. Install Claude Code by following the instructions on [Claude Code overview](https://docs.claude.com/en/docs/claude-code/overview). After the install, check that the `claude` command runs:

```bash
claude --version
```

If the command is not found, the install did not add Claude Code to your path. Reopen the terminal and try again, or follow the install steps on the overview page once more.

Track B agents must follow the rules in [episode 02](episodes/02-rules-of-the-road.md). On REANNZ systems, install the rules with the command in that episode.

## Check your setup

Before the workshop starts, confirm each item:

- [ ] R notes only: `R.version.string` reports R 4.3.0 or later.
- [ ] `quarto check` runs without reporting a missing Quarto.
- [ ] `library(palmerpenguins)` and `head(penguins)` run in RStudio.
- [ ] Python notes only: `python3 --version` reports 3.10 or later, the `palmerpenguins` check above prints five rows, and `quarto check jupyter` finds your `.venv`.
- [ ] Your AI tool answers a test question.
