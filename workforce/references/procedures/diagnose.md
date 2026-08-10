# diagnose — turn the audit inward and drain what blocks workforce itself

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 7 assertion(s) in bin/check name this file; 8 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
Dev-only. Decides things, so it runs in **display mode** by default and acts on `--execute`
(`SKILL.md` § Display vs. Execute).

```
/workforce dev diagnose            report the blocks and the plan; write nothing
/workforce dev diagnose --execute  drain them to a fixpoint — apply, or dispatch the fix, and loop
```

## Why this command exists

`audit` points workforce at a *target* project. Nothing points workforce at **itself** and asks the
only question that keeps it useful: *are any of its three deliverables blocked right now, and what has
to change in its own source to unblock them?* The three deliverables are the whole job —

- **install** — bring workforce into a new project;
- **update** — advance an existing install without clobbering project state;
- **streamline** — the `audit → org` pipeline that staffs a project with agents and skills.

`/workforce dev audit` already runs inward, but it *builds an org for this repo* — it does not measure
workforce's fitness to keep doing that job on other repos. `diagnose` is that measurement, and — under
the standing directive that **no run leaves a deferment queue behind** — it does not stop at measuring.
It **drains to a fixpoint**: every block it finds is resolved in the same run, new blocks that surface
while resolving are resolved too, and the loop terminates only when all three deliverables are clear.

`diagnose` runs ONLY under `dev`. It inspects `workforce` itself, which is exactly what the
Self-Exclusion Rule reserves for the `dev` escape. Invoked without `dev`, or reached through a routed
ask carrying the token, it STOPs with the self-exclusion message and changes nothing — the token is
never synthesized.

## What it runs — a read-only composite, not a new detector

`diagnose` **invents no new detection.** It orchestrates surfaces that already exist and reads their
output through the install/update/streamline lens:

| Surface (already shipped) | Read as | Deliverable it informs |
|---|---|---|
| `dev audit --review` (self-included, zero writes) | the mock audit — its `INV-*` rows, any `NOT UPHELD`, its Execution-Summary `✗` lines | streamline |
| `verify` | the silent-failure classes — install/scope drift, canary, ghosts, contract-drift | install · update · streamline |
| `preflight` (`wf-preflight`) | settings blockers — deny/ask/classifier/missing grant | install · streamline |
| `invariants.md` | the vocabulary every finding is named against | all three |

The data these return answers the classification directly, so no agent is spawned to *acquire* it — a
spawn is spent only to *author a fix* (below). This is the second standing directive: hand data back
when it answers the question; do not spend a token spinning an agent up to restate it.

## Classifying a finding — which deliverable it blocks

Each finding is placed in exactly one deliverable, by where its failure first bites:

- **install** — a fresh install into a clean project would fail or silently under-deliver: manifest↔tree
  drift, an installer exit path, a missing exec bit, a settings block the installer cannot clear, the
  shadowing personal-install hazard.
- **update** — an existing install cannot advance cleanly: `update.md`'s installer-re-run contract
  broken, a scope-resolution gap, project state that a replacement would clobber.
- **streamline** — the `audit → org` pipeline is degraded: a `NOT UPHELD` invariant, a canary path that
  cannot measure, a conversion or handbook rule a `dev audit --review` self-run surfaces as a `✗`.

A deliverable with no finding is reported **clear, by name** — a zero is a measurement, and silence is
not. A reader cannot tell a passing deliverable from one that was never checked.

## Draining a finding — APPLY-NOW, or ROUTE-AND-IMPLEMENT

There are two dispositions and the run performs both in the same invocation. Neither parks a row:

- **Mechanical / structural → APPLY-NOW.** Fixable by a shipped or maintainer script: apply it, or name
  the single runnable command and run it (`bin/sync`, `bin/check --stamp`, `! wf-settings-apply …`, an
  exec-bit `chmod`). The user is never handed homework a command can perform.
- **Source / doctrine judgment → ROUTE-AND-IMPLEMENT.** Dispatch the maintainer employee that owns the
  surface and have it **implement the fix in this run** — `doctrine-author` for `references/**`,
  `runtime-lead` for the three-copy tree / installers / `platform.md`, `script-author` for `bin/**`,
  `release-verifier` for manifest and ship-vs-contains. It **never records a spec for a later run.**
  Because a detector ships with its fix, every routed fix lands with its `bin/check` assertion and its
  `bin/prove` case, so the block cannot come back unseen. The record lands in `DEVELOPMENT.md` § Open as
  work done this run, never the project-state `deferred.md` (which is a target project's state, not
  workforce's source backlog).

**Then loop.** Resolving a block can surface another — a fix that touches the manifest re-opens the
install check; a doctrine amendment re-opens the streamline check. Re-run the composite and drain again.
The run ends only when a full composite pass finds **zero blocks across all three deliverables**. There
is no fourth disposition, never a bare flag, and never a "what I did not do" section. The one finding
that may survive is one whose resolution lies in **another repository** or past a **measured host
limit**, reported with that citation — never as a refinement left optional.

## Report shape

Opens with the provenance header every diagnostic prints (`verify.md` § Provenance header), scoped
`dev (self)`, then:

```
DELIVERABLE HEALTH
  install     CLEAR | BLOCKED (n)
  update      CLEAR | BLOCKED (n)
  streamline  CLEAR | BLOCKED (n)

BLOCKS  (each drained, in order)
  [streamline]  <finding>  — INV-XXX NOT UPHELD | <verify class>
     disposition: APPLY-NOW → <command run>
                  (or) ROUTE-AND-IMPLEMENT → doctrine-author
     landed: <file:line> + bin/check <assertion> + bin/prove <case>
  …

DRAIN
  passes: <k>   blocks resolved: <n>   surfaced-while-draining: <m>   remaining: 0
  (a nonzero 'remaining' names each survivor and cites its other-repo / host-limit reason)

0 blocks → "All three deliverables clear."
```

Under default (no `--execute`) the same report prints with `disposition` read as *would* and `DRAIN`
showing the plan — report first, act on a separate gesture — but the report still names, per block, the
exact fix it would apply and where it would land. A plan that cannot say how it closes is not a plan.

## Verification

- `/workforce dev diagnose` in this repo prints the DELIVERABLE HEALTH block for install, update, and
  streamline; names each finding against an `INV-*` row or a `verify` class; states the clear case
  explicitly for any unblocked deliverable; and writes nothing.
- `/workforce dev diagnose --execute` against a seeded block (e.g. a manifest row dropped in a
  disposable copy) resolves it — APPLY-NOW runs its command, ROUTE-AND-IMPLEMENT lands a fix plus its
  `bin/check`/`bin/prove` — then loops until `remaining: 0`. It never prints a "what I did not do"
  section and never carries a row forward.
- `/workforce diagnose` (no `dev`) and a routed ask carrying `diagnose` both STOP with the
  self-exclusion message.
