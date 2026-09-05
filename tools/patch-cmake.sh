#!/bin/bash
# `make setup` depends on this patch, so any failure here must abort the
# script before the success echo.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

CMAKE_DIR="$(perl -MCwd -e 'print Cwd::abs_path shift' "$(which cmake)" | rev | cut -d'/' -f3- | rev)"

echo -e "\n### Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }

# The sed writes a copy, because an in place edit that a later check refuses
# would leave the install half commented and every rerun red.
PATCHED="$(mktemp)"
trap 'rm -f "$PATCHED"' EXIT
cp "$IOS_INITIALIZE_CMAKE_FILE" "$PATCHED"

# The first branch tests the expression the sed addresses. A module carrying
# neither form is one the sed cannot reach, and a commented one is patched.
if grep -qiE '^[[:space:]]*message[[:space:]]*\(FATAL_ERROR' "$PATCHED"; then
  sed -i '' '/^[[:space:]]*message[[:space:]]*(FATAL_ERROR/I s/^/#/' "$PATCHED"
elif ! grep -qiE '^#[[:space:]]*message[[:space:]]*\(FATAL_ERROR' "$PATCHED"; then
  echo "error: no message(FATAL_ERROR call in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# A leading FATAL_ERROR is a continuation line the sed cannot reach. The second
# form asserts the sed left none of its own address behind.
if grep -qiE '^[[:space:]]*(FATAL_ERROR|message[[:space:]]*\(FATAL_ERROR)' "$PATCHED"; then
  echo "error: an unpatched FATAL_ERROR line remains in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# cat, not mv: the destination keeps its own owner and mode, which a move out
# of mktemp would replace with a private temporary's.
cat "$PATCHED" > "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Un-patch file w/ `make unpatch-cmake` ###'
