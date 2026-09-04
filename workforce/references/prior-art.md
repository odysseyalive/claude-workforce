# Prior Art — search the user's own work before authoring a capability

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 3 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — the only step that looks outside the target project. Skipping it re-invents what the user already built, and nothing downstream can detect that. -->

The step that runs **before** `hire` decides anything. Its question is not "who should do this work"
but "has the user already built this, somewhere I can see?"

**Measured 2026-09-04, `pythom-space`.** An ask arrived through `/org` rung 10(b) — persist what a
working session discovers, so a later session can read it back. `hire` was one step from authoring a
new data skill: a fresh directory tree, a schema derived from the ask, a citation rule invented on the
spot. The user interrupted with one sentence naming two of their own projects. Both already carried
`awareness-ledger`, a skill that did precisely this, with 78 records between them, two maintainer
scripts, a wired capture hook, and months of hardening. **The authored version would have been a
thinner copy of something already working, and nothing in this product would have noticed.**

The cost of the search is one directory listing and one grep. The cost of skipping it is a parallel
implementation that diverges from the original forever.

---

## Why this is not covered by anything already here

`org-design.md` § Evidence, ranked reads the target project. `discovery.md` finds a project's
authoritative material. The `## Sources` criterion wires an employee to truth **inside its own
project**. Every one of them stops at the project boundary — and the user does not. Someone running
workforce across thirty projects is the single most likely author of the thing being asked for.

Directive one makes preservation the floor. A capability the user already built and workforce
re-invented has not been preserved; it has been forked without anyone deciding to fork it.

---

## Deriving the search set

**Mechanically, and never by invention** (Core Principle 5).

1. **The workspace root** is the parent of the project directory. A project at
   `~/lab/pythom-space` gives a workspace root of `~/lab`, and its siblings are the other
   directories in it. This is a heuristic and it is stated as one: a project that is not in a
   workspace of sibling projects yields an empty set, which is a legitimate result.
2. **Additional roots** may be named in `org-config.md` § Prior-art roots. Absent that section, only
   the derived root is searched — never a guessed path, never a hardcoded one.
3. **A sibling is a candidate only if it has `.claude/skills/`.** Everything else in a workspace —
   data trees, game files, upstream clones — is skipped without being read.

```bash
# The whole search. It is this cheap.
ws="$(dirname "$PWD")"
for d in "$ws"/*/; do
  [ -d "$d/.claude/skills" ] || continue
  printf '%s\n' "$(basename "$d")"
  grep -h '^description:' "$d"/.claude/skills/*/SKILL.md 2>/dev/null | head -50
done
```

**Match on what the skill DOES, not what it is called.** The capability asked for and the skill that
provides it rarely share a name — the 2026-09-04 case asked for "a system that saves the data" and
the answer was called `awareness-ledger`. Read the `description:` and `when_to_use:` lines, which
exist to be read this way.

---

## The three outcomes

| Outcome | Meaning | What happens |
|---|---|---|
| `PORT` | a sibling has a skill covering the asked-for capability | the panel does **not** run; the disposition is a port |
| `PARTIAL` | a sibling covers part of it, or covers it in a shape that does not fit | named as a step in the work order; the panel runs on the remainder |
| `NONE` | searched, nothing found | recorded with the count, then the panel runs |

**`NONE` is a measurement and it is reported with its denominator** — `prior art: searched 7 sibling
project(s), no match`. A silent skip is indistinguishable from a search that found nothing, which is
the distinction this whole file exists to preserve.

The run prints **`INV-PRIORART`**:

```
INV-PRIORART  siblings 7 · with-skills 5 · match PORT awareness-ledger (apps-odyssey-alive)
INV-PRIORART  siblings 7 · with-skills 5 · match NONE
```

---

## What a `PORT` obliges

A port is not a copy. Four things are required and each has a failure mode behind it:

1. **Pick the mature copy, and say how you decided.** Where two siblings carry the same skill they
   are usually not the same age. Diff their section sets: the one carrying the data-skill shape
   (`Schema`, `Invariants`, `Degradation`, `Owner`, `Git policy`, `Seed`, `Maintainers`,
   `Interface`) is the converted one. On 2026-09-04 the two copies differed by exactly that, and the
   older one had no maintainer scripts at all.
2. **Adapt to the target, and record every departure beside the thing it governs** — not in a commit
   message, which the next reader will not have. Each departure names what it changed and why.
3. **Run the ported checks before trusting them.** A maintainer arriving from another project has
   been released against *that* project's data. `data-skills.md` § Maintainers governs unchanged: a
   validator that has only ever exited 0 is indistinguishable from `exit 0`. On 2026-09-04 the ported
   script carried a latent defect — an early exit that skipped one of its own invariants — found by
   the first negative test anyone ran against it, and present in the source copies for months.
4. **Fix the source too, or say why not.** A defect found in a port exists in the original. Directive
   *"resolve all issues with pizazz"* is the standing instruction: fix the class, not the instance.

---

## What this step must never do

- **Never read a sibling's data.** The search reads skill *definitions* — `SKILL.md` frontmatter and
  headings. A sibling's ledger, mailbox, credentials, or client records are none of this product's
  business, and a capability search has no reason to open them.
- **Never write to a sibling.** Fixing a defect found by a port is a separate, announced act against
  that project, with its own consent. This step reads.
- **Never let a hit become an automatic install.** `PORT` is a disposition the run reports; the user
  decides. A skill silently copied between projects is the residue directive — *"I don't want to
  leave any of the old system still there that doesn't need to be there"* — arriving from the other
  direction.
- **Never treat a third-party clone as prior art.** A workspace usually holds upstream repositories
  the user does not own. A sibling is prior art only if the user authored it; when ownership is
  unclear, `git -C <dir> remote get-url origin` answers it and an unowned remote disqualifies the
  candidate.

---

## Where this is called from

Both doors an employee comes through, because a rule on one path only is the defect Core Principle 7c
names:

- `hire.md` **Step 0** — the capability-gap path, including everything arriving via `/org` rung 10(b).
- `hire.md` § Initial roster — the greenfield batch, which does not pass through Step 1's panel and
  would otherwise skip this entirely.
- `org-design.md` § Where the greenfield org comes from, concretely — its step 1, so prior art is
  evidence the roster is designed *against* rather than a check applied after the roles are chosen.
