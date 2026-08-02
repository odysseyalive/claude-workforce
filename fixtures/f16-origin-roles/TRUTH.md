# TRUTH — hand-counted, file by file

`origin:` has five roles and only one is a paired span. Counting openers against
closers reports the other four as orphan openers and sweep hazards; on
odyssey-alive that was **four of five reported hazards**, every one of them
unclosed by design.

## Hand count — one instance of each role

| Path | Line | Role | Why it is not an orphan |
|---|---|---|---|
| `roles/SKILL.md` | 7 | **paired span** | has its own `<!-- /origin -->` |
| `roles/SKILL.md` | 12 | **block attribute** | inside an `ENFORCEMENT ANNOTATION` block; closed by that family's `END` |
| `roles/SKILL.md` | 19 | **section header** | followed by a `##` heading; bounded by the next opener |
| `roles/SKILL.md` | 26 | **tail / append-point** | last opener, no closer after it; owns to EOF by design |
| `references/whole-file.md` | 1 | **file-scope header** | in the first lines; the whole file is machine-owned |

| Metric | Value |
|---|---|
| distinct roles observed | **5**, one each |
| `UNCLASSIFIED` | **0** |
| unpaired-marker findings | **0** |

## The precedence is load-bearing, and a first draft got it wrong

A tail is **the last opener**, not merely one lacking a closer. Ordering
"no closer after it" ahead of the heading test collapsed the section header and
the append point into a single `tail` count the moment the file's only closer sat
above both — which is exactly what this fixture caught on its first run. The real
target hid the bug: `invest/SKILL.md:102` happened to have a later closer at 357,
so it reached the heading test by accident.

**One real project is a ceiling.** This is the fourth time that sentence has been
paid for.

## What a closer would cost

Adding `<!-- /origin -->` to the append point would bound a region the generator
documents as running to EOF, so the next append lands outside the region that owns
it. Adding one to the block attribute would create a span the generator never
wrote, overlapping a differently-delimited block.
