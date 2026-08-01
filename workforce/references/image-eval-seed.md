# Image Evaluator — shipped seed catalog

<!-- Enforcement: 0 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate — run bin/coverage. -->
<!-- This is the SEED for projects that have no image evaluator. It installs
     on absence alone (evaluators.md). A project that already has an image-eval
     receives only NEW entries through the forcible-append mechanism, never a
     replacement of its existing catalog.

     When the project carries a customized image-eval (odyssey-alive's watercolor
     catalog, a photography-style catalog, any medium-specific extension), that
     catalog is canonical and this seed never overwrites it. The append adds
     entries from here that the project's copy does not already carry, into the
     machine-owned region at the bottom.

     Version anchor: 1
-->

## Required verification checks

Perform these before subjective evaluation. Do not skip. Do not assume images
are clean.

### Signature and watermark check

Examine all four corners and edges for AI signatures, watermarks, or artist
attributions.

```
Signature check: [found/none]
- Location: [corner/edge if found]
```

### Symmetry assessment

Evaluate bilateral symmetry. Real images have natural asymmetry. Perfect
mirroring is an AI tell.

```
Symmetry check: [symmetric/asymmetric] — [brief note]
```

### Metadata provenance check

Mechanical check for embedded AI-generation provenance:

```bash
exiftool -a -G1 -s <path>
```

Surface any of:

| Signal | What it means |
|---|---|
| `[JUMBF]` or `[CBOR]` group tags | C2PA / Content Credentials manifest |
| Generator name matching `Google C2PA Core Generator Library`, `OpenAI`, `Midjourney`, `Adobe Firefly`, `Stable Diffusion`, `Flux` | Identifies the generation pipeline |
| IPTC `DigitalSourceType: trainedAlgorithmicMedia` | IPTC standard AI-content tag |
| `InstanceID` UUID | Per-image generation-session identifier |
| `xmpMM:History` with multi-entry array | Edit-chain attribution |

Recommendation logic:
- Clean (no AI metadata) → no action.
- Generator-attributed (any C2PA / IPTC AI tag / generator name) → strip with `exiftool -all=`.
- Provenance-sensitive downstream use → regenerate end-to-end. Pixel-layer invisible watermarks (Google SynthID, Adobe pixel watermark, Stable Signature) survive metadata strip. Removal cannot be locally verified.

---

## Visual clarity

| Criterion | What to flag |
|---|---|
| **Immediate comprehension** | Viewer has to ask "what is this?" |
| **Concrete vs. abstract** | Symbolic shapes, glowing orbs, floating geometry instead of recognizable scenes |
| **Grounded in context** | Visual domain doesn't match the content it accompanies |
| **One concept per image** | Multiple metaphors layered into a single frame |
| **Caption test** | Caption requires explanation of what the image represents rather than extending the argument |

---

## Common AI image patterns

| Pattern | Why it's a tell |
|---|---|
| **Symbolic abstraction** | Light beams, glowing orbs, floating shapes. Stock illustration aesthetic. |
| **Split-screen contrast** | Old vs. new side by side. Requires interpretation, not immediate. |
| **Metaphor stacking** | Gears + rivers + light bulbs in one frame. Conceptual overload. |
| **Generic corporate** | Handshakes, puzzle pieces, targets. Clip-art energy. |
| **Uncanny faces** | Distorted features, wrong finger count, teeth that don't resolve. |
| **Over-rendered detail** | Every surface equally sharp. Lacks selective focus. |
| **Floating elements** | Objects suspended without physical context. |
| **Impossible lighting** | Light sources that contradict each other. Screens emitting focused beams instead of diffused glow. Lamps casting light inconsistent with their type. AI treats "glowing" as a visual effect rather than simulating how light actually propagates. |
| **Plastic skin texture** | Overly smooth, waxy human skin. Common in AI portraits. |
| **Text artifacts** | Garbled letters, nonsense signage, repeated words, misspelled labels. |
| **Symmetry obsession** | Unnaturally perfect bilateral symmetry. Real scenes have asymmetry. |
| **Background blur uniformity** | Entire background at the same blur level. Real depth of field varies. |
| **Spatial depth violations** | Objects spanning surfaces on different planes as if flat. Posters stuck across both a wall and a recessed window, items draped over a depth change without bending. |

---

## Technique authenticity

These checks apply to images rendered in a physical medium style (watercolor,
oil, charcoal, ink). AI generates the *appearance* of a medium without
respecting its physical constraints. The question is always: "Could a skilled
practitioner actually produce this?"

### Watercolor

| Impossible technique | Why it can't exist |
|---|---|
| **White painted over color** | Watercolor is transparent. White comes from unpainted paper. |
| **Light over dark layering** | You can only go darker, never lighter. |
| **Uniformly hard edges** | Water naturally bleeds. Edges vary based on wetness. |
| **Perfect smooth gradients** | Real gradients have blooms, granulation, pigment settling. |
| **Opaque flat coverage** | Watercolor is inherently transparent. |
| **No paper texture visible** | Pigment settles into paper grain, especially in washes. |
| **Crisp fine details** | Pigment bleeds on wet paper. Fine lines feather. |
| **Absent cauliflowering** | Wet-on-drying creates blooms. It's unavoidable. |
| **Symmetric organic effects** | Water doesn't create bilateral symmetry. |

### Oil and acrylic

| Impossible technique | Why it can't exist |
|---|---|
| **No visible brushwork anywhere** | Real paint leaves marks. Even smooth blending shows direction. |
| **Perfectly uniform impasto** | Texture from thick paint varies with pressure and angle. |
| **Colors that don't mix at edges** | Adjacent wet oil bleeds. Clean boundaries require drying time. |

### Ink and charcoal

| Impossible technique | Why it can't exist |
|---|---|
| **Uniform line weight** | Hand pressure varies. Lines thicken and thin. |
| **No smudging in charcoal** | Charcoal is soft. Contact leaves traces. |
| **Perfect hatching** | Hand-drawn parallel lines drift. Perfect regularity is mechanical. |

---

## Image set evaluation

When a project produces multiple images for a single context (article, README,
documentation), evaluate the set as a whole.

### Palette variation

AI image generators tend to lock onto one palette and repeat it. A human artist
varies palette choices based on what each image needs.

| Scenario | Verdict |
|---|---|
| All images share the same dominant colors | Flag as monotony |
| All images use similar color ratios despite different dominant colors | Flag as monotony |
| Each image has a distinct palette fitted to its subject | Good |
| Two share a palette, one differs | Acceptable if intentional |

### Set cohesion

Images should feel like the same project while remaining visually distinct.
Cohesion comes from shared technique and quality, not from repeating the same
colors.

---

## Output format

### Single image

```
## Image Evaluation

### Required Checks
Signature check: [found/none]
Symmetry check: [symmetric/asymmetric] — [brief note]
Metadata provenance: [clean / generator-attributed / fully-tracked]
- Generator: [name or none]
- C2PA manifest: [present/absent]
- IPTC AI tag: [present/absent]
- Recommended action: [none / strip metadata / regenerate]

### Summary
[One sentence overall assessment]

### Flags
[3-5 specific concerns, most severe first]

1. **[Pattern name]** — [location in image]
   - Why flagged: [brief explanation]
   - Suggestion: [concrete fix or regeneration approach]

### Strengths
[2-3 things that work well and should be preserved]

### Single-image recommendation
[Keep as-is / Regenerate with adjustments / Significant revision needed]
```

### Image set

```
## Image Set Evaluation

### Per-image checks
[Per-image signature and symmetry checks]
[Per-image metadata provenance]

### Palette Variation
[Does the set have sufficient color variation?]
- Variation verdict: [sufficient/insufficient]

### Individual Image Notes
[Brief assessment of each]

### Set Cohesion
[Do images feel like the same project while remaining visually distinct?]

### Set-level recommendation
[Which images, if any, need attention]
```
