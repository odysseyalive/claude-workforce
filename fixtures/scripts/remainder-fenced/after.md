---
name: fenced
---
# fenced

## Diagnosis

```bash
# check the process
ps aux | grep native-host
ls /tmp/socket-$USER
```

## Workaround

```bash
kill $(pgrep -f native-host)
```

