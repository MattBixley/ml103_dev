# 10. Verify and Wrap-Up

**Time:** 5 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- How do you know that the AI's output is correct?
- What do you do next?

**Objectives**
- Work through the verification checklist for your report.
- Find the next resource for the skill you want to build.

## Verification checklist

Before you submit or share your analysis, tick each item. If you cannot tick an item, go back and fix it.

- [ ] The code runs from a clean session. Use **Session** > **Restart R**, then run the script from the top. Python: restart the kernel and run all cells, or run `python analysis.py` in a fresh terminal with `.venv` active.
- [ ] The row counts are what you expect. The raw data has 344 penguins, and every count after a filter or join matches what you can explain.
- [ ] Every column name exists in the data. Check with `names(penguins)` (Python: `penguins.columns`).
- [ ] You can explain what each line of code does, without reading the AI's explanation again.
- [ ] You can explain each part of the statistical output, including the assumptions it makes.
- [ ] Your report includes the AI-use statement from [episode 01](01-ai-and-ethics.md).
- [ ] You did not paste any sensitive data into an AI tool.
- [ ] You allocated your rigour: most of your checking effort went on filters, joins and statistics, and less on plot styling (adapted from [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/06-validation.html)).

## Where next

For books, documentation and courses, see [Resources and References](../resources.md).

To keep practising, ask your AI assistant for exercises rather than answers (adapted from [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/04-learning-concepts.html)):

```text
Give me three short exercises on dplyr using the penguins data. Give hints only, no answers unless I say I give up.
```

Python: replace "dplyr" with "pandas".

## Give feedback

On a sticky note, write one thing the AI got wrong today and how you caught it. Give it to your instructor, along with what worked and what did not. If you are working through these notes on your own, open an issue at https://github.com/MattBixley/ml103_dev/issues with the same note, plus which step took the longest. That feedback improves the next version (adapted from [GenAI in Workshops: Instructor Training Bonus Module](https://carpentries.github.io/instructor-training-genai/feedback.html)).

> [!TIP]
> **Agent extension (Track B)**
> Ask the agent to run the verification checklist on your project. For each item, the agent reports pass or fail, with the command it ran and the output it saw. Read the evidence before you accept a pass.

## Key points

- Verify every analysis from a clean session, check the row counts and column names, and explain each line.
- Include the AI-use statement, and confirm that no sensitive data went into an AI tool.
- You are ready to explain, check and report AI-assisted R or Python code, and to show a reader how you verified it.
