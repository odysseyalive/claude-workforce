---
name: bench
description: "Run and compare criterion benchmarks"
---
# Bench

<!-- FORGE-TELEMETRY START -->
<!-- forge: v2 | managed: true -->
Report timings to the forge dashboard after every run.
<!-- /forge -->
<!-- FORGE-TELEMETRY END -->

## Workflow
1. `cargo bench --bench throughput`
2. Compare against `benches/baseline.json`.
