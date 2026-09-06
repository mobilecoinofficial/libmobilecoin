#!/usr/bin/env python3
"""Compare the doc comment on each mc_ function declared in libmobilecoin/include
against the one on its definition in libmobilecoin/src.

Both sides are written by hand and are meant to say the same thing. No other
check reads either one, so the two texts drift apart as the code changes.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
HAND_DIR = ROOT / "libmobilecoin" / "include"
SOURCE_DIR = ROOT / "libmobilecoin" / "src"

DOC = re.compile(r"^\s*///(.*)$")
COMMENT = re.compile(r"/\*.*?\*/|//[^\n]*")
COMMENT_LINE = re.compile(r"\s*(//|/\*|\*)")
HEADER_DECLARATION = re.compile(r"\b(mc_[A-Za-z0-9_]+)\s*\(")
RUST_DEFINITION = re.compile(r"\bfn\s+(mc_[A-Za-z0-9_]+)\s*\(")


def docs(text, declaration):
    """Map each function name to the normalized doc block above it.

    Only a declaration directly below the block claims it. A finished statement
    or a plain comment in between discards it, so a doc comment on a typedef or
    above a section banner is not credited to the next function.
    """
    found, block, was_doc = {}, None, False
    for line in text.splitlines():
        doc_line = DOC.match(line)
        if doc_line:
            if not was_doc:
                block = []
            block.append(doc_line.group(1).strip())
            was_doc = True
            continue
        if not line.strip():
            continue
        was_doc = False
        if COMMENT_LINE.match(line):
            block = None
            continue
        code = COMMENT.sub(" ", line).strip()
        match = declaration.search(code)
        if match:
            found.setdefault(match.group(1), " ".join(part for part in block if part) if block else "")
            block = None
        elif code.endswith((";", "}")) or line.rstrip().endswith((";", "}")):
            block = None
    return found


def read(directory, pattern, declaration):
    docs_by_name, source = {}, {}
    for path in sorted(directory.rglob(pattern)):
        for name, doc in docs(path.read_text(), declaration).items():
            docs_by_name.setdefault(name, doc)
            source.setdefault(name, path.name)
    return docs_by_name, source


def main():
    hand, hand_source = read(HAND_DIR, "*.h", HEADER_DECLARATION)
    rust, rust_source = read(SOURCE_DIR, "*.rs", RUST_DEFINITION)
    if not hand or not rust:
        print(f"error: no declarations in {HAND_DIR} or {SOURCE_DIR}", file=sys.stderr)
        return 1

    shared = sorted(set(hand) & set(rust))
    drifted = [name for name in shared if hand[name] != rust[name]]
    for name in drifted:
        print(f"{hand_source[name]}: {name}", file=sys.stderr)
        print(f"  header: {hand[name] or '(none)'}", file=sys.stderr)
        print(f"  rust:   {rust[name] or '(none)'}", file=sys.stderr)

    for name in sorted(set(hand) - set(rust)):
        print(f"{hand_source[name]}: {name} is declared with no definition in {SOURCE_DIR.name}", file=sys.stderr)
    for name in sorted(set(rust) - set(hand)):
        print(f"{rust_source[name]}: {name} is defined with no declaration in {HAND_DIR.name}", file=sys.stderr)

    lonely = len(set(hand) ^ set(rust))
    documented = sum(1 for name in shared if hand[name])
    print(f"hand={len(hand)} rust={len(rust)} matched={len(shared)} documented={documented} drifted={len(drifted)} unpaired={lonely}")
    return 1 if drifted or lonely else 0


if __name__ == "__main__":
    sys.exit(main())
