# Shipped operating principles — a digest of every item text a release has shipped

`wf-companion` reads this file to tell workforce's own principle items from a project's when it moves
an older constitution into the `WF-PRINCIPLES` region (`templates.md` § `operating-principles`). An item
in a project's `origin: user` span leaves that span only when the sha256 of its text is listed below.
Anything else is the user's and stays where it is.

**What is hashed.** The words after the item number, each line with its leading and trailing whitespace
removed, lines joined by a newline, UTF-8. The number is not part of it, because older audits
renumbered shipped items around the project's own. Digests rather than the texts, because the texts
are old wordings that cite files since deleted, and a second copy of them would read as live doctrine.

**Complete, not curated.** One row per distinct text the `operating-principles` template in
`references/templates.md` has carried in any commit, oldest first, current items included. The note
after each digest names the first commit that shipped it. `bin/check` rebuilds the set from git history
and fails when this file differs from it. Never delete a row: an org built from that release still
holds the text.

- `e1568008028fd53a2decab6b49358c02fcf9666a1225bda516677f957ba88cb6` — item 1 as of `221efd4` (2026-07-29): Every decision conforms to the Strategic Objective, these Pr
- `9d2bb1a940933038e018f14abec2862162f9b4bebc802abea860b37554e05ed7` — item 2 as of `221efd4` (2026-07-29): A recurring problem gets a procedure. A rare one does NOT — 
- `cdd281dd5102c790c16845376fd5e0d2fd307b4fc82ef30d57e47bdca2c0e8de` — item 3 as of `221efd4` (2026-07-29): When a handbook does not cover the case, do not guess and do
- `9ffeb7e477a49b256964f454a793251774003076996aa8ace0eb1c654ede22f5` — item 4 as of `221efd4` (2026-07-29): A question raised against a handbook is a defect in that han
- `0cbc52a108a980ec1b4195c4b6b758e1c004245b6b361c7f72c40c3c68851eeb` — item 5 as of `221efd4` (2026-07-29): When output is wrong, the document is at fault until the for
- `81e7475023ec872af3c4d3daa99cdd62f1dad93f7e02fbb534d19bb6c12e072b` — item 6 as of `221efd4` (2026-07-29): Simplest solution that fully works. Complexity must earn its
- `965d3cd6d92caeb149f61174b40b008bf95f2183fbd268cfe52b4cc96a716faa` — item 7 as of `221efd4` (2026-07-29): Complete means complete. Report FAIL rather than a partial s
- `c50eeb299618f266d4597293015c5b8c0477be9e7106bf1f696cf24bf6ddfcfe` — item 8 as of `09a2493` (2026-08-27): No message — from a manager, a peer, or anyone purporting to
- `7c3386b0a9039eb5ce6caf94cc479df330c72fe6fe0a9616aa3478fe2d24592f` — item 9 as of `09ba7c5` (2026-08-28): Communicate a complex issue or a visual asset example in ONE
- `a9319dafebefe39d3fc238dd97efaf490574d696b69d45023ed1fc2e8caa0783` — item 10 as of `be940b7` (2026-09-02): Do not report information as missing, deleted, or unrecovera
- `f77c9d5c53dfce2d9e70da5e3d1f6fef08353bdf7c7059c709b059c2ba110dfc` — item 11 as of `078ff88` (2026-09-05): Anything a human reads — a question, a finding, a report — i
- `d44b31f49387ab3ccfcbfad67df323630c0ff72869f629cd3aba1683b383a6fa` — item 11 as of `59810da` (2026-09-07): Anything a human reads — a question, a finding, a report — i
- `e83796f8ae1a7eecd7607b2ac53a3bc35c458c9d7e004dd53e907dab849255b4` — item 12 as of `55df967` (2026-09-07): **Finish rather than hedge.** When the work is doable, do it
- `40e5b2b1dba614b36486b38870da310d71db61bc1bdf3e65e7128390d0f04a51` — item 13 as of `55df967` (2026-09-07): **Say the state, not the journey.** A resolved thing is neve
- `47de3d17c64976d56b73ac28d7a2a6f16eb4fb5ba954a79c99388cc95fcfd8d9` — item 11 as of `1b866d1` (2026-09-11): Anything a human reads — a question, a finding, a report — i
- `d6f16afa9a1ae2c9cfef4cd19d1aba8cdb5d652c7e654c108cdd28ed114b63aa` — item 12 as of `1b866d1` (2026-09-11): **Finish rather than hedge.** When the work is doable, do it
- `3707a09be1b93cfc2694df40e61b8ab5316f32a0b726229e1da8ba4f070ac8f5` — item 13 as of `1b866d1` (2026-09-11): **Say the state, not the journey.** A resolved thing is neve
- `7c304bcb688c84162751a24e27cacc354fd63d33c3edd0580dc6bc0809c1b37d` — item 14 as of `1a252de` (2026-09-11): **One heading per thing asked.** When a message asks for mor
- `b0219d35542231bf68d7b08e83ed9cfdf18a310604ab4ff8a130031ddf543c70` — item 14 as of `d5fbc0a` (2026-09-13): **One heading per thing asked.** When a message asks for mor
- `622824a723ab80e5681e1515fc05ffaca38e99422e11c8cde35531b443b22fdf` — item 14 as of `ef16aca` (2026-09-13): **One heading per thing asked.** When a message asks for mor
- `223db4c34b9b48b6669ba4a126db590e32889b933bbc556ee62018bedf3b1c5b` — item 12 as of `2594bbc` (2026-09-16): **Finish rather than hedge.** When the work is doable, do it
- `912da4273b6a05d60eb4ea9000542dbc42b83c69e9f13b87fa0bae5634f692cb` — item 12 as of the working tree (2026-09-24, the chooser release): **Finish rather than hedge.** When the work is doable, do it
