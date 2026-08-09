#!/usr/bin/env python3
"""Re-encode a KLFC .klc so MSKLC will load it.

KLFC writes plain UTF-8 with LF endings. MSKLC only accepts UTF-16LE with a
byte-order mark and CRLF endings, and fails with a bare "problem loading the
keyboard" otherwise.
"""

import sys


def main():
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        text = f.read().replace("\r\n", "\n")
    with open(dst, "w", encoding="utf-16-le", newline="\r\n") as f:
        f.write("﻿" + text)


if __name__ == "__main__":
    main()
