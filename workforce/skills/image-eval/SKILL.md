---
name: image-eval
description: Evaluate images for AI-generation tells and technique authenticity — signature and watermark artefacts, symmetry, metadata provenance (C2PA, generator strings, trainedAlgorithmicMedia), visual clarity, palette variation and set cohesion. Use after generating or selecting images, when asked whether an image reads as AI-generated, or before publishing visual assets. Report-only.
image_eval_ref_version: 1
allowed-tools: Read, Glob, Grep, Bash, Task
minimum-effort-level: high
strictness: standard
---

# Image Evaluator

Reviews images for the tells a generator leaves and for whether a claimed technique actually
holds. **Medium-disjoint from `ui-design`**: this skill judges image *authenticity*, that one
judges interface *design*. A blank card and an AI-looking card are different failures and
neither absorbs the other.

**Run it as a Task agent.** The session that generated an image cannot grade it.

## Interface

| Row | Contract |
|---|---|
| `Invoke` | `/image-eval <path or glob>`, or as a Task agent with `context: none` |
| `Returns` | A per-image verdict against the required checks, the AI-pattern classes, technique authenticity and set cohesion, plus a metadata-provenance section. When no shell is available the report SAYS the provenance check was not performed; it never omits the section. |
| `Fails` | `exiftool -a -G1 -s <path>`: **0 = exiftool ran, and is not a claim that provenance was checked** — a directory, a non-image, a truncated image and a misspelled tag all exit 0. 1 = file not found, including a glob that matched nothing. 2 = every file failed an `-if`, or the expression is malformed. 127 = the shell reporting exiftool absent. Only the presence of the named group tags carries a verdict. |

## Workflow

1. **Required checks first, mechanically.** Signature and watermark, symmetry, and metadata
   provenance, per [references/image-tells.md](references/image-tells.md) § Required
   verification checks. Do not assume the images are clean.
2. **Provenance is mandatory for anything being published.** Run `exiftool -a -G1 -s` and
   surface C2PA/JUMBF manifests, generator-name strings, IPTC
   `DigitalSourceType: trainedAlgorithmicMedia`, per-image `InstanceID` UUIDs, and XMP
   `xmpMM:History` edit chains. A caller with no Bash grant reports the check as not
   performed rather than passing it silently.
3. **Then the judgment classes** — visual clarity, AI image patterns, technique authenticity
   for the technique actually claimed, and for a set, palette variation and cohesion.
4. **Apply the project's house rules if present**, at
   `.claude/skills/image-eval/CATALOG-ANCHOR.md`. The supersession register there is the sole
   authority that demotes a finding. Absent the file, nothing is demoted.

## Probe

Evaluate one image with `exiftool` available. A correct result carries a provenance section
naming the tags it searched for and whether each was present, a clarity verdict, and a
recommendation — and it never reports provenance as clean on an exit code alone.

## Verification

```
grep -c 'image-eval-ref-version' references/*.md   # 2 — the corpus and its version anchor
```
