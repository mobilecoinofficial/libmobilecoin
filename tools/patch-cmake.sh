#!/bin/bash
# `make setup` depends on this patch, so any failure here must abort the
# script before the success echo.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

CMAKE_DIR="$(perl -MCwd -e 'print Cwd::abs_path shift' "$(which cmake)" | rev | cut -d'/' -f3- | rev)"

echo -e "\n### Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The first branch tests the expression the sed addresses. A module carrying
# neither form is one the sed cannot reach, and a commented one is patched.
if grep -qiE '^[[:space:]]*message[[:space:]]*\(FATAL_ERROR' "$IOS_INITIALIZE_CMAKE_FILE"; then
  sed -i '' '/^[[:space:]]*message[[:space:]]*(FATAL_ERROR/I s/^/#/' "$IOS_INITIALIZE_CMAKE_FILE"
elif ! grep -qiE '^#[[:space:]]*message[[:space:]]*\(FATAL_ERROR' "$IOS_INITIALIZE_CMAKE_FILE"; then
  echo "error: no message(FATAL_ERROR call in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# A line naming the symbol outside a comment is one the sed did not reach, so
# a module holding one is neither patched nor recognised.
if grep -qiE '^[[:space:]]*([^#[:space:]].*)?FATAL_ERROR' "$IOS_INITIALIZE_CMAKE_FILE"; then
  echo "error: an unpatched FATAL_ERROR line remains in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Un-patch file w/ `make unpatch-cmake` ###'
