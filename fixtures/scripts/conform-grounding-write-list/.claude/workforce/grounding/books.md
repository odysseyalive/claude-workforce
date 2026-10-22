# books — grounding

## Guardrails — the ynab playbook

(the `/ynab` playbook you own — its payee rules, pulse logs, and the Python scripts that run it: `scripts/*.py`, e.g. `ynab_pull.py`, `reconcile_pulse.py`, `fund_month.py`. The `scripts/ynab-env.sh` shell helper is sourced at runtime, not edited, and `.sh` is deliberately left out of the write glob.)

## Guardrails — relocated rule detail

- Post every expense to a category from the catalog in `.claude/skills/zoho/references/**`.
- The pulse log once named `old_pull.py`, which was removed in the 2026-09 rewrite: `scripts/*.py`.
