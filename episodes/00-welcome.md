# 00. Welcome and Setup

**Time:** 10 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- What will you build in this workshop?
- Which AI tool do you use, and how do you set up your project?

**Objectives**
- Create the `ml103-penguins` RStudio Project and install the two packages you need.
- Open your AI tool and confirm it answers a test question.
- Know the three-hour schedule and where the break falls.

## What you will build

In this workshop, you use a generative AI assistant to write a complete, reproducible analysis of the penguins dataset. You load and clean the data, make plots, run a basic statistical test, assemble a Quarto report, and write a Slurm job script. Slurm is the scheduler that runs jobs on a shared computing cluster.

The goal is not to let the AI do the work for you. The goal is to judge what it produces, check it, and say how you used it.

Python learners: episodes 04 to 08 have a full Python version in [python/](../python/README.md), with pandas, seaborn and statsmodels. The welcome (00) and the shared episodes (01, 02, 03, 09 and 10) apply to both languages. Where this page says RStudio, use Jupyter or VS Code, and follow the Python steps under [Set up your project](#set-up-your-project).

## Two tracks, one room

You work in one of two tracks. Both tracks run the same episodes at the same time.

| | Track A: web AI | Track B: agents |
|---|---|---|
| Tool | Google Search AI Mode, signed out | Claude Code, in the RStudio Terminal (Python: any terminal in the project folder) |
| What you do | Copy code from the AI, paste it into RStudio (or Jupyter or VS Code), run it, check it | Approve each action while the agent reads your project and runs R or Python |
| What the AI sees | Only what you paste | Every file in the project folder |

Every episode from 04 onwards has an **Agent extension** callout for Track B.

> [!TIP]
> Test Google AI Mode in a private window before the session starts. Private windows are signed out, so your answers are not linked to your account. If AI Mode does not answer, use Duck.ai (https://duck.ai), then a logged-out ChatGPT (https://chatgpt.com).

## The three-hour schedule

| Episode | Topic | Minutes | Starts at minute |
|---|---|---|---|
| 00 | Welcome and setup | 10 | 0 |
| 01 | How LLMs work and AI ethics | 20 | 10 |
| 02 | Rules of the road | 15 | 30 |
| 03 | Anatomy of a good prompt | 10 | 45 |
| 04 | Load and explore penguins | 15 | 55 |
| 05 | Wrangle with dplyr | 25 | 70 |
| | Break | 10 | 95 |
| 06 | Visualise with ggplot2 | 20 | 105 |
| 07 | Statistics: code you can run but do not understand | 15 | 125 |
| 08 | Assemble the Quarto report and AI-use statement | 20 | 140 |
| 09 | AI for Slurm scripts | 15 | 160 |
| 10 | Verify and wrap-up | 5 | 175 |

## Set up your project

<!-- tabs -->

#### R

**1. Create the RStudio Project**

1. Open RStudio.
2. Choose **File** > **New Project** > **New Directory** > **New Project**.
3. Type `ml103-penguins` in the **Directory name** box.
4. Choose where to save the folder, then select **Create Project**.

RStudio opens the project. The Files pane shows `ml103-penguins.Rproj`.

**2. Install the packages**

In the Console, run:

```r
install.packages(c("tidyverse", "palmerpenguins"))
```

Installing the tidyverse can take several minutes. Wait for the `>` prompt to return before you continue.

**3. Run the quick check**

```r
library(palmerpenguins)
head(penguins)
```

You see a table of six rows and eight columns. The first row has the species `Adelie` and the island `Torgersen`.

If you see `there is no package called 'palmerpenguins'`, run the `install.packages()` line again and read any red errors in the Console. If your R version is older than 4.3, follow [setup.md](../setup.md) to update R.

#### Python

Follow [Set up Python](../setup.md#set-up-python). In short, in a terminal:

```bash
mkdir ml103-penguins
cd ml103-penguins
python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate
python -m pip install -r requirements.txt  # a copy of python/requirements.txt
python -c "from palmerpenguins import load_penguins; print(load_penguins().head())"
```

You see a table of five rows. The first row has the species `Adelie` and the island `Torgersen`. Then open the folder in Jupyter or VS Code, with `.venv` as the interpreter.

<!-- /tabs -->

## Open your AI tool

### Track A: Google Search AI Mode

<!-- tabs -->

#### R

1. Open a private window and go to https://www.google.com.
2. Search for `what is ggplot2 in R`.
3. Select **AI Mode**, then ask: `Write R code that prints the first six rows of palmerpenguins::penguins.`

#### Python

1. Open a private window and go to https://www.google.com.
2. Search for `what is seaborn in Python`.
3. Select **AI Mode**, then ask: `Write Python code that loads the penguins data with the palmerpenguins package and prints the first five rows.`

<!-- /tabs -->

If AI Mode returns code, you are ready for Track A.

### Track B: Claude Code

<!-- tabs -->

#### R

1. In RStudio, open the **Terminal** tab next to the Console. The Terminal opens in your project folder.
2. Run `claude` and follow the sign-in prompts.
3. Ask: `What files are in this project?` Approve any action the agent asks you to take.

#### Python

1. Open a terminal in the `ml103-penguins` folder (in VS Code, **Terminal** > **New Terminal**).
2. Run `claude` and follow the sign-in prompts.
3. Ask: `What files are in this project?` Approve any action the agent asks you to take.

<!-- /tabs -->

If the Terminal reports `claude: command not found`, follow the Claude Code section of [setup.md](../setup.md).

> [!WARNING]
> **Track B:** the project folder is the agent's workspace. Keep only data that you are allowed to share with an agent in that folder. [Episode 02](02-rules-of-the-road.md) explains why.

> [!TIP]
> **Agent extension (Track B)**
> Ask the agent to list the packages it can see in your project, then ask it to run `library(palmerpenguins)` (Python: `python -c "import palmerpenguins"` with `.venv` active) and report the result. You approve each command before it runs.

## Key points

- You use the `ml103-penguins` project for every episode from 04 onwards.
- Track A uses Google Search AI Mode in a private window, with Duck.ai and a logged-out ChatGPT as backups.
- Track B uses Claude Code in the RStudio Terminal (or any terminal, for Python), and you approve each action.
- Python learners follow [python/](../python/README.md) for episodes 04 to 08.
- The break falls at minute 95.
