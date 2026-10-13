#!/usr/bin/env python3
"""sample — a small module the map is taken of."""

# ─────────────────────────────────────────────────────────────────────────────
# GREETINGS, the section this banner declares
# ─────────────────────────────────────────────────────────────────────────────


def greet(name):
    """Say hello to NAME, once."""
    return f"hello {name}"


class Counter:
    """Counts the things nobody else counts."""

    def bump(self, n):
        """Add N and return the running total."""
        self.total += n
        return self.total


# a plain comment above a def is read as its first line
def farewell(name):
    return f"bye {name}"
