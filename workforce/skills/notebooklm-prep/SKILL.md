---
name: notebooklm-prep
description: Prepare material for NotebookLM as three copy-ready parts in a fixed order. The parts are the source text written as plain prose, the reference links checked to load, and the Audio Overview prompt kept under 500 characters. Use when asked to prep, set up or format anything for NotebookLM, to make a NotebookLM podcast or Audio Overview, or to turn a deck, brief, notes or a page into NotebookLM sources. Works as a section with copy buttons inside a shared artifact page, and as plain blocks in the terminal.
lane: writing
allowed-tools: Read, Bash, Write, Edit
strictness: standard
---

# NotebookLM prep

Turns material someone is presenting or studying into what NotebookLM needs to make a good Audio
Overview. The output is always three parts, in this order:

1. **Source text.** The material as plain prose, pasted as one text source.
2. **References.** Bare URLs, one per line, each added as its own website source.
3. **Podcast prompt.** The instruction for the Audio Overview's Customize box.

The format is copied from a page the user approved on 2026-11-16: *"that was perfect."* Keep it
exactly. The user asked for it to apply on its own: *"if anyone asks you to prep a notebooklm for
a podcast, workforce will automatically use this method in the future."*

## Interface

| Row | Contract |
|---|---|
| `Invoke` | Loads on any request to prep, set up or format material for NotebookLM, or to make a NotebookLM podcast or Audio Overview. Also `/notebooklm-prep <material>`. |
| `Returns` | A "For NotebookLM" section with three copy boxes inside a shared artifact page, or, with no page, three plain blocks in the terminal plus the prompt saved to a `.txt` and put on the clipboard. |
| `Fails` | No exit codes declared; the skill ships no script. It fails by listing a URL that was not checked, by stating a character count that was not measured, or by putting an em or en dash in the output. |

## Steps

Write each part to its own plain text file in a working folder first: `source.txt`, `refs.txt`,
`prompt.txt`. Use the session's scratchpad if it has one, or a new temporary directory. The checks
below run on these files, and both output modes are built from them.

1. **Collect the context.** Event, date, audience, the presenter's role, and the time limit. Take
   them from the material and the conversation. Leave out any you cannot find. Never guess one.
2. **Write the source text** (`source.txt`):
   - Open with one context paragraph that carries those facts.
   - Walk through the material in its own order. For a deck, write "Slide N, Title." and then full
     sentences. For a document, follow its sections.
   - Write every statistic out in a sentence that names its source, for example "According to Pew
     Research Center's 2026 survey, 70 percent of U.S. adults use Facebook."
   - Plain prose only, with no markdown, bullets or tables. NotebookLM reads prose best.
3. **Collect the references** (`refs.txt`): one URL per line and nothing else on the line. Check
   that each one loads:

   ```bash
   while read -r u || [ -n "$u" ]; do [ -n "$u" ] && timeout 30 curl -sL --proto '=http,https' -o /dev/null -A 'Mozilla/5.0' --max-time 25 -w '%{http_code} %{url_effective}\n' "$u"; done < refs.txt
   ```

   List only URLs that come back `200`, each as you wrote it. A redirect that ends at `200` is fine.
   Some sites refuse scripted requests with `403` or `429`. If the session has a browser tool, open
   those there and keep the ones that load. Leave out every URL that still fails, and name each one in
   your reply with its code. The fact it supported stays in the source text with its source named.
4. **Write the podcast prompt** (`prompt.txt`). It must say:
   - who is listening and why, in the first person ("I'm presenting this to ... and I'm using this
     episode to learn it");
   - to go through the material in order;
   - the key themes to explain;
   - to cite each statistic with its source, use local examples, and flag questions the audience
     is likely to ask;
   - "don't invent figures."
5. **Run the checks.** This measures the prompt and finds any dash in any part:

   ```bash
   python3 -c 'import sys
   for p in sys.argv[1:]:
       t = open(p, encoding="utf-8").read().strip()
       d = [n for n, l in enumerate(t.splitlines(), 1) if "\u2013" in l or "\u2014" in l]
       print(p, len(t), "chars", "dashes on lines %s" % d if d else "no dashes")' source.txt refs.txt prompt.txt
   ```

   The prompt must be under 500 characters. Rewrite it shorter if it is not. Replace every em or
   en dash with a comma, a colon, a period or "to", and run the checks again. The number printed
   for `prompt.txt` is the count you show; never estimate it.
6. **Render** in one of the two modes below.

## In a shared artifact page

Use this mode when the material is going into a page, or the user asked for one. Build the page
with the `shared-artifact` skill. Then add the section from
[references/copy-boxes.html](references/copy-boxes.html):

- Paste PART 1's rules into the page's own `<style>`, PART 2's section inside `<main>` with its
  rail entry, and PART 3's script after the `.wrap` element.
- Replace every CAPITALISED placeholder and set `NN` to the section's number. Box 1's label is
  "Slide text" for a deck and "Source text" for anything else.
- Fill each textarea from its file. Write `&` as `&amp;` and `<` as `&lt;`.
- Fill the count line with the number from step 5.
- Keep the one-line instruction above the boxes as it is.

The snippet uses only the template's tokens, so it follows the page into dark mode. Never give it
colours of its own.

## In the terminal

Use this mode when there is no page.

1. Print the paste instruction from the snippet's summary line, then the three parts as three
   separate plain blocks, each under its label: "1. Source text" (or "1. Slide text"),
   "2. References", "3. Podcast prompt". Put the measured count under the prompt.
2. Save the prompt as `notebooklm-prompt.txt` next to the material it came from, or in the current
   directory if the material was not a file. Say the full path.
3. Put the prompt on the clipboard with the first of these that exists: `wl-copy`,
   `xclip -selection clipboard`, `xsel --clipboard --input`, `pbcopy`, `clip.exe`. If none exists,
   say so, and point to the saved file.

## Rules for every output

- **No em or en dashes** anywhere in the three parts or in the text around them.
- **Never invent a figure or a source.** A statistic with no source is left out.
- **Three parts, always in this order**, each separately copyable. Never merge them.
