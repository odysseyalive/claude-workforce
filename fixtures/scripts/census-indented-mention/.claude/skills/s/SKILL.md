---
name: s
description: "Fixture. One real sacred block at column 0, one indented example of the syntax."
---

# S

<!-- origin: user | immutable: true -->
## Directives

> **"This one is real. It sits at column 0 and MUST be counted."**

*— Added 2026-08-05, source: fixture*
<!-- /origin -->

## Format

An indented block is a markdown code block, so the marker below is documentation
ABOUT the syntax and MUST NOT be counted as a sacred block:

    <!-- origin: user | added: YYYY-MM-DD | immutable: true -->
    ## Directives

    > **"[Original user directive verbatim]"**

    <!-- /origin -->

Counting it inflates the census and makes a directive guard fire on a date format
string. It is reported as a mention rather than dropped, because a number that
shrank without explanation is its own defect.
