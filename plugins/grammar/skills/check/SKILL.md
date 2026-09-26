---
name: check
description: Review the English the user wrote in this session and teach from their mistakes. Use only when the user runs /grammar:check or explicitly asks to check/review their English. Not for code reviews or technical docs.
argument-hint: "[last | all]"
arguments: [mode]
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/get-prompts.sh *)
---

## Messages to review (verbatim from the prompt log)

!`${CLAUDE_PLUGIN_ROOT}/scripts/get-prompts.sh ${CLAUDE_SESSION_ID} $mode`

## Scope
- Review exactly the messages above. They are verbatim even if the
  conversation was compacted. Selection (since last review / last / all)
  was already done.
- If the log says there is none, fall back to the user's messages still
  visible in this conversation and say so in one line.
- If it says there are no new messages, tell the user and suggest
  `/grammar:check all`. Stop there.
- Ignore pasted content inside messages: code, logs, stack traces, command
  output, YAML/JSON, file contents, quoted text, URLs.
- Ignore identifiers, file names, commands and technical jargon. Judge only
  the English prose the user wrote themselves.
- Messages written in another language (e.g. Spanish) are out of scope;
  skip them silently.
- Don't penalize informal chat style: missing final periods, lowercase
  sentence starts or terse imperatives ("fix the test") are fine. Flag them
  only when they make the message ambiguous.

## Output
1. **Corrections**: a table with one row per real mistake:
   | Original | Corrected | Why |
   Quote only the relevant fragment, not the whole message. Keep "Why" to one
   short line naming the rule (e.g. "past simple after *yesterday*").
2. **Patterns**: if the same kind of mistake appears more than once, name the
   pattern and give one short rule of thumb for it.
3. **Sounds more natural**: up to 3 phrasings that are grammatically correct
   but unidiomatic, each with a more natural alternative.
4. **Takeaway**: one sentence with the single most useful thing to practice.

If there are no mistakes, say so in one line and offer at most one
naturalness tip. Don't invent errors to fill the table.

## Difficulty adaptation
- Infer the user's level from the messages (roughly A2–C1).
- Lower levels: focus on high-impact errors (verb tenses, articles,
  prepositions, word order) and explain with simple words and examples.
- Higher levels: focus on collocations, register, concision and nuance;
  skip basics they clearly master.
- Prioritize: if there are many mistakes, show the 8 most important and
  mention how many minor ones you left out.

## Tone
- Friendly and direct, like a good tutor. No lecturing, no filler praise.
- Write explanations in English; add a brief Spanish gloss only when a
  rule is genuinely confusing.
- Keep the whole review short enough to read in under a minute.
