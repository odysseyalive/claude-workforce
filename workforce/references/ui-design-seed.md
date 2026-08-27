# UI Design Evaluator — shipped seed catalog

<!-- Enforcement (maintainer-facing; bin/ does not ship — on a host this is `/workforce verify`): 1 assertion(s) in bin/check name this file; 4 normative claims total. 8 generic assertions guard it too. Coverage is a floor, not a certificate. -->
<!-- This is the SEED for projects that ship a user interface and have no UI-design
     evaluator. It installs on absence alone (evaluators.md). A project that already
     carries a ui-design catalog receives only NEW entries through the
     forcible-append mechanism, never a replacement of its existing catalog.

     This reviews UI DESIGN — is the interface applied, differentiated, complete,
     responsive, and accessible. That is a medium DISJOINT from image-eval, which
     reviews image AUTHENTICITY (is a picture AI-generated). A blank card and an
     AI-generated card are different failures; keep the two catalogs separate.

     Version anchor: 1
-->

## Required verification checks

Perform these before subjective evaluation. Do not skip. **Evaluate the RENDERED result, not the
source** — a passing test suite asserts structure, and structure is exactly what these checks look
past. The failure this catalog exists for is a page that satisfies every automated assertion and is
still wrong to look at.

### No missing art — a blank or placeholder media slot FAILS

**Every media slot a shipped view declares must render real, intended art.** A blank slot, a broken
image, a framework placeholder, or a slot showing its alt text is a **FAIL** — not a deliberate stage,
not "art pending", not acceptable because the layout still holds.

```
Missing-art check: [pass / FAIL]
- Empty or broken slots: [location of each, or none]
```

**This is the exact hole this catalog was built to close.** A missing card image once passed a full
suite of 451 end-to-end tests, because the tests asserted the card's *structure* and never asked whether
the image inside it resolved. Absence of art read as a deliberate empty stage. It is not: a shipped view
with a hole in it ships the hole.

### Applied theme — no default palette

**The interface must apply a deliberate, distinctive visual system, not a framework's untouched
default.** Two different products rendered in the same out-of-the-box palette is the tell.

```
Theme check: [applied / DEFAULT]
- Evidence: [named palette / typography / spacing decisions, or "framework default"]
```

Measured failure: two unrelated products — a listings tool and a signing tool — both shipped in the
identical framework navy, indistinguishable at a glance, because neither had a design decision applied
over the scaffold. A theme the framework chose is not a theme the product chose.

### Contrast and accessibility

Mechanical where it can be:

| Signal | What it means |
|---|---|
| Text/background contrast below WCAG AA (4.5:1 body, 3:1 large) | Illegible to low-vision users; a failure, not a preference |
| No visible focus indicator on interactive elements | Keyboard users cannot see where they are |
| Missing or non-semantic landmarks / headings | Screen-reader navigation is broken |
| `alt` absent on meaningful images | The image conveys nothing to assistive tech |

```
Accessibility check: [pass / flags]
- Contrast: [pass / list failing pairs]
- Focus visible: [yes / no]
```

---

## Visual hierarchy

| Criterion | What to flag |
|---|---|
| **Differentiated weight** | Everything the same size and weight; nothing leads the eye |
| **One primary action per view** | Two or more elements competing to be the obvious next click |
| **Deliberate spacing** | Uniform default margins everywhere; no grouping by whitespace |
| **Type scale** | Body and heading indistinguishable; no established scale |
| **Alignment** | Elements off a shared grid; ragged edges that read as accidental |

A view where every element has equal visual priority has no hierarchy — the reader has to search for the
action instead of being led to it.

---

## Responsive layout

| Criterion | What to flag |
|---|---|
| **No horizontal overflow** | The page body scrolls sideways at any target width |
| **Reflow, not shrink** | Content scaled down to fit rather than reflowed; tap targets too small |
| **Wide content contained** | Tables, code, diagrams overflow their container instead of scrolling inside it |
| **Breakpoints** | Layout unchanged from desktop to phone; columns never collapse |
| **Images bounded** | An image exceeds its column and forces the page wide |

```
Responsive check: [pass / flags]
- Tested widths: [e.g. 390 / 768 / 1280]
- Horizontal overflow: [none / at which widths]
```

---

## Common default-design tells

| Pattern | Why it's a tell |
|---|---|
| **Untouched framework palette** | The product looks like the starter template, not itself |
| **Placeholder content shipped** | Lorem ipsum, "Card Title", stock avatars left in a shipped view |
| **Single unbroken column** | No layout decision made — everything stacked at one width |
| **System font only, one size** | No typographic system; body and headings identical |
| **Empty states unhandled** | A list with no items renders blank rather than a designed empty state |
| **Every corner the same radius, every shadow the same** | Component defaults, never adjusted to a system |

---

## Output format

```
## UI Design Evaluation

### Required Checks
Missing-art check: [pass / FAIL] — [locations if FAIL]
Theme check: [applied / DEFAULT] — [evidence]
Accessibility check: [pass / flags] — [contrast, focus]

### Summary
[One sentence overall assessment]

### Flags
[Most severe first]

1. **[Criterion]** — [location in the UI]
   - Why flagged: [brief explanation]
   - Suggestion: [concrete fix]

### Strengths
[2-3 design decisions that work and should be preserved]

### Recommendation
[Ship / Fix the FAILs first / Significant redesign needed]
```

**A view with any missing-art FAIL or a DEFAULT theme is not shippable regardless of the other scores.**
Those two are the failures that read as success — the page renders, the tests pass, and it is still
wrong.
