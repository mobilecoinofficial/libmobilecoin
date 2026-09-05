#!/usr/bin/env python3
"""Compare the parameter count of every function in libmobilecoin/include
against the committed cbindgen output.

The hand headers are the ones that ship, and nothing else compares them with
the generated declarations.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
GENERATED = ROOT / "libmobilecoin" / "libmobilecoin_cbindgen.h"
HAND_DIR = ROOT / "libmobilecoin" / "include"

COMMENT = re.compile(r"/\*.*?\*/|//[^\n]*", re.DOTALL)
DECLARATION = re.compile(r"\b(mc_[A-Za-z0-9_]+)\s*\(")


def arities(text):
    """Map each function name in text to its parameter count."""
    text = COMMENT.sub(" ", text)
    found = {}
    for match in DECLARATION.finditer(text):
        depth, commas, index = 0, 0, match.end() - 1
        # Generated types nest, so a comma counts only at the top level.
        while index < len(text):
            char = text[index]
            if char in "(<":
                depth += 1
            elif char in ")>":
                depth -= 1
                if depth == 0:
                    break
            elif char == "," and depth == 1:
                commas += 1
            index += 1
        params = text[match.end():index].strip()
        if params in ("", "void"):
            found[match.group(1)] = 0
        else:
            found[match.group(1)] = commas + 1
    return found


def main():
    if not GENERATED.is_file():
        print(f"error: no {GENERATED}", file=sys.stderr)
        return 1
    generated = arities(GENERATED.read_text())
    if not generated:
        print(f"error: no declarations in {GENERATED}", file=sys.stderr)
        return 1

    hand, source = {}, {}
    for header in sorted(HAND_DIR.glob("*.h")):
        for name, count in arities(header.read_text()).items():
            hand[name] = count
            source[name] = header.name
    if not hand:
        print(f"error: no declarations in {HAND_DIR}", file=sys.stderr)
        return 1

    shared = sorted(set(generated) & set(hand))
    mismatches = [n for n in shared if generated[n] != hand[n]]
    # An unmatched name is a header declaring a symbol the generated output does
    # not, which is what a rename or a removal on the Rust side looks like.
    unmatched = sorted(set(hand) - set(generated))
    for name in mismatches:
        print(
            f"{source[name]}: {name} header={hand[name]} rust/generated={generated[name]}",
            file=sys.stderr,
        )
    for name in unmatched:
        print(f"{source[name]}: {name} is absent from the generated header", file=sys.stderr)
    print(
        f"generated={len(generated)} hand={len(hand)} matched={len(shared)} "
        f"unmatched={len(unmatched)} mismatches={len(mismatches)}"
    )
    return 1 if mismatches or unmatched else 0


if __name__ == "__main__":
    sys.exit(main())
