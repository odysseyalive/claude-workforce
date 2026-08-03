# Development defect classes — the register

**Not a list of bugs. A list of the SHAPES bugs took**, because on 2026-08-03 nineteen
defects sorted into four classes and every class fired four to ten times inside one
session. Each was fixed as an instance; none was fixed as a class until the day was
nearly over. That is the regression pattern — not fixes coming back, but the same
mistake being made again three hours later in a different file.

**A class earns a mechanism on its SECOND occurrence.** The project directive already
says *fix the class rather than the instance*; what was missing is a place to notice
that a class had recurred at all. This file is that place, and a class listed here
without a mechanism is an open item.

---

## A — a pattern matched text that was not the thing  ·  **10 instances**

The dominant class by a factor of two, and the only one that reached the shipped
scripts.

| Instance | Consequence |
|---|---|
| `"ORG-RECORD" in body` matched prose reading *"No ORG-RECORD"* | a hand-authored agent classified as workforce-governed |
| marker regex matched `<!-- X START -->` inside an English sentence | **11 false sweep hazards**; `audit.md` § Step 3b excludes those files from extraction AND the sweep |
| `IMMUTABLE_OPEN` required `user \| immutable: true` with only whitespace between | **21 sacred blocks counted where 59 exist** — and `INV-DIRECTIVES` gates the sweep on that count |
| block extractor split on the bare marker name | matched the PROSE line naming both markers; returned a 4-character "block", and every assertion against it passed |
| ordering check matched the first `lowest competent node` | which is rung 1's announcement template, not rung 3's heading |
| `catalog-unappendable` read `SKILL.md`, reported about `ai-patterns.md` | a live catalog frozen on evidence from the wrong file |
| `ORG_RECORD_RX`, `BLOCK_RX` ×2, `ORG_CHAIN_RX` still unanchored | **found by the class mechanism below, in code already "fixed" the same day** |

**Mechanism:** `bin/check` § scripts: every marker pattern is line-anchored. Walks each
shipped script's AST; a `re.compile` containing `<!--` must be line-anchored, and a
bare `"<!-- …" in body` is flagged outright. **It found four live instances on its
first run** — which is the argument for the register in one sentence.

**Why anchoring is the right rule:** a marker is a standalone line. A pattern for one
that is not line-anchored reads documentation *about* markers as markers, and every
mature project documents its own markers.

---

## B — added the new without removing the old  ·  **4 instances**

| Instance | Consequence |
|---|---|
| dispatch block rewrite inserted, original kept | **two canonical blocks shipped**; five assertions passed against the stale one |
| `bin/coverage --stamp` appended a header every run | 67 files carried duplicates before anyone ran it twice |
| `audit-setup.md` read into `_as` AND `_asu` | an assertion placed before its own variable was defined |
| `verify.md` retraction | left the retracted instruction standing eight lines below it |

**Mechanisms:** exactly-one-canonical-block (dispatch block only — **the general form
is open**); `shipped files: none instructs a host to open a path that does not ship`;
and **`bin/idempotence`** — every writer invoked twice against a fresh copy, results
compared byte-for-byte. It runs on a COPY, because a conformance tool that mutates
what it checks has the defect it is looking for. Proven by reintroducing the original
strip-regex bug: **67 files changed on the second run.**

*Nobody ran `--stamp` twice because nothing did. That is the whole gap, and it is the
cheapest class to close: the test is "run it again and diff."*

---

## C — an assertion stricter or looser than its own stated rule  ·  **5 instances**

| Instance | Consequence |
|---|---|
| leak check banned a quotation its own message exempted | blocked a legitimate retraction |
| host-sends check caught a quoted retraction | same shape, same day, three hours later |
| an `or`-masked conjunct | stayed green with one literal broken |
| question threshold set to `>= 2` | half the human-facing surface unspecified, and the number chosen to pass |
| banned-word list in the doc ≠ the list in the check | *"this is a list, and it is checked"* false in both directions |

**Mechanism: none. OPEN.** The honest statement of the rule is *an assertion's failure
message must not name an exemption the code does not implement*, and that is not
mechanically decidable. The available discipline is procedural: **when a check fires
on something legitimate, the finding is the CHECK, not the text** — and it is fixed
before the text is touched.

---

## D — an assertion tested the wrong artifact  ·  **4 instances**

| Instance | Consequence |
|---|---|
| nine assertions matched the FILE, not the delimited block | all nine would have passed against an empty block |
| five more matched the DUPLICATE block | green while the shipped rails were unchecked |
| `_uncalled` satisfied by a bare mention in any `.md` | a "wired" agent named only in a reference |
| first draft of *every script is invoked* accepted any `.md` | the assertion testing that a file is wired, itself unwired |

**Mechanism:** `org: the block assertions read the block, not the file that explains
it`. **Generalization is open** — nothing stops the next assertion about a delimited
artifact from matching the file that describes it.

---

## What this costs to keep

One table row per recurrence, written when the recurrence is noticed. The alternative
is what happened on 2026-08-03: the same shape fixed six times, and the sixth fix
introducing a seventh instance in the file that was supposed to prevent it.
