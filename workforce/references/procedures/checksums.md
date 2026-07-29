# checksums — integrity stamps for immutable blocks

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

## What is stamped

| Target | Covers | Drift means |
|---|---|---|
| immutable directive blocks | verbatim content | a sacred block was reworded — a directive violation |
| handbook `contract-stamp` | normalized `## Procedure` + `## Verification` | the eval baseline is stale; queue a `review` |
| `operating-principles` | the Strategic Objective and each principle | the constitution changed outside `charter` / `principles` |

## On mismatch

**Flag; never repair.** A mismatch means either a legitimate amendment that did not update the stamp,
or an unauthorized edit — and the two are indistinguishable from the hash alone. Re-stamping would
erase the only evidence that something changed.

Report the target, the section, and both hashes. Resolution is a human or `amend` decision.

## Where it runs

`verify` calls this. `audit` refreshes stamps after any authorized change. The
`protect-directives` hook consumes the sidecar when wired host-locally — and consumes it with the
same liberal reader, so a strict-generator/strict-reader mismatch cannot recur.
