---
name: no-slop-comments
description: >-
  Comment discipline. Use whenever writing or editing code in any language.
  Comments must earn their place: explain only the non-obvious — why, not what.
  Delete narration that restates the code. The reader can read the code.
---

# No Slop Comments

## Core rule

**A comment must say something the code cannot.** If a competent reader can learn
the fact by reading the line it sits on, the comment is slop — delete it.

Default to **no comment**. Add one only when it carries information that is *not*
recoverable from the code itself.

## What earns a comment

Write a comment ONLY for:

- **Why, not what.** The rationale behind a non-obvious choice — a workaround, an
  ordering constraint, a perf trade-off, a spec/protocol quirk, a "looks wrong but
  is deliberate" decision.
- **Non-local context.** Behavior that depends on something not visible at this
  line (an external API's contract, another system's bug, a frame that arrives from
  elsewhere, an invariant enforced far away).
- **Decisions & landmines.** Why the obvious alternative was rejected; what breaks
  if you "simplify" this; a TODO with a concrete reason.
- **Pointers.** A link to a spec, ticket, or doc that explains the surrounding
  shape.

## What is slop (delete on sight)

- **Restating the code.** `x = LLMConfig()  # referenced twice` · `i += 1  #
  increment i` · `# loop over users` above `for user in users:`.
- **Narrating the obvious.** `# create the client`, `# return the result`,
  `# import deps`, `# the main function`.
- **Section labels for self-evident structure.** `# --- helpers ---` when the
  functions below are plainly helpers.
- **Type/signature echoes** already stated in annotations or the name.
- **Changelog/process chatter** in code (`# added this for the refactor`,
  `# per review`). That belongs in the commit message.
- **Commented-out code.** Delete it; version control remembers.

## The test before you type a comment

Ask: *"Could a competent reader derive this by reading the code?"*
- **Yes →** don't write it.
- **No →** write it, and write only the part they couldn't derive.

If a comment is needed because the code is confusing, prefer **fixing the code**
(better name, smaller function, clearer structure) over explaining it.

## Examples

```python
# SLOP — restates the code
llm_config = LLMConfig()  # referenced twice (creation + the startup log)
stt = create_stt(cfg) if use_audio else None  # only build stt when audio is on

# SLOP — narrates the obvious
# build the pipeline
pipeline = Pipeline(processors)
```

```python
# EARNS IT — non-local contract the line can't show
# Qwen3.5's chat template raises "No user query found" on a system-only context,
# so seed a user-role marker or the greeting run 400s.
GREETING_KICKOFF = "[Uruff just verbonnen. Begréiss den Uruffer kuerz.]"

# EARNS IT — deliberate-looking-wrong + rationale
# stop_secs raised above pipecat's default: its per-sentence commits make scribe-ws
# finish()+reset() drop streaming context mid-utterance (garbled transcript).
vad = SileroVADAnalyzer(params=VADParams(stop_secs=cfg.stop_secs))
```

## When editing existing code

- Remove slop you touch; don't add more.
- Keep pre-existing comments that carry real rationale — don't gut domain knowledge
  just because it's long. Length is fine; emptiness is not.
- Never add a comment to explain a variable you introduced for refactor reasons.
  Either the name makes it clear, or rename it.
