---
name: widget-coder
description: Changes the widget.
---

# Widget Coder

## Verification
- Check: `pytest tests/test_widget.py -k build` — expect exit 0 (covers `src/widget.py`)
- Regression: `pytest` — expect exit 0
- Negative: `pytest tests/test_widget_rejects.py` — expect nonzero, and it reads `src/widget.py`
