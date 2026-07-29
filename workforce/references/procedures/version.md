# version — what is installed

Read-only; executes immediately. `/workforce version [--check]`

---

## Output

```
claude-workforce 1.0.0
  installed at:   ~/.claude/skills/workforce          (personal scope, active)
  also present:   ./.claude/skills/workforce  1.0.0   (vendored, shadowed)
  platform facts: measured on claude-code 2.1.220 — current
  harness now:    2.1.220
```

Four things, and each answers a question that has bitten someone:

**Which copy is active, by path.** Skills resolve personal > project, so a vendored copy can be
silently shadowed. Reporting only a version number cannot distinguish "up to date" from "you are
running a different copy than you think."

**Whether another copy exists**, and its version. Version skew between a personal install and a
vendored one is invisible until something behaves unexpectedly.

**Platform freshness** — `platform.md` § `MEASURED-ON` against the running harness. Mismatch means
every measured fact is **stale**: still usable as a working assumption, but barred from being the
basis of a blocking check until re-measured.

**The two versions are reported separately.** `WORKFORCE-VERSION` tracks the product;
`MEASURED-ON` tracks the harness the facts were measured against. They move independently, and
folding them into one number would hide exactly the case that matters — a current release whose facts
predate the harness you are running.

## `--check`

Compares against `main` and reports whether an update is available, plus what changed.

**A measured-fact correction is called out specifically**, not folded into a changelog line. It means
gates may behave differently, and a user needs to know their org was designed against a superseded
reading of the platform.

Never auto-updates. `--check` reports; `update` acts.
