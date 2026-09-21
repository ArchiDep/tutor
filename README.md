# ArchiDep AI Tutor

Instructions that turn your AI agent (Claude Code, Codex, Cursor, etc.) into a
tutor for the [Media Engineering Architecture and Deployment
course](https://archidep.ch): it knows the course, knows how far the class has
got, and helps you understand instead of doing the exercises for you.

> [!WARNING]
>
> The tutor is an AI: it can be wrong, even with these instructions, and nothing
> it says is guaranteed to be correct. It is your responsibility to sort out
> what is correct from what is not, especially before you type a command on your
> server. When in doubt, the course and the teachers are the reference.

- [Why use it](#why-use-it)
- [Installation](#installation)
- [Your profile](#your-profile)
- [Updating](#updating)
- [What the tutor reads](#what-the-tutor-reads)
- [License](#license)

## Why use it

An AI agent can do any exercise of this course in a few minutes. But a finished
exercise has no value: what matters is what you understood while doing it, and
that is what the exam checks, without AI. Using an agent that does everything is
like going to the gym with a forklift: the weights are lifted, but you gained
nothing.

Research agrees, with nuances:

- In a randomized trial with nearly 1,000 high school students, those who
  practised mathematics with ChatGPT did better during practice, then 17% worse
  on the exam, without AI, than those who practised without it. A version that
  gave hints instead of answers largely avoided that harm ([Bastani et al.,
  2025][bastani]).
- Developers who learned a new Python library with an AI assistant scored 50% on
  a quiz afterwards, against 67% for those who coded by hand, for barely any
  time saved. Those who only asked conceptual questions and fixed their own
  errors did well ([Shen and Tamkin, 2026][shen], [summary][shen-summary]).
- In programming courses, students who asked ChatGPT for explanations learned
  more, and those who asked it for solutions learned less. Both believed they
  had learned more than they had ([Lehmann et al., 2024][lehmann]).
- Novice programmers who were already struggling were the most likely to accept
  AI output they did not understand, while stronger ones used it to go further
  ([Prather et al., 2024][prather]).
- An AI tutor designed to teach does help: physics students at Harvard learned
  more, in less time, with such a tutor than in an active learning class
  ([Kestin et al., 2025][kestin]).

What matters is not whether you use an AI, but whether it thinks **with you** or
**for you**.

This tutor is made to think with you. It asks what you tried, gives you the
smallest useful hint, and lets you type the commands yourself. You can also ask
it to guide you through an exercise: it then asks you questions at the important
steps. And if you just want it to work, it will give you the answer, and tell
you what you are missing.

## Installation

Choose one of these three ways.

### With Git (recommended)

```bash
git clone https://github.com/ArchiDep/tutor.git
cd tutor
claude   # or codex, cursor, etc.
```

Start your agent from this directory: that is where it finds its instructions.
Most agents read `AGENTS.md`; Claude Code reads `CLAUDE.md`, which imports
`AGENTS.md`.

> [!TIP]
>
> If Git is not installed on your computer yet, follow
> [the course's installation instructions](https://archidep.ch/#tools-for-later-sessions),
> or use the installation [without Git](#without-git) below.

### Without Git

Download the files into a new directory, then start your agent from that
directory:

```bash
mkdir tutor
cd tutor
for f in AGENTS.md CLAUDE.md STUDENT.example.md update.sh; do
  curl -fsSLO "https://raw.githubusercontent.com/ArchiDep/tutor/main/$f"
done
```

### In a chat (ChatGPT, Claude.ai, etc.)

Copy the content of [`AGENTS.md`](AGENTS.md) into the instructions of a project
if your tool has them, or at the start of the conversation otherwise. If your
tool cannot read web pages, the tutor will ask you how far the course has got
and to paste the exercise.

## Your profile

To help the tutor adapt to you, copy [`STUDENT.example.md`](STUDENT.example.md)
to a file named `STUDENT.md` and fill it in: your background, your experience
with the terminal and Git, how you prefer to be helped, and later your username
and your server's address. In a chat, paste it together with `AGENTS.md`.

This file is never changed by updates and never sent to GitHub. It is sent to
the provider of your AI agent, however: do not put sensitive personal data in
it.

## Updating

The tutor tells you when a new version is available. Then update it from its
directory:

```bash
cd /path/to/tutor
sh update.sh
```

The script runs `git pull` if you cloned the repository, and downloads the files
from GitHub otherwise.

## What the tutor reads

If you limit your agent's access to the web, this table shows what the tutor
needs.

| Site                        | Content                                                                | When                               |
| --------------------------- | ---------------------------------------------------------------------- | ---------------------------------- |
| `archidep.ch`               | `/llms.txt` (the course index), `/api/progress`, pages and tutor notes | every conversation                 |
| `backup.archidep.ch`        | course pages                                                           | only if `archidep.ch` is down      |
| `raw.githubusercontent.com` | `/ArchiDep/tutor/main/AGENTS.md` only, to compare versions             | without Git, once per conversation |
| `github.com`                | `git fetch` of this repository                                         | with Git, once per conversation    |

If your agent has access to a terminal, it can run `curl` to these sites, and
`git fetch` and `git rev-list` in this directory. It never runs `git pull` or
`update.sh`. You type the exercises' commands: it only runs them for you if you
insist, and asks you to confirm anything destructive.

With Claude Code, you can allow the course sites once and for all in
`.claude/settings.local.json`, in this directory:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:archidep.ch)",
      "WebFetch(domain:backup.archidep.ch)"
    ]
  }
}
```

> [!NOTE]
>
> `raw.githubusercontent.com` is left out on purpose: allowing it would allow
> reading any file of any GitHub repository. Accept the version check when the
> agent asks you instead.

## License

[MIT](LICENSE.txt)

[bastani]: https://doi.org/10.1073/pnas.2422633122
[kestin]: https://doi.org/10.1038/s41598-025-97652-6
[lehmann]: https://arxiv.org/abs/2409.09047
[prather]: https://doi.org/10.1145/3632620.3671116
[shen]: https://arxiv.org/abs/2601.20245
[shen-summary]: https://www.anthropic.com/research/AI-assistance-coding-skills
