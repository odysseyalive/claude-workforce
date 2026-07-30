# 2026-07-30 — Doctrine audit: `invariants.md`

**Method.** `wf-doctrine-auditor` run as a prompt template (`staging.md` § The same constraint applies)
against `workforce/references/invariants.md`, in an isolated context that had not written the file.
Every status was produced by **making the edit in a scratch copy and re-running `python3 bin/check`** —
no status inferred from reading.

Baseline before: 284 passed, 0 failed. Repo untouched; scratch copy deleted.

**Result: 27 claims examined · 3 enforced · 2 partial · 21 unenforced · 0 unchecked.**

The file whose subject is enforcement was the least enforced file audited. That is not irony worth
noting for its own sake — it is the predicted outcome of the pattern the file describes, landing on the
file that describes it.

---

## Finding 1 — the gate was unfireable as sequenced

> *"A run with any `NOT UPHELD` row does not proceed to a destructive step."*

The Run Invariants block was specified to print at **Step 7 — Close**. The only destructive step is
**Step 6b — the sweep**. So a row computing to `NOT UPHELD` was discovered strictly *after* the sweep it
was meant to stop, and nothing instructed the run to compute the rows earlier. Seven of the ten rows had
no pre-sweep gate at all.

**Same shape as the backup ordered after the first write**, already recorded in `CLAUDE.md` as one of
the two entries "worth re-reading: both had correct doctrine and an implementation that contradicted
it." This is the third.

**Fixed:** computation and gating moved to Step 6b as its first act; printing stays at close. The two
moments are now named separately, because collapsing them is what made the gate unfireable.

## Finding 2 — the table was counted, never read

`bin/check` asserted `inv_rows == 10`. The auditor **replaced all ten printed-line texts with the word
"garbage" and the check passed.** It also replaced row 6's line with one contradicting the gate it
belongs to — passed.

**Fixed:** each row now carries an `INV-*` token and names its owner as a `references/…` path. The check
parses every row and resolves its token into the owner file, failing if absent. A row cannot be added,
reworded, or repointed without the procedure changing in the same edit.

## Finding 3 — a substring test satisfied by prose that cancels it

The assertion named *"the run report prints the block before findings"* tested only `"Run Invariants" in
audit.md`. The auditor passed it with:

> *"Historically some runs printed a Run Invariants block; that is no longer expected."*

The "before findings" half of the assertion's own name tested nothing.

**Fixed:** the check now requires the imperative instruction verbatim.

## Finding 4 — the classification table's operative column was unguarded

Only the three labels — Structural, Procedural, Advisory — were held. The auditor rewrote the structural
enforcer to **"a careful reader"**, the procedural one to **"a clearly written rule"**, and the advisory
one to **"a hook"**. All passed.

That column is the entire content of the scheme, and both `procedure-for-procedures.md` rule 8b and the
doctrine-auditor handbook dispatch on it.

**Fixed:** each row's enforcer is asserted by name.

## Finding 5 — the routing sentence was invisible to the reference check

Owners were named bare (`legacy-markers.md`, `hire.md`). `bin/check`'s `REF_RX` resolves only paths
beginning `references/`, so **none of them was validated** — the auditor repointed rows 2–4 at
`no-such-file.md` and the check passed.

**Fixed:** owners are written `references/…` and resolve through the existing cross-reference check, plus
the token resolution above.

---

## Verification of the fix

The auditor's five passing mutations were replayed against the corrected check. All five now fail:

| Mutation | Before | After |
|---|---|---|
| all ten tokens → `garbage` | passed | **FAIL** — enumerated set |
| prose cancelling the requirement | passed | **FAIL** — imperative instruction |
| structural enforcer → "a careful reader" | passed | **FAIL** — enforcement column |
| gate moved back after the sweep | n/a | **FAIL** — computed before sweep |
| one token unwired from its owner | passed | **FAIL** — token resolution |

`bin/check`: 284 → **290 assertions**.

---

## What this measures beyond the file

**The adversarial second reader works, and the author's own re-reading did not.** These twenty-one gaps
sat in a file written, reviewed, and committed hours earlier by an author who had just spent the session
hunting this exact pattern — and who had, in the same file, written down how it hides.

The mechanism that found them is cheap: one isolated context, one file, mutations run rather than
reasoned about. **It should run against every reference file that governs deletion, extraction, or
ordering** — `legacy-markers.md`, `conversion-taxonomy.md`, `procedures/audit.md`, `procedures/hire.md` —
before the first real conversion.

Prediction to test: the same audit against those files finds gaps of the same class. If it does not, that
is evidence the fix generalised; if it does, the count is the measure of how much doctrine in this
project is still intention.
