---
name: no-slop-prose
description: >-
  Anti-slop discipline for the prose you write: code comments, commit messages,
  and any natural-language text. Use whenever writing or editing code, or writing
  a commit message. Comments and commits must earn their place: explain why, not
  what. Delete narration that restates the code. Stick to plain keyboard-typable
  ASCII characters.
---

# No Slop Prose

This skill governs the prose you write, not the code or designs themselves. It
covers three things: code comments, commit messages, and the characters you
type. They share one rule: say only what carries information, in characters a
human would actually type.

## Character hygiene (applies everywhere)

Use only characters reachable on an ordinary keyboard. ASCII punctuation only.

- No em/en dashes (`—`, `–`). Use a plain hyphen `-`, or rephrase with a comma,
  colon, or parentheses.
- No "smart"/curly quotes (`" " ' '`). Use straight `"` and `'`.
- No ellipsis character `…`. Use three dots `...`.
- No non-breaking spaces, bullets `•`, arrows `→`, multiplication signs `×`, etc.
- Exception: where the content genuinely requires it (a real identifier, a quoted
  string the code depends on, a human language that needs the character).

The tell of machine-generated text is the em dash and the curly quote. Avoid
them in comments, commit messages, and chat output alike.

# Comments

## Core rule

**A comment must say something the code cannot.** If a competent reader can learn
the fact by reading the line it sits on, the comment is slop. Delete it.

Default to **no comment**. Add one only when it carries information that is *not*
recoverable from the code itself.

## What earns a comment

Write a comment ONLY for:

- **Why, not what.** The rationale behind a non-obvious choice: a workaround, an
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

- **Restating the code.** `x = LLMConfig()  # referenced twice`, `i += 1  #
  increment i`, `# loop over users` above `for user in users:`.
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
- **Yes:** don't write it.
- **No:** write it, and write only the part they couldn't derive.

If a comment is needed because the code is confusing, prefer **fixing the code**
(better name, smaller function, clearer structure) over explaining it.

## Examples

```python
# SLOP - restates the code
llm_config = LLMConfig()  # referenced twice (creation + the startup log)
stt = create_stt(cfg) if use_audio else None  # only build stt when audio is on

# SLOP - narrates the obvious
# build the pipeline
pipeline = Pipeline(processors)
```

```python
# EARNS IT - non-local contract the line can't show
# Qwen3.5's chat template raises "No user query found" on a system-only context,
# so seed a user-role marker or the greeting run 400s.
GREETING_KICKOFF = "[Uruff just verbonnen. Begréiss den Uruffer kuerz.]"

# EARNS IT - deliberate-looking-wrong + rationale
# stop_secs raised above pipecat's default: its per-sentence commits make scribe-ws
# finish()+reset() drop streaming context mid-utterance (garbled transcript).
vad = SileroVADAnalyzer(params=VADParams(stop_secs=cfg.stop_secs))
```

## When editing existing code

- Remove slop you touch; don't add more.
- Keep pre-existing comments that carry real rationale; don't gut domain knowledge
  just because it's long. Length is fine; emptiness is not.
- Never add a comment to explain a variable you introduced for refactor reasons.
  Either the name makes it clear, or rename it.

# Commit messages

## Core rule

**A commit message says what changed and why, not how.** The diff already shows
the how. Describe the effect and the reason; do not narrate the implementation
line by line. The same why-not-what test from comments applies.

- The subject line states the change as an outcome: `fix login redirect loop`,
  not `change the if-condition in handleAuth`.
- The body (when needed) explains *why* the change was made: the bug it fixes,
  the constraint it satisfies, the decision behind it. Skip the body when the
  subject is self-explanatory.
- Do not restate the diff. "Renamed `foo` to `bar` and added a guard in `baz`" is
  slop; the diff shows that. If the rename has a reason worth knowing, give the
  reason instead.
- Be specific, not exhaustive. Descriptive is good; a paragraph re-deriving every
  hunk is not. Say the one thing the reader can't get from the diff.

## Slop vs earns it

```
SLOP - narrates the implementation
  refactor: extract getUser() helper, move it above getOrders(), update the
  three call sites to use it, and change the return type to Optional

EARNS IT - states the change and the reason
  refactor: dedupe user lookups into getUser()

  The three call sites had drifted apart and one skipped the cache, causing
  stale reads on the profile page.
```

Keep whatever commit conventions the repo already uses (prefixes like `feat:`,
`fix:`, scopes, trailers). This skill governs the content, not the format.

## Do not sign your work

Never add yourself as a co-author. No `Co-Authored-By:` trailer, no
`Generated with ...` line, no agent attribution of any kind in the commit
message. The commit is the user's.
