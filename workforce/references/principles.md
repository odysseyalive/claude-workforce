# Principles

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 2 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- Enforcement: MEDIUM — the reasoning `SKILL.md`'s Core Principles compress. Read once. -->

`SKILL.md` states its principles in a paragraph each. This file explains the three that are most
often violated by well-intentioned changes, and records what each one is defending against.

---

## 1. Measure, don't assume

**The rule:** platform behavior is established by canary, on the host, at a known harness version.
Documentation is a hypothesis.

**What it defends against:** on 2026-07-29, before any of this system existed, two documented claims
were measured. One held. One did not — and the falsified one had already been designed into a
*blocking* enforcement gate. Shipped, that gate would have refused valid handbooks for a reason that
is not true, and the refusal would have looked authoritative.

**How it shows up in the design:** `platform.md` splits MEASURED from DOCUMENTED and bars DOCUMENTED
facts from becoming blocking checks. Facts carry the harness version they were measured on and go
stale on upgrade. `staging.md` Phase C measures rather than asserts. Canary prompts say *"report only
what you actually observe; never infer from documentation"* — a canary that reasons from the docs
measures the docs.

**The failure it prevents is specific:** not being wrong, but being *confidently* wrong in a
mechanism that refuses other people's work.

---

## 2. Detection where prevention is impossible — and say so

**The rule:** where a mechanism cannot enforce, it detects, and no document describes it as enforced.

**What it defends against:** the chain of command is the clearest case. `Agent(agent_type)` allowlists
are ignored inside subagent definitions, and `permissions.deny` has no "agent X may not spawn agent Y"
axis. An employee *can* spawn a peer its handbook forbids. What exists is detection: every spawn logs
an edge, and `review` diffs observed edges against the chart.

**Why the wording is load-bearing.** A user who believes the org chart is a sandbox will design
against a guarantee that does not exist. So the chart header carries a mandatory verbatim line saying
prose is advisory, and any document describing the chain as *enforced*, *guaranteed*, *prevented*, or
*sandboxed* is a STOP.

**The general form:** an honest "this detects" is more useful than a comfortable "this prevents,"
because only the first tells you to go look.

---

## 3. Build for the next model

**The rule:** constants stated once; measurements stamped and expiring; prefer deleting to
accumulating.

**What it defends against:** guidance written for a past model's weakness is a live cost, paid on
every spawn, forever. Boris Cherny's account of deleting 80% of Claude Code's system prompt for a new
model generation is the reference point: *"every six months, delete your CLAUDE.md, delete your
skills, delete your hooks. See what the model does."*

**How it shows up:**

- **Constants live in exactly one file.** A tier-limit change should be a one-line edit, not a hunt
  through fifty files for every prose restatement of the old number. A restated constant is a
  `verify` finding — and this rule caught four restatements in this project's own files within an
  hour of being written, plus a fifth the next time the check ran.
- **`update` is a clean full replacement.** No user state lives in the skill directory, so there is
  no clobber risk to weigh against staying current. An update path people hesitate to run does not
  mitigate anything.
- **`ablate` is a first-class command.** Delete handbook lines, re-run the evals, keep what earns its
  place. Ablation without measurement is vandalism, which is why it refuses to run without an eval
  set.

---

## The two failure modes this project cares about most

Everything above reduces to avoiding these:

**Something that reads as success while doing nothing.** A tier past the depth limit that collapses
silently. A frontmatter key that is ignored because it was misspelled. A handbook whose registration
was written through a symlink. A backup that flattened every symlink it was protecting. A setup
question that was never asked. In each case the report says fine and the system is not.

**A document that promises a guarantee the runtime will not keep.** Chain of command described as
enforced. A probe described as verifying frontmatter it cannot see. A gate blocking on a documented
behavior that does not hold.

The first is why so much of this system reports rather than assumes. The second is why the wording
rules are gates rather than style preferences.
