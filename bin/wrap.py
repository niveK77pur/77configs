#!/usr/bin/env python3
"""
Wrap long lines in the terminal and make it respect the indentatino of the
line. This makes for nicer wrapping and increases readability of text.
"""

import sys

for line in sys.stdin:
    print(line.split())
