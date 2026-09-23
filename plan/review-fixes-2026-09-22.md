# Review fixes: items 1–11 from the 2026-09-22 overview

Written 2026-09-22, against `main` at `67d9574` (1.66.0). Plan only; nothing here is built yet.

The items are numbered as they were in the overview given in the session: 1–5 need fixing, 6–11 are
optimizations. The order of work below is different from that numbering on purpose (see § Approach).

Baseline to beat, measured this session: `bin/check` → `1404 passed, 0 failed, 6 skipped, 34
warnings`. Two of the six skips are the `install.ps1` parity checks, which skip because `pwsh` is
not installed here (`which pwsh` → not found).

---

## Problems

### 1. `install.ps1` ignores `-Force`, `-NoWire`, `-ConfigDir`
- The three are declared on the inner function (`install.ps1:24`), and the script calls that
  function with no arguments (`install.ps1:992`, `Install-ClaudeWorkforce`). There is no
  script-level `param()`, so `./install.ps1 -Force` binds nothing.
- `install.ps1:922` tests `$args -contains '--no-automode'` inside the function, where `$args` is
  empty. That branch is dead.
- Python selection differs between two paths in the same file: `python` first at `:870`,
  `python3` first at `:927`.
- The bash installer accepts `--user/--project/--no-automode/--no-wire/--force/--config-dir`
  (`install:126-138`); PowerShell honours only the environment-variable forms.

### 2. Dead links to procedures that were removed
- `transfer.md`: `workforce/references/org-config.template.md:387`, `:454`;
  `workforce/references/procedures/audit.md:583`.
- `reconcile.md`: `workforce/references/personnel-templates.md:373`, `:382`.
- Neither file exists (`ls workforce/references/procedures/`). The org-config template is copied
  into user projects, so the dead link reaches them.
- The phantom-command checks under the banner at `bin/check:2777` (scan from about `:2782`, checks ending at `:2823`) catch advertised *commands* with no procedure and phantom `/workforce
  <cmd>` mentions, but not a bare `procedures/<name>.md` or backticked `<name>.md` citation. That is
  why these five survived the removal it describes at `bin/check:2802`.

### 3. The commitments list is noise that only grows
- Items are only ever appended and trimmed to the newest 40 (`workforce/bin/wf-commitments:400-403`,
  `MAX_OPEN = 40` at `:76`). No code path closes an item. The file's own header says closing is a
  judgment a regex shouldn't make (`wf-commitments:32`), which leaves the list with no exit at all.
- The date comes from `payload.get("timestamp")` (`:399`). Every one of the 40 entries in
  `.claude/workforce/commitments.json` has `"at": ""` (read this session), so the Stop payload
  doesn't carry that field.
- The capture patterns (`INTENT`/`SERIES`, `:68-74`) take fragments: the 40 shown at this
  session's start included "finish", "commits", "did nothing". They also include text the
  assistant *quoted* rather than promised, such as "earlier messages in the same chat…", which is
  hook-injected wording.

### 4. User-scope hooks can be written with a path that exists only in one project
- `hook_command` at user scope falls back to `${CLAUDE_PROJECT_DIR}/.claude/skills/workforce/bin/…`
  when the personal install is missing (`workforce/bin/wf-settings-apply:589`). Written into
  `~/.claude/settings.json`, that row fails in every project without a vendored copy.
- Caller: `wf-settings-apply:1917`.

### 5. The docs disagree on which commands need `--execute`
- `SKILL.md:851-854` lists the high-risk and low-risk commands. It omits `hooks`, which
  `procedures/hooks.md:4` calls high-risk with display by default, and `amend`, which takes
  `--execute` (`procedures/amend.md:8`).
- `COMMANDS.md:6` says "`audit` is the exception"; `SKILL.md:862` says `audit` and `sweep`.
- `SKILL.md:854` calls `verify` read-only, while `procedures/verify.md:5` names two write
  exceptions, and `COMMANDS.md:41` describes one of them.
- `COMMANDS.md:219-224` ("the catalogs are not duplicated into this repo… seed the project's
  copy once") contradicts `COMMANDS.md:242-246` and the current design, in which the catalogs ship
  in the install.
- Small errors on the same page: `SKILL.md:856` says "EIGHT names" and lists seven.
  `SKILL.md:250-251` has a doubled "and".

### 6. An AI reviewer is spawned after every reply
- `wf-widen-agent` is a `type: "agent"` Stop hook (`wf-settings-apply:148`, config at `:178-230`).
  `OPT_IN_HOOKS` is empty (`:245`), so it is in `DEFAULT_HOOKS` (`:246`) and the installer wires it
  everywhere. The personal `~/.claude/settings.json` has it (Stop hook types read this session:
  `command, command, agent, command`).
- The "only on turns that earned it" gate is *inside* the agent's prompt (`wf-settings-apply:186-187`: if the flag "does not
  exist, respond {\"ok\": true} and do nothing else"), so the host still spawns the agent on every Stop. `wf-widen:808` records the
  measurement: "over 241 recorded Stops: the agent hook took 2.3 s at its fastest".

### 7. The end-of-turn hooks re-read the whole transcript several times
- `_read_lines` is a full `readlines()` (`workforce/bin/wf-turn-ledger:337-343`). It is called by
  `confirmed_reply` (`:384`), again after a 0.5 s sleep when the reply isn't there yet (`:411-412`),
  and by `turn_counts` (`:431`).
- `wf-widen` calls `turn_counts` (`wf-widen:599`), `confirmed_reply` twice (`:904`, `:944`), and a
  full read again in `audited` (`:815`). `wf-commitments` calls `confirmed_reply` (`:374`). Each hook
  is a separate process, so nothing is shared between them.
- Cost: one full read of a 31 MB transcript took 349 ms (measured by the review agent this
  session; re-measure in step 7a).

### 8. The pre-edit origin check does uncached whole-history work
- Every Edit/Write runs a full `git log --format=…%B` (`workforce/bin/wf-code-origin:61`) and a
  whole-file `git blame --line-porcelain` (`:107`), with a 4 s timeout and silent output when it
  expires (`:36`, `:53-55`).
- `blame` on `bin/check` took about 0.99 s (measured by the review agent; re-measure in 8a).
- The SHA regex accepts only 40 hex characters (`:111`), which fails on SHA-256 repositories.

### 9. `SKILL.md` is 93 KB and loads on every `/workforce` command
- `wc -c workforce/SKILL.md` → 93,649. The immutable directives block runs `:47`–`:721`: 55,590
  bytes, of which the quoted user lines (`^>`) are 10,074. The other ~45 KB is model-written
  attribution, rationale, and dated amendment notes (for example the "Amended 2026-09-10" and "Amended
  2026-09-11" paragraphs at `SKILL.md:581` and `:591`).
- `SKILL.md:51-52` says mechanics "live in `references/`, never inside this block", and the block
  breaks its own rule.
- Everything inside the markers is guarded as the user's text (`wf-protect-directives`, and the
  reminder hook in the frontmatter at `SKILL.md:15`). So no pass can trim it, even though most of it
  isn't the user's words.
- Outside the block, the history asides ("Corrected …", "Amended …", "Measured …") are the
  remaining bloat. The review agent's estimate was 21% of SKILL.md outside quotes and 12–27% of the
  largest references (an estimate, re-measured in step 9a).

### 10. `bin/check` is one 17,463-line file
- `wc -l bin/check` → 17,463; 4,311 comment lines (`grep -c '^\s*#'`).
- The review agent found about 1,034 `check(` calls at top level with no module structure (the review agent's count, unverified), and
  helpers redefined in place: `_put` at `:3869` and `:4445`, `_rv_put` at `:4046` and `:17156` with
  different signatures.
- It reads the same files repeatedly through an uncached `read()` (`bin/check:112`).
- `bin/prove` (2,799 lines) proves checks by mutating files with byte-exact literals, for example
  `bin/prove:410`, which deletes a line of `wf-turn-ledger`. Any refactor in items 7, 8, 10 and 11
  moves text that `prove` cases target.

### 11. Helpers copied across shipped scripts
- `config_root()`: `wf-catalog:150`, `wf-census:39`, `wf-code-eval:63`, `wf-context:57`,
  `wf-preflight:59`, `wf-runlength:97`, `wf-settings-apply:348`.
- `_sibling`: `wf-catalog:1042`, `wf-code-eval:90`, `wf-commitments:47`, `wf-companion:366`,
  `wf-settings-apply:67`, `wf-widen:81`. `_load_sibling`: `wf-conform:34`, `wf-remainder:98`,
  `wf-stamp:305`.
- `installed_version`: `wf-changes:47`, `wf-companion:125`, `wf-conform:70`.
- `bin/check:15888` asserts `"def installed_version" in _st_cnf`, so at least one check pins a
  helper's definition by text.

---

## Approach

Three rules apply to the whole plan.

1. **Every change goes through `engineering-coder`, one batch at a time on the shared checkout.**
   Inline edits have skipped `prove` and evaluation before, and concurrent batches have raced on
   `git add` and `bin/check` (unverified: the operator's memory notes "build through
   engineering-coder" and "serialize in-session coder batches"; they are the reason for the
   process here, not for any code step).
2. **Every behaviour fix lands with the check that would have caught it**, and the check is proven
   by `bin/prove` breaking it. This is the "detector ships with its fix" directive (`SKILL.md`
   § Directives, 2026-08-05).
3. **Settings and JSON files are edited surgically**, never loaded and re-dumped, because `prove`
   matches byte-exact literals (unverified: the operator's memory note "structured edits must be
   surgical").

**Order: small bugs first, then the hook costs, then the structural refactors.** Items 7, 8, 10
and 11 all move text that `bin/prove` targets, so they go last and one at a time. Each batch has a
green `bin/check` and `bin/prove` as its exit gate before the next starts. Item 9 touches the
user's directives block and cannot start until the operator decides the Human gate below.

Alternatives considered and rejected:
- *Fix 10 and 11 first so later work lands in the new layout.* Rejected. Those are the riskiest
  changes, and doing them first would put every small fix behind them.
- *For item 6, spawn the reviewer from `wf-widen` with `claude -p`.* Rejected. It is a headless
  session on the user's account from inside a hook, and it is harder to time out and see than the
  channel below.

---

## Steps

### Batch A: bugs (items 1, 2, 4, 5)

**1a.** Add a script-level `param([string]$ConfigDir='', [switch]$Force, [switch]$NoWire,
[switch]$NoAutomode, [ValidateSet('user','project')][string]$Scope)` at the top of
`install.ps1`. Call `Install-ClaudeWorkforce @PSBoundParameters` at `:992`. Each parameter
still falls back to its `$env:WORKFORCE_*` twin, because the `irm | iex` form can't pass
parameters.
**1b.** Replace the dead `$args` test at `install.ps1:922` with `$NoAutomode`. Give `:870` and
`:927` one shared Python finder with a single order: `python3`, `py -3`, `python`. It must skip
the Microsoft Store stub by running `--version` and rejecting a failure.
**1c.** `bin/check`: add a static assertion that `install.ps1` declares a script-level `param(`
and splats it, so it runs without `pwsh`. Add a `bin/prove` case that removes the splat and
expects the check to fail.

**2a.** Re-point the five citations to where each rule now lives. The ORG-rationale bans and
"a conflict is not consent" go into `personnel-templates.md` itself. The model-change-on-move
note goes to `org-config.template.md` § Employee overrides. If no live section holds a rule, its
text moves inline next to the citation.
**2b.** Extend the phantom checks at `bin/check:2777-2823`: every `procedures/<name>.md`, and
every backticked `<name>.md` that names a removed command, must resolve to a file. Add a
`bin/prove` case that re-inserts `transfer.md` and expects a failure.

**4a.** `wf-settings-apply:589`: at user scope, when the personal install is absent, refuse
instead of falling back. Return no command and print one line to stderr saying the personal
install is missing. The caller at `:1917` skips that hook and counts it as not wired, never
failed-open into a bad row.
**4b.** Add a check through the existing fixture harness: user scope with no personal install
must write zero rows. Add the matching `prove` case.

**5a.** Make `COMMANDS.md` the one table that classifies every command: display+`--execute`,
runs immediately, or consent-on-invocation. It covers all 25 commands in the `SKILL.md`
description line, including `hooks`, `amend`, `update`, `checksums`, `model-map`, `principles`,
`defect` and `wrap`. `verify` is listed as "runs immediately, two narrow writes", citing
`verify.md:5`.
**5b.** Replace the two lists at `SKILL.md:851-854` with a one-line pointer to that table.
Replace `COMMANDS.md:6` so it names both exceptions. Delete `COMMANDS.md:219-224`. Fix "EIGHT"
at `SKILL.md:856` and the doubled "and" at `:250-251`. The `:250-251` fix is inside the
immutable block, so it waits on Human gate G1.
**5c.** `bin/check`: each command named in the `SKILL.md` description has exactly one row in the
`COMMANDS.md` table, and a procedure whose line 1–10 says "High risk" or shows `[--execute]`
must be classed display in that table. Add the `prove` case.

### Batch B: the commitments list (item 3)

**3a.** Date entries from the hook's own clock (`datetime.now(timezone.utc)`), not from
`payload["timestamp"]`.
**3b.** Tighten `capture()`:
- at least 3 words, starting with a verb;
- drop text inside quotes or code spans;
- drop text that matches any hook-injected additionalContext of this session (the
  `wf-task-tag` USER_WORDS text is the known source);
- collapse near-duplicates (one is a prefix of another).
**3c.** Give items an exit that isn't a regex judging "done":
- each item carries `shown` (SessionStart count) and `at`;
- an item drops after it has been shown at 3 session starts, or after 7 days, whichever is first;
- SessionStart lists only the newest 10.
The operator can adjust these numbers under Open question Q2.
**3d.** One-time cleanup when the new version first loads: an existing ledger whose entries all
have empty `at` is reset rather than carried. Those entries can't be aged, and the capture
patterns that produced them are replaced. This is a heal on update, so no project needs a manual
step.
**3e.** Checks and `prove` cases:
- a fragment ("finish") isn't captured;
- a quoted hook phrase isn't captured;
- `at` is non-empty;
- an item shown 3 times is gone at the fourth SessionStart.

### Batch C: the per-turn reviewer (item 6)

**6a.** Move the gate out of the agent. `wf-widen` already decides on every turn whether the
turn earned review, and it writes the flag. On a flagged turn it returns a Stop
`decision: "block"` with a `reason`. The reason tells the main session to spawn one independent
reviewer with the flag path, and says the reviewer's verdict is the result. On an unflagged turn
it returns nothing, so nothing spawns. The reviewer is still a separate fresh agent, which the
2026-09-09 directive requires ("Evaluations are always done by the independent agent").
**6b.** Retire `wf-widen-agent` from `SHIPPED_HOOKS`/`AGENT_HOOKS` (`wf-settings-apply:148`,
`:178-230`). Add it to the retired set so `update`, `audit` and `verify` all remove the existing
agent-type Stop rows from settings files. Those are the three paths (`SKILL.md` § Directives,
2026-09-07).
**6c.** Move the reviewer instructions that now live in the hook prompt into
`references/senses.md`. The `AGENT_HOOKS` comment already says that file is where the procedure
belongs. The block reason then names the file rather than carrying the text.
**6d.** Checks:
- no `type: "agent"` hook in `DEFAULT_HOOKS`;
- `wf-widen` emits a block only when it wrote a flag in the same run;
- the heal removes an existing `wf-widen-agent` row from a fixture settings file.
Each gets a `prove` case.

### Batch D: transcript reads (item 7)

**7a.** Re-measure first: time `_read_lines` on the largest transcript under
`~/.claude/projects/`, and time the three Stop hooks end to end on it. Record the result in
`measurements/2026-09-2x-stop-hook-cost.md`.
**7b.** Replace the full read in `wf-turn-ledger` with a tail reader that seeks from the end in
256 KB blocks until it passes the last user row. Keep a per-process memo keyed by
`(path, size, mtime)`, so `confirmed_reply`, `turn_counts` and `audited` share one read inside
each hook.
**7c.** Keep the 0.5 s retry at `:411`, but re-read only the new bytes (from the old size to the
new size).
**7d.** Update the `bin/prove` cases that target the old lines, such as `bin/prove:410`, in the
same change. Re-measure, and record the before and after in the same measurement file.

### Batch E: pre-edit origin check (item 8)

**8a.** Re-measure `wf-code-origin` on `bin/check`, and on the largest repository under `~/lab`
by commit count.
**8b.** Cache the commit-origin map (the output of `:61`) in `.git/wf-code-origin/` keyed by
HEAD sha. A new HEAD reads only `git log <cached-head>..HEAD` and merges it in.
**8c.** Cache the blame per `(HEAD, path, blob sha)` in the same directory. On a timeout, print
one line saying origin is unknown for this file. Never go silent, because silent output reads as
"no human lines".
**8d.** Widen the regex at `:111` to `[0-9a-f]{40,64}`.
**8e.** Checks:
- a second call with the same HEAD runs no `git log` (count subprocess calls in the fixture);
- a timeout produces the "unknown" line;
- a 64-hex blame line parses.

### Batch F: shared helpers (item 11)

**11a.** Create `workforce/bin/wf_lib.py`, shipped by a new manifest row, with `config_root`,
`sibling` (the `_sibling` body, keeping `dont_write_bytecode`), and `installed_version`. Each
script loads it with a three-line path import that is identical in every script. The
three-line stub is the one piece still copied, and it replaces the 19 full helper definitions
listed in Problem 11.
**11b.** Convert scripts in groups of 3–4, with `bin/check` and `bin/prove` green after each
group. Update the text-pinning checks, such as `bin/check:15888`, to look at `wf_lib.py`.
**11c.** Add a check: `def config_root`, `def _sibling`, `def _load_sibling` and
`def installed_version` appear nowhere in `workforce/bin/` except `wf_lib.py`.

### Batch G: split `bin/check` (item 10)

**10a.** Memoise `read()` at `bin/check:112`. This is the only behaviour change in the batch.
**10b.** Split mechanically, with no edits to any check body, into `bin/check.d/NN-<area>.py`.
The areas follow the existing `# ─────` banners, such as the one after `:2823`. `bin/check`
becomes a driver that runs the parts in order in one namespace, so shared state and helper
definitions behave exactly as they do now.
**10c.** Rename the colliding helpers (`_put` at `:3869`/`:4445`; `_rv_put` at `:4046`/`:17156`)
to names local to their part.
**10d.** Update `bin/prove`'s file targets for any case that mutates `bin/check` itself. Update
each place `bin/check` reads its own source to read the part file. Count them first with
`grep -n "__file__\|\"bin/check\"" bin/check`; the review agent counted 11, which is unverified until that runs.
**10e.** Exit gate: the pass, fail, skip and warn counts are identical to the pre-split run, and
the list of check names is identical (`bin/check` output sorted and diffed).

### Batch H: SKILL.md size (item 9), after Human gate G1

**9a.** Measure. Record the byte counts of the block, the `>` quotes, the attribution lines and
the rest, plus the history-aside share of `SKILL.md` and the five largest references.
**9b.** Within the operator's G1 choice, move each directive's model-written rationale and dated
amendment notes to a new `workforce/references/directives-notes.md`. Keep one note per
directive, in the same order, under the same date heading. In `SKILL.md`, each directive keeps
its `>` quotes byte-for-byte and its one-line `— Added <date>, source: …` attribution, plus a
link to its note.
**9c.** Outside the block, remove the "Corrected/Amended/Measured <date>" asides from `SKILL.md`
and the five largest references. Where the aside still explains the current rule, keep one
sentence of the why without the date story. The history stays in git and `workforce/changes/`.
**9d.** Checks:
- every `>` line in the block before the change is present, byte-identical and in the same
  order after it. Diff the extracted quote lines against a snapshot taken at 9a;
- `SKILL.md` ≤ a byte ceiling set from the 9b result;
- every directive has a note in `directives-notes.md`.
Update `wf-protect-directives`' `.directives.sha` for the new block through `checksums`, not by
hand.

### Close

**C1.** After the last batch, run `/workforce dev wrap` for one version bump covering the
session (unverified: the operator's memory note "version bump per session"). Then `bin/sync
--personal` so the change reaches the personal install on `update`.

---

## Files touched

| Item | Files |
|---|---|
| 1 | `install.ps1`, `bin/check`, `bin/prove` |
| 2 | `workforce/references/org-config.template.md`, `workforce/references/personnel-templates.md`, `workforce/references/procedures/audit.md`, `bin/check`, `bin/prove` |
| 3 | `workforce/bin/wf-commitments`, `bin/check`, `bin/prove`, fixtures under `fixtures/` as needed |
| 4 | `workforce/bin/wf-settings-apply`, `bin/check`, `bin/prove` |
| 5 | `COMMANDS.md`, `workforce/SKILL.md`, `bin/check`, `bin/prove` |
| 6 | `workforce/bin/wf-widen`, `workforce/bin/wf-settings-apply`, `workforce/references/senses.md`, `workforce/references/procedures/hooks.md`, `manifest.txt` if a row changes, `bin/check`, `bin/prove` |
| 7 | `workforce/bin/wf-turn-ledger`, `workforce/bin/wf-widen`, `bin/prove`, new `measurements/2026-09-2x-stop-hook-cost.md` |
| 8 | `workforce/bin/wf-code-origin`, `bin/check`, `bin/prove` |
| 9 | `workforce/SKILL.md`, new `workforce/references/directives-notes.md`, the five largest references, `manifest.txt`, `bin/check` |
| 10 | `bin/check`, new `bin/check.d/*.py`, `bin/prove` |
| 11 | new `workforce/bin/wf_lib.py`, `manifest.txt`, the 14 scripts in Problem 11, `bin/check`, `bin/prove` |
| Close | `workforce/references/version.md`, `workforce/changes/*` via `wrap` |

---

## Verification

After each batch, and at the end:

```
bin/check                         # ≥ 1404 passed, 0 failed; skips ≤ 6
bin/prove                         # every case, including the new ones, proves its check
git status --short -- workforce/  # non-empty when a batch touched shipped files
```

Per item:
- **1**: The static check in 1c passes. If `pwsh` can be installed, the two skipped parity checks
  now run and pass (see Q3).
- **2**: `grep -rn "transfer\.md\|reconcile\.md" workforce/` returns nothing.
- **3**: In a new session, the SessionStart list shows at most 10 items, each with a date, and
  none shorter than 3 words.
- **4**: `bin/dev-sandbox` with no personal install, wiring user scope, leaves no
  `${CLAUDE_PROJECT_DIR}` row in the sandbox `settings.json`.
- **5**: The table in `COMMANDS.md` has 25 rows, and `bin/check` 5c passes.
- **6**: After `update`, `python3 -c` over `~/.claude/settings.json` shows no Stop hook of type
  `agent`. An unflagged turn produces no subagent in the transcript.
- **7 and 8**: The before and after timings in the measurement file show the drop.
- **9**: The quote-snapshot diff from 9d is empty, and `wc -c workforce/SKILL.md` is under the
  new ceiling.
- **10**: The sorted check-name lists before and after are identical.
- **11**: `grep -n "^def config_root\|^def _sibling\|^def _load_sibling\|^def installed_version"
  workforce/bin/*` matches only `wf_lib.py`.

---

## Human gates

**G1: what may move out of the directives block (item 9).** The block is marked
`origin: user | immutable: true`, and only about 10 KB of its 55.6 KB is your quoted words. The
rest is model-written explanation. Moving it touches text that sits inside your sacred block, so
this is your call, not the plan's. Batch H doesn't start until you pick one:
- **(a) Recommended.** Keep your `>` quotes byte-for-byte and one attribution line each. Move the
  model-written rationale and amendment notes to `references/directives-notes.md`. `SKILL.md`
  drops by about 40 KB, and none of your words change.
- (b) Leave the block exactly as it is. Only do 9c, which covers the asides outside the block.
  That saves much less, and the block keeps growing with each new directive.

---

## Open questions

**Q1: item 6 channel.** The plan uses a Stop `block` whose reason tells the main session to spawn
the reviewer. That costs one visible extra step on flagged turns only, which the flag rate
recorded in `wf-settings-apply` (0.5% and 1.5% of 1,495 turns) puts at a small share. The other
option is to keep an agent hook but register it only when the host supports a conditional agent
hook. No such feature is documented today (unverified). **Recommendation: the block reason.**

**Q2: commitments retention numbers.** The plan uses 3 session starts or 7 days, and shows 10.
**Recommendation: keep these.** They are easy to tune later, because they are constants in one
file.

**Q3: `pwsh` for the parity checks.** Two `install.ps1` checks are skipped because `pwsh` isn't
installed. Installing `powershell-bin` from the AUR would turn them into real checks for item 1.
**Recommendation: install it.** The static check in 1c is the fallback if you don't.

---

## Risks

- **`bin/prove` literal targets (items 7, 8, 10, 11).** Moving text breaks `prove` cases that
  delete or alter byte-exact lines, such as `bin/prove:410`. The mitigation is updating those
  cases in the same batch, with a green `bin/prove` as the exit gate. If that is missed, the
  cases fail loudly, so the risk is lost time, not a silent gap.
- **Item 6 removes a live hook from every machine.** If the block channel is wrong, flagged turns
  stop being reviewed at all. Batch C's check asserts that a flagged turn emits the block before
  the old hook is retired. Retirement is reversible by re-adding the row.
- **Item 3 resets existing ledgers (3d).** The current 40 entries are lost. They have no dates
  and are mostly fragments, and the real items among them are also in session transcripts. This
  can't be undone except from backups of `.claude/workforce/commitments.json`.
- **Item 9 touches the sacred block.** A wrong move changes your words. The 9d quote-snapshot
  diff runs before commit, and `wf-protect-directives` fires on the edit. Git makes it
  reversible.
- **Item 10 split.** Running the parts in one namespace is what keeps behaviour identical.
  Running them as separate modules would change helper scope and could quietly skip checks. The
  10e name-list diff is the guard.
- **Item 11 shared-module load.** If `wf_lib.py` is missing on a host (for example after a
  partial install), every script that imports it fails. The installer's verify step
  (`Verified: N/N files present`) already fails a partial install. The stub should also fail with
  a one-line message naming the missing file.
