<!-- wf-upstream: v1 | project=university | row=97 | status=open -->
# university — row 97

- status: **open**
- project root: `<elided for the fixture>`
- source: `.claude/workforce/deferred.md:9` (§Remaining work)
- run id: `not recorded`
- installed workforce: `1.72.0`
- match: loose — names the category in words ('upstream') but no repository path — malformed per deferred.md, recorded as found
- recorded: 2026-09-26

## The row, verbatim

```
| 97 | a row unique to university | An upstream fix. |
```

## Evidence

_The row cites no `path:line`. `deferred.md` calls a row whose `Measured` evidence cannot be re-executed malformed for the same reason a bare flag is, so reproducing this one starts from the text above._

## Closing it

A fix here does NOT close the downstream row. `references/deferred.md`: the row is closed by the downstream run that RE-RUNS its own reproduction and watches it pass, never by an upstream report asserting the fix shipped. Record the release that should do it with:

```
wf-upstream --resolve university--97 --version <X.Y.Z> --execute
```
