#!/usr/bin/env python3
"""A host adapter in miniature: run `wf-widen` with its path constants patched.

A host that keeps the workforce's state somewhere other than `.claude/workforce/`
loads `wf-widen` by path and reassigns its path constants AFTER the module has
executed. codex-workforce does exactly this (`cwf_codex._patch`), with the values
below. So this driver patches at the same moment and nowhere earlier: a string
joined from a constant at import time is already spelled before the patch lands,
and a driver that patched sooner would pass the very code the real adapter breaks.

Only the PARTS tuples are patched, never a string derived from them. Text that
names one of these directories has to be built from the parts when it is emitted.
"""

import importlib.machinery
import importlib.util
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
WIDEN = os.path.join(ROOT, "workforce", "bin", "wf-widen")
STATE = ".codex-workforce"

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_loader(
    "wf_widen", importlib.machinery.SourceFileLoader("wf_widen", WIDEN))
widen = importlib.util.module_from_spec(spec)
spec.loader.exec_module(widen)
widen.WORK_DIRS = (STATE, "work")
widen.PERF_STORE_PARTS = (STATE, "personnel")
sys.exit(widen.main())
