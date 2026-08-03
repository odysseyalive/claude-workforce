# Personas and Names

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 0 assertion(s) in bin/check name this file; 1 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- Enforcement: HIGH — name collisions are SILENT. Phase A lint is the blocking backstop. -->

## Names: collisions are silent, and that is the whole problem

Agent identity comes **only** from the `name:` frontmatter field. Subfolders do not namespace
(`platform.md` fact 5). So these two files collide:

```
.claude/agents/eng/reviewer.md     name: reviewer
.claude/agents/docs/reviewer.md    name: reviewer
```

There is no error. One wins, chosen by filesystem read order, and the other employee simply does not
exist — while the org chart lists both and every report says the org is healthy.

**Mitigations, all three required:**

1. **Namespaced names by convention:** `<dept>-<role>` — `eng-reviewer`, `docs-reviewer`. Not because
   the platform namespaces them, but because *we* must.
2. **A uniqueness check at authoring time**, globbing every agent location — `.claude/agents/**/*.md`,
   `~/.claude/agents/**/*.md`, **and `AGENT.md` files under `.claude/skills/**`** — dereferencing symlinks and deduping by resolved target.
3. **A blocking Phase A lint check** (`staging.md`), so a collision stops registration instead of
   being reported after the fact.

**What is not a mitigation: a shipped hook.** Four were inherited from claude-enforcer and removed,
because they had never fired, could not be wired, and duplicated `verify` (`enforcement.md` § Nothing ships dormant).
The residual gap is real and narrow: a collision introduced by hand-editing `.claude/agents/` between
audits goes unnoticed until the next `verify`. A host that wants edit-time detection writes its own
hook.

**Name rules:** lowercase and hyphens only; no colons (reserved for plugin scoping — a file with one
is not loaded); stable once hired. Renaming an employee is a `transfer`, not an edit — the name is
referenced by the chart, the `ORG-CHAIN` blocks of its manager and peers, and its personnel file.

---

## Personas: a stated point of view, not decoration

Every employee gets a persona. It is not flavour — it is what makes an isolated context worth having.
A reviewer that thinks like a skeptic finds different defects than one that thinks like a librarian,
and running both is the only cheap way to get genuinely independent readings of the same artifact.

A persona is **one or two sentences** naming a stance and what it makes the employee notice:

> *"You are a demolition-safety inspector. You assume every removal breaks something downstream and
> you look for the thing that will break before you look for the thing being removed."*

> *"You are a minimalist librarian. You defend against accumulation: every addition must justify the
> cost of being read forever."*

**Bad personas** are job titles restated (*"You are a test writer who writes tests"*) or decorative
character (*"You are a wise old wizard"*). Neither changes what the employee attends to, which is the
only thing a persona is for.

---

## Uniqueness of personas

**Each persona is used exactly once across the whole org.** Two employees with the same stance are
two draws from the same distribution — and when they are used as a panel, agreement between them
means nothing. The value of a panel is that its members are *differently wrong*.

Checked at authoring time, alongside the name check, over the same union glob. Paraphrase counts as a
collision: same core stance in different words is the same stance.

---

## Panels

Where the audit needs judgment it convenes a panel rather than asking the user. A panel is
**perspective-diverse by construction** — members are chosen to fail differently, not to agree:

| Role | Stance |
|---|---|
| domain reader | knows the material; argues from what the artifact actually says |
| skeptic | argues the proposal is wrong; defaults to the conservative option |
| premortem analyst | assumes it shipped and failed; reports the most likely cause |

**Disagreement resolves to the conservative alternative.** Not to a majority vote — a 2:1 split on a
destructive action is not a mandate, and the cost of a wrong conversion is much higher than the cost
of leaving a skill alone.

The recurring roles are implemented by the definitions under `workforce/agents/` — **`manifest.txt` is
the count, and it is not restated here**. Panels assembled for a specific decision draw fresh personas
and must pass the same uniqueness check.

*This sentence said "Three shipped agents" and named three, while `scopes.md` said four and
`staging.md` said six, against a manifest that shipped seven. Three numbers, no two agreeing, none
correct — a restated constant in three files, none of which `bin/check`'s constants pass covered.*
