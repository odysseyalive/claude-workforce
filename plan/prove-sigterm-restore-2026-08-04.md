# `bin/prove` had to be backgrounded, and being backgrounded could corrupt the tree — 2026-08-04

Opened by a user question in `dev` mode: *"Should we be concerned that agents are being started and
not exited properly?"*, shown a session that had run 2h54m and was exiting with **five background
shells still alive**:

```
shell · Wait for bin/prove to finish
shell · Block until bin/prove exits
shell · Wait for prove and report result
shell · Wait for prove to finish
shell · until ! pgrep -f "bin/script-conformance" >/dev/n…
```

## The agents were a red herring

Nothing leaked. Zero `prove` / `check` / `script-conformance` processes were alive at investigation
time, and those shells die on session exit by construction. **No shipped file in `workforce/`
instructs a background shell or a polling wait** — grepped, zero hits. The pattern was the prior
session improvising, not doctrine being followed.

But four of the five waiters were waiting on **the same job**, which is a measurement:

| | measured |
|---|---|
| `bin/check`, one run | **1.82 s** |
| `bin/prove`, sequential and in place | **181 s** |
| default harness `Bash` timeout | **120 s** |

**`bin/prove` could not complete inside a default foreground call.** So it got backgrounded, and the
session spawned a fresh waiter each time it wanted the result, never reaping the last.

## The defect that made backgrounding dangerous

`bin/prove` was the **only** script in `bin/` that mutated the repository **in place** — verified, not
assumed: `bin/script-conformance` (`copytree` → `cwd=tree`) and `bin/idempotence`
(`TemporaryDirectory` → `cwd=work`) both already ran against copies. Each prove case broke a real
tracked file, ran `bin/check`, and restored it in a bare `finally`. For **181 seconds** the working
tree carried a deliberately-sabotaged file protected by nothing else.

**MEASURED, both directions**, with a scratchpad harness of identical structure:

```
after SIGTERM  -> content: MUTATED   | stray backups: 2
after SIGINT   -> content: ORIGINAL  | stray backups: 0
```

`KeyboardInterrupt` is an exception, so Ctrl-C unwinds through the `finally`. A default-disposition
**SIGTERM kills the process between bytecodes and the `finally` never runs.** SIGTERM is what a
session teardown sends — the exact gesture in the transcript that opened this record. The result is
loud but **unattributed**: the next run refuses on a red baseline with nothing recording which file
was mutated, and a `git commit -a` inside that window commits the sabotage.

## First fix, and why it was not the fix

Signal handlers re-raising as `KeyboardInterrupt` made both signals unwind through the same `finally`.
Proven by killing a real run mid-flight: sabotaged `wf-conform` restored, `rc=130`, zero strays.

**That fixed the corruption and left the cause alone.** The run was still 181 s, still could not fit a
foreground call, still had to be backgrounded, still had a window — now merely a guarded one. The user
said so directly: *"that is what I asked you to find and produce a solution for, can't you fix it?"*

## The actual fix: break a copy, in parallel

Each worker takes a **private disposable copy** of the tree (~1 MB without `.git`) and breaks files
inside it. One copy per worker rather than per case — the copy costs a fraction of a second against
`bin/check`'s 1.8 s, so per-case copying would dominate.

This closes both halves at once, and the second is the one that matters:

| | |
|---|---|
| **181 s → 60-88 s** (4 workers, 4 cores) | fits a foreground call, so nothing needs backgrounding. The spread is machine load: 88 s was measured while this session sampled `git status` alongside it, 60 s on an unloaded run |
| **the tree is never written** | no signal at any moment can corrupt it — safety stopped depending on runtime |

`bin/check` resolves its own root from `__file__` and `chdir`s, so a copy is a valid standalone
checkout. `ROOT` in `bin/prove` is now derived the same way instead of hardcoded to one machine's path.

**Measured, mid-run, three samples:** the working tree showed only this change's own edits and never a
sabotaged file. The run also verifies it itself, by content hash taken before and after —
`working tree untouched: yes` is measured, not asserted.

**Killed mid-run under SIGTERM:** `INTERRUPTED … after 23 of 98 cases`, tree untouched, baseline clean,
**0 orphaned copies in /tmp**. The signal handler keeps its place for that smaller job: unwinding the
`TemporaryDirectory` contexts. The 60-88 s margin against 120 s is not large, and that is fine — a slower
host can still exceed it, and backgrounding is now *safe* rather than merely unnecessary.

## Three defects in the fix, none found by re-reading

1. **The interrupt path dropped late-finishing shards.** Results were collected inside the
   `KeyboardInterrupt` handler, so a shard that finished a millisecond after the signal was discarded
   and its cases read as "never ran" when they had run and passed. Collection now happens after
   `pool.shutdown(wait=True)`.
2. **Parallel completion scrambled the report.** Workers complete out of order, so row order changed
   run to run and the report could not be diffed against the previous one. Sorted back into `CASES`
   order.
3. **An interrupted run exited 1, not 130** — indistinguishable from a run that found a vacuous
   assertion. The first is nothing; the second is the whole reason the tool exists.

## The enforcement, and the trap it walked into

Three `bin/check` assertions, each with a `bin/prove` case, **each proven by breaking it**: the copy is
taken, cases are applied to `work / relpath` rather than `ROOT`, and the signal registration exists.
The second one matters — taking a copy and then writing to `ROOT` anyway is the same defect with more
code in front of it, so the assertion has to name where the write *lands*.

These are **the only self-targeting cases in the table**, and the first draft failed instantly:

```
✗ prove: every `del` payload occurs exactly once in its target
    'signal.SIGTERM, signal.SIGHUP' x2
```

Every other case stores its payload in `bin/prove` and deletes it from *another* file, so the payload
occurs once in its target. These target `bin/prove` itself, so any plainly-written payload appears
twice — in the code and in the CASES table — and the deletion would hit the wrong copy and report on a
mutation that changed nothing. That is the VACUOUS class `CLAUDE.md` records `bin/prove` catching in
three separate rounds; here `bin/check` caught it in 1.8 s.

Resolved with adjacent string literals — `"shutil.copy" "tree(ROOT, work"` — concatenated at **parse**
time, so the AST sees the whole payload while the file text never carries it contiguously.

**739 assertions · 98/98 proven by breaking · 58 script fixtures · 5/5 idempotent · tree untouched.**

## Two things worth carrying

**I reproduced this project's own census rule while measuring the fix.** Mid-run temp copies counted
**5** against 4 workers. Before recording it, I reproduced it by hand: `ls` is aliased to `eza`, and
`wc -l` was counting the header row. The code was right and the instrument was wrong — the fourth time
in this repo, and `CLAUDE.md` says exactly this: *a drift the census reports is a claim about the
census too.*

**The first fix was the instance; the second was the class.** Handling SIGTERM made the 181-second
window survivable. Removing the window removed the question. `bin/check` (736), `bin/prove` (95/95),
`bin/script-conformance`, and `bin/idempotence` were **all green** the whole time the tool enforcing
this project's proof discipline would corrupt the tree if killed — and it was found by a user noticing
five shells in an exit dialog.
