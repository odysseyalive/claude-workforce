# Pass baseline

Identical tree and identical finding to `ratchet-regression`. The ONLY difference is
that `captured-passes` is empty: this baseline was written before PASS-DEAD-SCRIPT
existed, so the finding is INHERITED and exits 0. Same finding, opposite verdict, and
the discriminator is the token set rather than a timestamp or a count.

captured-passes:

| pass | artifact | locus | verdict | state | why |
|---|---|---|---|---|---|
