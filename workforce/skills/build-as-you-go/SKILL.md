---
name: build-as-you-go
description: A playbook for building one shareable page piece by piece in a live dialogue with a principal, republishing on the same link after every change. Use when asked to "build this with me piece by piece", "walk through it live", "keep it on the same link" or "build as you go", or when someone wants to shape a design in real time into a page they can later share, built from their own documents. Covers the turn loop, the order the page grows in, research briefs, privacy, and the checks before each publish. The page's look comes from the shared-artifact skill.
lane: writing
allowed-tools: Read, Bash, Write, Edit
strictness: standard
---

# Build as you go

One page, built in a live dialogue. The principal is the person who decides what the page says and
who sees it. They walk through it while it grows, often with a client in mind. The page starts as
one diagram and grows into a linked reference document, one change per turn, on one link.

Load the `shared-artifact` skill first. Its house style, template, publish steps and floor apply to
every version. This playbook is the loop around them.

## Before the first version

- Collect the source documents, the sharing rule (private unless the principal says otherwise), and
  the terms that must never reach the shareable page: program names, agreement names, regulated
  detail, internal prices. Write the terms one per line to `terms.txt`.
- Keep the page and its `img/` in a folder of their own, where the principal wants the source kept,
  and `terms.txt` outside that folder. The terms list holds the very names it guards, so it must
  never be served or published.
- Decide now whether to build inline or hand the build to an agent. Inline keeps the live context.
  In the main session, workforce denies the first file change of a turn that spawned no agent,
  once; the retry is allowed, so retry rather than change course mid-turn.

## The loop

1. **Diagram first.** Version 1 is one diagram of the piece under discussion, with no write-ups, no
   code and no demo. It is the thing everyone talks over. A demo puts invented or client data on
   display, so leave it out unless asked.
2. **One change per turn, on the same link.** Republish the same `file_path`, which keeps the URL,
   with a version label such as "Draft 3: questions moved to the end". Never open a second
   artifact for the same page. The masthead reads "Draft N" and the date.
3. **Open every reply with "What changed"**, in a few lines. The principal is reading along.
4. **Confirmation is the walk-through.** Publish, report, and let the next instruction confirm or
   redirect. Never stop to ask whether to go on. Ask with a chooser only for a decision that is the
   principal's own and cannot be undone, such as sharing the page.
5. **The newest instruction wins.** When it contradicts an earlier one, replace the old content
   instead of keeping both, and say in one line what was replaced.

## How the page grows

Add each stage when the principal asks for it, in this order:

1. An overview diagram of the whole system, as one standard plan with no site names. Every part is
   shown and marked built first, next or later.
2. A zoom diagram of the first piece.
3. One major section per overview box, in build order. Each box carries a number chip matching its
   section. Draw each box as a `<g>` holding its `rect` and its text, which the checks rely on.
4. Subsections for the first piece, numbered under its section (N.1, N.2). Each has what it does,
   "From their materials" (document and page), "New versus their plan" with PLAN and NEW tags,
   and its questions.
5. A short stub for each later piece: what it is, with a "not yet fleshed out" chip.
6. In-page links both ways. Each diagram box is an `<a href="#id">` to its section, and each
   section has a "Back to the chart" link.
7. One Questions and answers section at the end, grouped by section number. Each question links to
   its section, and each section links to its questions.
8. A contents rail listing the major sections, with subsections indented.

**Use their own images.** Crop figures from the client's documents (`pdftoppm -png -r 150`, then
an image crop), cite document and page under each, and ship them in the publish call's `files` map.

## Research

Give each research question to its own background agent, read-only, and keep building:

```
Question: <one question>
Read first: <the documents and sites to start from>
Fetch every URL you cite and drop any that does not load.
Lead with your recommendation, then the evidence, in under <N> words.
Edit nothing. Report only.
```

If the session has a `web-search` or `deep-research` skill, name it in the brief as the method.
When a report lands, fold it into its section, republish, and open the reply with the
recommendation. Mark interpretive or unverified points on the page and name who must confirm them.

## Privacy

- The page stays private. Never share it or change who can see it; that is the principal's call.
- Anything the client must not see goes on a separate private notes page.
- Before every publish, `grep -inFf terms.txt <page>.html` must print nothing.
- Before the first share, have an agent that did not build the page check every factual claim
  against the source documents, and fix what it finds. The builder misses its own invented facts.

## Checks before every publish

Serve the page locally, in the background, because the browser tools refuse `file://`:

```bash
timeout 240 python3 -I -m http.server <port> --bind 127.0.0.1 --directory <page folder>
```

A refused first navigation means the server was still starting; retry once. Then, with
playwright-mcp's browser tools or whatever browser automation the session has:

1. SVG text sits inside its box and inside the diagram.
2. The page has no horizontal overflow.
3. Every `href="#x"` has a matching `id="x"`.
4. Several in-page links, clicked, land on their target. Wait about 3 s before reading the
   position, because a long smooth scroll is slow.
5. Every image has `naturalWidth > 0`, and none uses `loading="lazy"`, which leaves blanks in a
   full-page screenshot.
6. One desktop screenshot, plus one at 390 px when the layout changed.

Checks 1, 2, 3 and 5 run as one `browser_evaluate` call. Clicking the links and taking the
screenshots are separate steps:

```js
() => { const bad = [], de = document.documentElement;
  if (de.scrollWidth > innerWidth) bad.push(`overflow ${de.scrollWidth}>${innerWidth}`);
  for (const a of document.querySelectorAll('a[href^="#"]')) { const id = decodeURIComponent(a.getAttribute('href').slice(1)); if (id && !document.getElementById(id)) bad.push(`no id ${id}`); }
  for (const i of document.images) { if (!i.naturalWidth) bad.push(`image ${i.src}`); if (i.loading === 'lazy') bad.push(`lazy ${i.src}`); }
  for (const t of document.querySelectorAll('svg text')) { const r = t.getBoundingClientRect(), o = (t.closest('g')?.querySelector('rect') || t.ownerSVGElement).getBoundingClientRect();
    if (r.left < o.left - 1 || r.right > o.right + 1 || r.top < o.top - 1 || r.bottom > o.bottom + 1) bad.push(`text out of box: ${t.textContent.slice(0, 40)}`); }
  return bad.length ? bad : 'clean'; }
```

Then publish, stop the server, and delete the screenshots and snapshots.

## Pitfalls

- A regex shifting `x="…"` coordinates also matches `rx="…"` and turns boxes into ovals. Match
  `\bx="`.
- The local server sends no charset, so `·`, `–` and `↑` show garbled there. The published page
  is fine; leave the page alone.
