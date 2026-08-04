# checksums — integrity stamps for immutable blocks

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 9 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Low risk; executes immediately. `/workforce checksums [target]`

Generates and verifies the sidecar covering `<!-- origin: user | immutable: true -->` blocks and the
`contract-stamp` on each handbook.

---

## The inherited lesson — read this before writing a generator

claude-enforcer's `INC-2026-07-29-sidecar-format-mismatch`: a checksum generator wrote rows its own
parser could not read. The hook then **reported clean about blocks it never examined** — the worst
possible failure for a verification mechanism, because it is indistinguishable from working, and it
was the *second* defect in that subsystem.

Four rules follow, and they are not optional:

1. **Generators are strict; readers are liberal.** Emit exactly the canonical format; accept minor
   variation when reading.
2. **Read back and re-parse.** After writing, the generator re-reads its own output **with its own
   reader** and confirms every row it intended is present and parses. A generator that cannot verify
   its own output has not finished.
3. **Report coverage as a count** — `"N of N blocks examined"` — **never a bare "clean".** A
   verification that cannot state its coverage is not evidence.
4. **`PARTIAL` and `UNREADABLE` are first-class states**, not silence.

| State | Meaning |
|---|---|
| `OK` | every block hashed and matching |
| `MISMATCH` | a block's content changed — **flag, never repair** |
| `PARTIAL` | some blocks could not be read; coverage is incomplete and named |
| `UNREADABLE` | the sidecar itself does not parse; treat as no coverage at all |

## The row grammar — canonical, and the one thing this file did not state

**One row per BLOCK. The digest is over the NORMALIZED block content, never the file.**

```
<sha256>  <path-relative-to-project-root>:directive:<N>
```

| Field | |
|---|---|
| `<sha256>` | 64 lowercase hex, of the block's content between its markers, normalized |
| `<path>` | relative to `${CLAUDE_PROJECT_DIR}`, so a sidecar survives being moved with the tree |
| `:directive:<N>` | 1-based index of the block **within that file**, in document order |

**Block SELECTION, stated once for the same reason — and it was not stated at all until 2026-08-03.**
This file specified how to *normalize* a block and never how to *find* one, so two readers of the same
tree disagreed on the count:

| Form | Counts as a block? |
|---|---|
| the marker **alone on its line** (leading whitespace allowed) | **yes** — this is the canonical form |
| the marker inside a **fenced code example** | **yes** — a template ships its markers, and a sweep must see them |
| the marker quoted **inline in prose or inside a JSON string** | **no** — it is a mention, not a block |

**The discriminator is "alone on its line", and it is the whole rule.** A line quoting a START marker inside a JSON string literal — as `enforcement.md` § The machine-owned
region does, to show why markers cannot live in JSON — documents a hazard. It does not open a region.

*Written after a sweep's re-derivation took four attempts to agree with this command's own generator —
64, then 65, then 71, converging on 76 of 76. **Every mismatch was an INDEX SHIFT, never content
drift**: `directive:2` hashing to the digest recorded for `directive:1`, because one reader counted an
inline mention as block 1 and the other did not. Content was never at risk and no user text was ever
in doubt, which is exactly what made it survivable long enough to matter — a per-block digest whose
per-block INDEX is computed differently by two readers reports MISMATCH on healthy files and OK on
drifted ones, and this file's rule 1 ("generators are strict; readers are liberal") cannot resolve it
because liberality about spacing says nothing about which spans exist.*

**Normalization, stated once because two readers must apply the same rule:** strip leading and trailing
whitespace from the span, then right-strip every line. Nothing else — no case folding, no whitespace
collapsing inside a line, no markdown normalization. A sacred block's punctuation is the user's.

**Comment lines start with `#` and are ignored. A data line that does not match is MALFORMED and is
reported** — never skipped. Generators are strict, readers are liberal (rule 1 above), and "liberal"
means tolerant of spacing, not tolerant of rows it cannot read.

**Why per-block and not per-file.** A file-level digest answers "did this file change", which is the
wrong question: a handbook changes constantly and its immutable block must not. Per-block is the only
granularity where a MISMATCH means what this command says it means.

*This grammar was unwritten until 2026-08-03 while **two shipped readers already parsed the file**.
`wf-protect-directives` read `<sha>  <path>:directive:<N>` and hashed normalized block content;
`wf-conform` split on a double space and hashed whole-file bytes. They could not agree even on a
well-formed row, and each reported confidently. That is the incident this file opens by citing,
reproduced inside the project that wrote the warning — and it happened because a rule said "emit
exactly the canonical format" without the canonical format being anywhere.*

## What is stamped

| Target | Covers | Drift means |
|---|---|---|
| immutable directive blocks | verbatim content | a sacred block was reworded — a directive violation |
| handbook `contract-stamp` | normalized `## Procedure` + `## Verification` | the eval baseline is stale; queue a `review` (`references/deferred.md`) |
| `operating-principles` | the Strategic Objective and each principle | the constitution changed outside `charter` / `principles` |
| data skill `## Schema` + `## Invariants` | normalized content | the contract several employees read changed outside `amend` |
| extracted directives | each block in `.claude/workforce/directives/` | an extracted user directive was altered after its source was swept |

**The extracted-directives row is the one with no second copy.** Everywhere else, drift means two things
disagree and the original is still available. Once a conversion sweep has run, the extracted file *is*
the original — its source is gone. Drift there is unrecoverable from anything but a backup, so it is
reported at the top of the run rather than in sequence.

## On mismatch

**Flag; never repair.** A mismatch means either a legitimate amendment that did not update the stamp,
or an unauthorized edit — and the two are indistinguishable from the hash alone. Re-stamping would
erase the only evidence that something changed.

Report the target, the section, and both hashes. Resolution is a human or `amend` decision.

## Where it runs

`verify` calls this, and `audit` refreshes stamps after any authorized change. **The sidecar path is
`${CLAUDE_PROJECT_DIR}/.claude/workforce/.directives.sha`** — named here because an inherited hook
once read a sidecar that no procedure wrote, and reported `NO-COVERAGE` forever. A generator with no
named destination is not a generator.
