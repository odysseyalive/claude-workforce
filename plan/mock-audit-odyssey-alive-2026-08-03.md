# Mock audit — `~/lab/odyssey-alive`, `--review`, 2026-08-03

**Run by the author of the patches under test.** Per `CLAUDE.md` § The author is not a cold reader:
the findings below are findings; **a clean result would have proven nothing**. Four defects surfaced,
three of them blocking, and none was findable by re-reading — two were in code written the same day.

**Target untouched.** `find ~/lab/odyssey-alive -newermt '-1 hours' -type f | wc -l` → **0**, before
and after. `git status --short` → 1 line at baseline (an untracked `.code-eval-nudge-ts`), unchanged.
Verified rather than trusted, per `audit-setup.md` § Every writing gate declares its `--review` behavior.

**Coverage, stated rather than implied.** Steps 0.5, 0.7, 0.8, 1, 1a, 1b ran. **The Step 2 org-design
panel and the Step 3 disposition panels were NOT convened** — they are ~6 spawns and nothing in this
change touched them. Step 4b's canary, Step 5's probes, and every writing gate are out of `--review`'s
reach by construction. So this run exercised the *read* half of the procedure and says nothing about
the write half, which remains the project's one unexecuted surface.

---

## The target

| | |
|---|---|
| stack | Next.js 16 / React 19 / Tailwind 4 / Velite, `pnpm` |
| commands | `dev`, `build`, `lint`, `test:copy-truth`, `test:e2e`, `velite`, `feed:fieldnotes` |
| agents | 3 project (all symlinks), 57 in-skill `AGENT.md`, 0 personal |
| markers | 8 families, 102 markers, 11 unpaired |
| immutable blocks | 21 across 11 files |
| wired hooks | 61, **60 of them inside a skill directory** |
| settings | `.claude/settings.local.json` present (282 allow, 0 deny); `.claude/settings.json` absent |

---

## F1 — BLOCKING. Ownership markers were specified as HTML comments inside a JSON file

`enforcement.md` specified deny rules living between `<!-- WORKFORCE-DENY START -->` markers **in the
settings file**, and six lines later correctly said *"Mutate the settings file JSON-aware — parse,
mutate, validate, write."* Both cannot hold. **JSON has no comments.**

```
json.loads('{"a":1, <!-- WORKFORCE-PERMS START --> "b":2}')
  -> JSONDecodeError: Expecting property name enclosed in double quotes
```

A run following the marker half produces a settings file the harness cannot read. Step 6's read-back
would catch it and restore — so it fails *safe*, but it fails **every time**, and `disband`'s "excise
the region" step could never have worked.

**Inherited, and I propagated it into two more procedures the same day** before this run caught it —
`audit-setup.md` § Permissions step 3 and `hooks.md` step 4, both written hours earlier. Five files
carried it.

**Fixed by replacing the mechanism, not patching the syntax.** Ownership is now
`.claude/workforce/.settings-owned.json`, naming the exact values workforce added. That is *stronger*
than a marker region: a marker delimits a **span**, so a user rule that drifts inside it by reformatting
gets excised too; a sidecar names **values**, so removal stays exact however the file is later reordered.
Swept from `enforcement.md`, `SKILL.md`, `audit-setup.md`, `hooks.md`, `disband.md`, and retracted in
`legacy-markers.md`. Assertion added, proven by reinstating a marker spec.

## F2 — BLOCKING. `wf-census` reported 5 name collisions; 3 were false, and a collision halts the run

The three project agents in `.claude/agents/` are **symlinks into their owning skills** — the standard
install pattern for a skill that ships agents:

```
.claude/agents/code-design-advisor.md -> ../skills/code-evaluator/agents/code-design-advisor/AGENT.md
```

`stat -L -c %i` confirms identical inodes: one file, two paths. The census counted both ends as two
occupants of one name. **A collision is blocking** (exit 2, and precondition 1(b) of the
Atomic-or-Absent gate), so this would have halted the audit of a correctly-configured project.

**This is the fourth time a census in this project reported a discrepancy and the target was right.**
`CLAUDE.md` records three; this is four for four, and the rule it states — reproduce by hand before
recording — is what caught it.

**The two survivors are genuine**, verified by distinct inodes and distinct md5s:

| Name | Paths | |
|---|---|---|
| `voice-validator` | `writing`, `newsletter`, `present` | 3 distinct files |
| `image-validator` | `image`, `image-eval` | 2 distinct files |

Fixed: collisions dedupe by `realpath` first, and aliases get their own reported line
(`3 file(s) reachable by >1 path (symlinks — not collisions)`). Re-run: **3 aliases, 2 collisions,
exit 2** — correctly still blocking, for the right two.

## F3 — Step 0.8 said "add only what is absent" without saying absent from *what*

On this target `Agent` is **absent** from `.claude/settings.local.json` (the resolved write target) and
**present** in `~/.claude/settings.json`. Fact 17 says rules concatenate across scopes rather than
replace, so the union already grants it. The two readings give opposite writes, and the wrong one puts
a redundant entry into a file the user owns.

Fixed: absence is judged **against the union of all four scopes**, and the step says so.

## F4 — the real risk was never overwriting. It was *widening*

The target carries **282 narrowly-scoped `Bash(...)` rules and no blanket grant**. Its own
`pnpm test:e2e` and `pnpm test:copy-truth` have **no matching rule** — so an employee whose
`## Verification` names either would prompt.

Step 0.8 as written would have computed "needs `Bash`" and added the bare token. That removes nothing,
so **`0 removed` prints truthfully while the user's entire permissions posture is superseded by a wider
rule.** The directive this step was written from — *"we don't have to overwrite the user's
preferences"* — would have been satisfied to the letter and defeated in substance.

> **Not overwriting a preference is not the same as not defeating it.**

Fixed: step 3b forbids widening a scoped grant into a blanket one. Add `Bash(pnpm test:e2e:*)`, never
bare `Bash`; where the command cannot be scoped, report it and add nothing.

---

## What worked

- **`wf-conform` correctly reported `0 governed · 3 adopted (exempt) · 0 failed`, exit 0** — the
  adopted-agent fix from earlier today holds against a real brownfield tree.
- **Step 0.8's resolve-don't-assume** picked `.claude/settings.local.json` correctly (project
  `settings.json` absent, neither carrying workforce keys).
- **`advisorModel` is present** in the target's settings, so `audit-setup.md:197`'s model-budget
  pre-selection has real input rather than an empty default.
- **The census's hook count matters**: 60 of 61 wired hooks have commands **inside skill directories**,
  which is exactly the load-bearing case `data-skills.md` § Maintainers warns a sweep about.
- Every count reproduced by hand: 57 in-skill agents, 3 project agents, 61/60 hooks.

## What this run could not touch

The transaction order, T5 registration, the sweep, the probe gate, the tier canary, the Step 0.8
**write**, and `/workforce hooks` — **all still never executed**. `hooks.md` in particular is now
specified, asserted, and unrun, which is the same written-and-unexercised state this whole day's work
was about. It is stated here rather than discovered later.

`bin/check`: **493 passed, 0 failed**. Three new assertions, each proven by breaking it.
