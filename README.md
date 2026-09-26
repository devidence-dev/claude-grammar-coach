# 📝 Claude Grammar Coach

> Improve your English while you code. A Claude Code plugin that quietly logs the prompts you write and reviews your grammar on demand, teaching from **your own** mistakes.

![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-D97757)
![Shell](https://img.shields.io/badge/made%20with-bash%20%2B%20jq-4EAA25)

---

## ✨ Features

- 🎯 **Real mistakes, real context**: reviews the English you actually wrote to Claude, not textbook exercises.
- 🧠 **Survives compaction**: every prompt is logged verbatim, so nothing is lost when the conversation gets compacted.
- 🔖 **Incremental reviews**: each `/grammar:check` works as a checkpoint, and the next one only covers what you wrote since then.
- 🧹 **Ignores the noise**: code, logs, stack traces, JSON/YAML, URLs and pasted text are skipped.
- 📈 **Adapts to your level**: basics for beginners, collocations and nuance for advanced writers.
- 🔒 **100% local**: logs stay on your machine and are deleted after 30 days.

## 🚀 Installation

Inside Claude Code:

```
/plugin marketplace add devidence-dev/claude-grammar-coach
/plugin install grammar@grammar-coach
```

Or from your shell:

```bash
claude plugin marketplace add devidence-dev/claude-grammar-coach
claude plugin install grammar@grammar-coach
```

Then restart Claude Code or run `/reload-plugins`.

### 📦 Requirements

- [`jq`](https://jqlang.org/) available in your `PATH` (`apt install jq` / `brew install jq`)
- `bash`

## 💬 Usage

| Command | What it reviews |
|---|---|
| `/grammar:check` | 🆕 Messages since your last review (or the whole session if it's the first one) |
| `/grammar:check last` | ⏮️ Only your latest message |
| `/grammar:check all` | 📚 Every message in the current session |

You can also just ask *"check my English"*.

### 🖼️ Example output

> ~~yesterday i deploy it to prod~~ → **yesterday I deployed it to prod**
> **[Grammar]** Past simple after *yesterday*. **[Punctuation]** "i" → "I"

> ~~it depends of the cluster~~ → **it depends on the cluster**
> **[Grammar]** *depend* always takes *on*

🔁 **Recurring patterns**: present tense used for past actions (2×)

🌱 **Spanish-speaker trap**: *depend of* → *depend on* (from *depender de*)

📊 **Summary**: clear and understandable. Next focus: past simple.

Corrections are tagged as **Spelling**, **Grammar**, **Word Choice**, **Punctuation**, **Semantics** or **Expression**, and each review ends with something new to learn: a phrase of the day, a grammar tip, a "level up" rewrite or a Spanish-speaker trap.

## ⚙️ How it works

```
You type a prompt ──▶ 🪝 UserPromptSubmit hook ──▶ ~/.claude/grammar-coach/sessions/<session_id>.jsonl
                                                               │
/grammar:check ──▶ 📜 get-prompts.sh (filters new messages) ◀──┘
                          │
                          ▼
                   🤖 Claude reviews & teaches
```

1. **🪝 Log**: a `UserPromptSubmit` hook appends each prompt to a per-session JSONL file. It prints nothing and never blocks your prompts.
2. **📜 Select**: when you run the skill, `get-prompts.sh` injects your original messages into it. Earlier `/grammar:check` calls mark what was already reviewed.
3. **🤖 Teach**: Claude corrects the mistakes, spots patterns and gives you one clear takeaway.

## 📁 Project structure

```
.claude-plugin/marketplace.json
plugins/grammar/
├── .claude-plugin/plugin.json
├── hooks/hooks.json
├── scripts/
│   ├── log-prompt.sh      # 🪝 hook: logs each prompt
│   └── get-prompts.sh     # 📜 selects messages to review
└── skills/check/SKILL.md  # 🤖 the /grammar:check skill
```

## 🔒 Privacy & storage

- Prompts are stored **only** in `~/.claude/grammar-coach/sessions/`. The plugin sends them nowhere.
- Logs older than **30 days** are deleted automatically.
- Everything you type is logged, including pasted content. Check the size with `du -sh ~/.claude/grammar-coach/sessions`, or delete that folder at any time.

## 🗑️ Uninstall

```
/plugin uninstall grammar@grammar-coach
```

Then optionally delete your logs with `rm -r ~/.claude/grammar-coach`.

## 🙏 Credits

The review prompt is adapted from **english-coach** by tianmind-studio (MIT).

---

Made with ☕ and a lot of *"I have went"* moments.
