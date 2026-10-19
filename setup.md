# Setup

This page covers everything you install before the workshop: R and RStudio, Quarto, the R packages, optional Python tools, and your AI tool. Work through the sections in order.

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

Quarto builds the report in [episode 08](r/08-report.md). Recent versions of RStudio include Quarto. To check, open the **Terminal** tab in RStudio and run:

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

## Optional: set up Python

Skip this section if you follow the R notes. If you follow the Python notes in `python/`, you need Python 3.10 or later.

Check your Python version in a terminal:

```bash
python3 --version
```

On Windows, run `python --version` instead. Then install the packages:

```bash
pip install pandas seaborn statsmodels palmerpenguins jupyter
```

Use a virtual environment if you already have other projects that depend on these packages.

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

- [ ] `R.version.string` reports R 4.3.0 or later.
- [ ] `quarto check` runs without reporting a missing Quarto.
- [ ] `library(palmerpenguins)` and `head(penguins)` run in RStudio.
- [ ] Your AI tool answers a test question.
