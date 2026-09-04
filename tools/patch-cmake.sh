#!/bin/bash
# `make setup` depends on this patch, so any failure here must abort the
# script before the success echo.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

CMAKE_DIR="$(perl -MCwd -e 'print Cwd::abs_path shift' "$(which cmake)" | rev | cut -d'/' -f3- | rev)"

echo -e "\n### Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The guard tests the expression the sed addresses, so a module the sed
# cannot reach fails here rather than reporting a no-op as success.
grep -qiE '^[[:space:]]*message[[:space:]]*\(FATAL_ERROR' "$IOS_INITIALIZE_CMAKE_FILE" \
  || { echo "error: no message(FATAL_ERROR call in $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The address needs the call before anything but space, so a second run
# finds nothing to comment out.
sed -i '' '/^[[:space:]]*message[[:space:]]*(FATAL_ERROR/I s/^/#/' "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Un-patch file w/ `make unpatch-cmake` ###'
