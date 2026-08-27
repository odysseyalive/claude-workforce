# Org config (frozen fixture — a recorded IC model that --models supersedes)

The recorded IC model below is what the PREVIOUS run chose. The model budget (questions 3 and 4) runs
before the effort budget (questions 5 and 6), so a model passed on `--models` is newer than this file
and must win. The recorded `medium` effort rides along with the superseded model and must NOT be
honoured against the model that replaced it.

## The four lanes
### Analytical
| Tier | Model | Effort |
|---|---|---|
| Lead (2) | `claude-opus-4-8` | high |
| IC (3) | `claude-sonnet-5` | medium |

### Creative
| Creative-text model | `claude-opus-4-6` |
|---|---|
| Creative-text effort | medium |

| Creative-visual model | `claude-fable-5` |
|---|---|
| Creative-visual effort | medium |

### Code
| Code model | `claude-opus-5` |
|---|---|
| Code effort | high |
