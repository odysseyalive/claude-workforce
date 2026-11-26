#!/usr/bin/env python3
"""Run the repository's own `install` against a fixture tree, offline.

`install` is a bash script, and this harness runs every case as `python3 <script>
--root <tree> <args>`, so a case about the installer names this driver instead. It runs
`bash <repo>/install <args>` with the tree as the working directory, stdin closed, and
`WORKFORCE_REPO_URL` pointed at this checkout (`file://`), so the files it installs are
the ones beside it and no network is touched. Where it installs is the case's own `env`:
`HOME` and `CLAUDE_CONFIG_DIR` are set there, inside `${TREE}`. Inherited `WORKFORCE_*`
variables are dropped, so a maintainer's shell cannot change the scope or the source.
"""

import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

args = sys.argv[1:]
if args[:1] != ["--root"] or len(args) < 2:
    print("usage: install-driver.py --root <tree> [install args...]", file=sys.stderr)
    sys.exit(2)
tree, rest = args[1], args[2:]
env = {k: v for k, v in os.environ.items() if not k.startswith("WORKFORCE_")}
env["WORKFORCE_REPO_URL"] = "file://" + ROOT
p = subprocess.run(["bash", os.path.join(ROOT, "install")] + rest, cwd=tree, env=env,
                   stdin=subprocess.DEVNULL)
sys.exit(p.returncode)
