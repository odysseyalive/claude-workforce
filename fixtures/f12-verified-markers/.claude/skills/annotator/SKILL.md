---
name: annotator
description: "Annotate source with provenance"
---
# Annotator

<!-- origin: user | immutable: true -->
> **"Never annotate a file you did not write."**
<!-- /origin -->

Prose that MENTIONS the marker inline: a span opens with
`<!-- origin: user | immutable: true -->` and closes with `<!-- /origin -->`.
That sentence is documentation, not a span.

<!-- QUARRY-GATE START -->
<!-- origin: quarrygen | modifiable: true -->
Run `swiftlint` before annotating.
<!-- /origin -->
<!-- QUARRY-GATE END -->

A fenced example, also not a span:

```markdown
<!-- origin: user | immutable: true -->
> **"An example directive."**
<!-- /origin -->
```

## Workflow
1. `swift test`
