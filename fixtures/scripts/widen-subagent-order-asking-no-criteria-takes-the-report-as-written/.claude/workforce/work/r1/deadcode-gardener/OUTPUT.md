# Dead-code review — viztech-finishes 1.0.0

Mode: report-only, nothing edited.

## DEAD-1 (HIGH) — orphaned ported admin CSS blocks
Three blocks, no selector anywhere in the tree. Guard 4 (string-built selector) cleared.

## DEAD-2 (MEDIUM) — unused public method `poly_is_confirmed()`
No caller in either plugin; guard 9 (public API) says the method is a plugin-internal.

## Cleared, NOT findings
`is_full_mode()` is reached from the template, which grep missed through a variable call.
