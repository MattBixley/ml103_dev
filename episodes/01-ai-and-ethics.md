# 01. AI and Ethics in Research

**Time:** 20 min · **Track A** (web AI) and **Track B** (agents)

**Questions**
- Why does an AI assistant produce confident code that is wrong?
- Which data must you keep out of a web AI tool, and why?
- How do you disclose AI use in research?

**Objectives**
- Recognise the three typical kinds of invented code: a function, an argument and a column name.
- Name the kinds of data you must not paste into a web AI tool.
- Draft an AI-use disclosure statement that you reuse in episode 08 (R: [r/08-report.md](../r/08-report.md) · Python: [python/08-report.md](../python/08-report.md)).

## How a language model writes text

A large language model (LLM) predicts the next token, a short chunk of text such as a word or part of a word, from the text that came before it. It does not look up facts, and it does not run your code. A response reads as fluent because the model learned which words usually follow which, not because it checked them.

The model also samples its next token, so the same prompt can give different code each time. Compare your answer with a neighbour's, and check your own answer rather than copying the instructor's (adapted from [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/02-effective-prompting.html)).

This explains the most common failure. The model writes a plausible R function even when no such function exists. Researchers call this a hallucination. Three typical forms:

- **An invented function.** For example, `penguin_sex_ratio()`, which no package exports.
- **A real function with wrong arguments.** For example, a `geom_point()` call that passes an argument the function does not accept.
- **A made-up column name.** For example, `bill_len`, when `palmerpenguins::penguins` (and Python's `load_penguins()`) uses `bill_length_mm`.

### Exercise 1: test a made-up function

Ask your AI assistant this question. Do not check the answer before you read the response.

```text
Show me how to use penguin_sex_ratio() from the palmerpenguins package to get the proportion of female penguins for each species. Give me a complete example.
```

Try it in your AI assistant before reading on.

Then check the function yourself.

<!-- tabs -->

#### R

In RStudio, run:

```r
library(palmerpenguins)
exists("penguin_sex_ratio")
```

R returns `FALSE`. Then run `help(package = "palmerpenguins")` to see every topic the package documents.

#### Python

Ask the same question with "Python" in place of "R", then run:

```python
import palmerpenguins
print(hasattr(palmerpenguins, "penguin_sex_ratio"))
print([name for name in dir(palmerpenguins) if not name.startswith("_")])
```

The first `print()` shows `False`. The second lists everything the package exports, such as `load_penguins`.

<!-- /tabs -->

Your AI assistant may still give you a confident example. Note which source you trust more: the AI's answer or the package's own index.

## Bias and representativeness

Fluent output is not the same as correct output. The AI reflects patterns in its training data, so it favours common examples and may not notice when your data differs from them.

The penguins data describes 344 penguins from three islands near Palmer Station, Antarctica, collected between 2007 and 2009 (Gorman, Williams and Fraser, 2014). Any result describes these penguins. It does not describe all penguins. Ask yourself what the data cannot tell you before you write a conclusion.

**Quick probe (30 seconds).** Ask your AI assistant `Write one sentence about a typical researcher.` Notice who it assumes the researcher is. The same assumptions can leak into code comments and report text, so read those too (adapted from [Trustworthy AI](https://carpentries-incubator.github.io/fair-explainable-ml/2-model-eval-and-fairness.html)).

## Data sovereignty and privacy

Anything you paste into a web AI tool leaves New Zealand. The model runs at an offshore provider. Do not paste the following into a web AI tool:

- **Māori data**, including data about whānau, hapū, iwi or Māori communities. Māori data sovereignty is set out by [Te Mana Raraunga](https://www.temanararaunga.maori.nz/) and the [CARE principles](https://doi.org/10.5334/dsj-2020-043).
- **Health and personal data**, including any record that identifies a person.
- **Ethics-restricted data**, meaning data covered by an approval that limits sharing.
- **Commercial data**, including data under a confidentiality agreement.

Penguins is safe for this workshop because it is openly licensed and describes animals, not people. Before you paste any other data, ask whether the people it describes would expect it to leave New Zealand.


## Research integrity

Research integrity covers three things:

- **Authorship.** An AI tool cannot be an author. You are responsible for every claim in your work.
- **Disclosure.** Say which tool you used and what it did. You write this statement in Exercise 2.
- **Reproducibility.** Record the prompts you used and the package versions you ran. Episode 08 shows how to record versions (R: [r/08-report.md](../r/08-report.md), with `sessionInfo()` · Python: [python/08-report.md](../python/08-report.md)).

For national guidance, read Royal Society Te Apārangi, *Guidelines for the best practice use of GenAI in research* (June 2025): [PDF](https://www.royalsociety.org.nz/assets/Guidelines-for-the-best-practice-use-of-GenAI-in-research_Royal-Society-Te-Aparangi_June-2025_English-.pdf). Read its section on disclosure before you finalise your statement.

## Licensing, citation and environmental cost

You own the code you publish, so check every line of generated code before you use it. Terms of use differ between AI providers. Read the terms of the tool you used, and cite the tool and version the way your field or journal asks.

Large models use substantial computing power for each response. Use AI where it saves time on work you can check. Do not use it to skip learning the fundamentals you need to judge its output.

## When not to use AI

- When you are learning a skill that you must judge later. Practise first, then use AI to speed up work you already understand.
- When the data is sensitive, as described above.
- When you cannot check the result. If you cannot tell whether the output is correct, you cannot report it.
- When reading feels like learning. An AI explanation can give you an illusion of competence. Type the code, change it, or predict its output yourself (adapted from [Learning to Code with AI Chatbots](https://carpentries-incubator.github.io/coding-with-llms-novice/04-learning-concepts.html)).

### Exercise 2: draft an AI-use disclosure statement

Write a statement of two to four sentences that says what you used AI for in this workshop. Start from the template below, then edit it to match what you did. The square brackets mark the parts you fill in.

```text
Generative AI tools were used in this analysis. [Tool name and version, and date accessed] was used to [task, for example: draft R (or Python) code for data cleaning and suggest plot layouts]. All AI-generated code was run, read and checked against [method, for example: base R (or plain pandas) results and row counts] by the author, who takes responsibility for the final content. Prompts used are recorded in [file or appendix]. No sensitive or identifiable data was entered into any AI tool.
```

If you used an agent (Track B), add one sentence:

```text
An AI agent ([tool name and version]) read files, edited code and ran commands in the project folder; the author approved each action.
```

Swap statements with a partner. Ask whether a reader could repeat what you did from your statement alone. If not, add the missing detail.

> [!TIP]
> **Agent extension (Track B)**
> Ask the agent to list the files it read and the tasks it did in this session. Compare that list with your disclosure statement, and remove any claim you cannot back up.

## Key points

- An LLM predicts plausible text. It does not check facts, so verify every function, argument and column name.
- Do not paste Māori, health, ethics-restricted or commercial data into a web AI tool.
- Disclose which AI tool you used, what it did, and how you checked the output.
- Penguins is safe to use because it is openly licensed and contains no personal data.
