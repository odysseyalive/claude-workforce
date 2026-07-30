# Legacy Markers — recognizing a predecessor system by what it emitted

<!-- Enforcement: HIGH — the only sanctioned detector for predecessor artifacts. Names are never the detector. -->

A project workforce lands on may already be managed by another generator. Removing that system —
under `succession: declared` (`conversion-taxonomy.md`) — requires finding everything it produced.

> **Detection is by marker, never by name.**

A generator that was renamed, forked, partially installed, or installed under a different skill name
must still be found. Named skills appear in reports as *examples of what matched* — never as the
thing being matched.

Name-matching also fails in the direction that hurts: it reports success while leaving residue, which
is precisely the confusing half-migrated state succession exists to prevent.

---

## The marker table

Stated once. `bin/check` fails on restatement elsewhere.

| Marker | Regex | Class |
|---|---|---|
| foreign origin span | `<!--\s*origin:\s*(?!user\b)(?!workforce\b)([\w.-]+)` | ownership |
| user immutable span | `<!--\s*origin:\s*user\b[^>]*immutable:\s*true` | **protected — see below** |
| enforcement annotation | `<!--\s*ENFORCEMENT ANNOTATION` | scaffolding |
| route embed | `<!--\s*ROUTE-EMBED START` | scaffolding |
| code-eval embed | `<!--\s*CODE-EVAL-EMBED START` | scaffolding |
| model-lane gate | `<!--\s*MODEL-LANE-GATE START` | scaffolding |
| lane-agent embed | `<!--\s*LANE-AGENT-EMBED START` | scaffolding |
| checksum sidecar | `.directives.sha` at a skill root | scaffolding |
| predecessor ledger | a `ledger/{incidents,decisions,patterns,flows}/` tree | **data — migrate** |

The regexes match **openers only**. A pattern matching both an opener and its closing comment
double-counts every block; the first hand census of a real project reported twice the true count for
exactly this reason.

---

## Disposition by category, never by authorship

"The predecessor wrote it" is not grounds for deletion.

| Category | Disposition |
|---|---|
| **Scaffolding** | delete — embeds, annotations, gates, sidecars, sentinels, the generator itself |
| **Working machinery** — hooks that guard data, scripts that fetch or validate it | **survives.** Re-owned by a data skill, registration rewritten in the same transaction |
| **User content inside a generated file** | **extracted verbatim first**, never deleted |
| **Data** — a ledger, an index, a cache | migrated per `data-skills.md`; enumerate from the **filesystem**, never from the artifact's own index |
| **Unrecognized generated-looking block** | **quarantine to the report.** Never rewritten, never deleted |

The working-machinery row is the one that has teeth. A predecessor commonly writes the hooks that
enforce a project's own safety rules — including hooks that prevent destruction of billable or
irreplaceable data. Deleting by authorship removes them.

The data row has teeth too: a predecessor's index of its own records may be **stale**. Migrating from
the index rather than the filesystem silently drops whatever the index forgot.

---

## The protected class

`<!-- origin: user | immutable: true -->` spans are **the user's own words**, and they routinely sit
*inside* files a foreign generator owns. They are the only content in a managed tree that cannot be
regenerated, reconstructed, or recovered from anywhere but a backup.

Two protections, and both are required because they cover different moments:

1. **The extraction gate** — before *any* deletion in a succession run, every immutable span is
   extracted verbatim and byte-exact, with its source `file:line`, and the count is asserted against
   the census. `N of N`, or the run does not proceed to any deletion.
2. **The directive-touch hard floor** (`discovery.md`) — a standing rule that no remediation may edit
   a span intersecting an immutable block, regardless of what class the finding was.

The gate is one-time and covers the sweep. The floor is permanent and covers everything else.

**Inline user wording inside an old generated block** — quoted phrases predating origin markers, a
sentence in the user's voice inside machinery — is **extracted into proper immutable markers first**,
and only then is the husk upgraded or removed. Recognizing the husk is not permission to discard what
is embedded in it.

---

## Unrecognized blocks quarantine

A block that looks machine-generated but matches no row above is **reported, never touched**.

Pattern-blindness is how user wording inside an old generated block gets destroyed: the block looks
like machinery, so it is treated as machinery, and something irreplaceable inside it goes with it.
An unrecognized marker means the table is incomplete — which is a finding about this file, not a
license to guess.

---

## Reporting

A succession run reports, per marker class: how many were found, how many removed, how many
quarantined, and — for the protected class — how many extracted against how many censused.

**Coverage is a count, never a bare "clean."** A sweep that cannot state its coverage is not evidence
that anything was swept.
