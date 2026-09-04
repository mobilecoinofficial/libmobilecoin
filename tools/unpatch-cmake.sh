#!/bin/bash
# A partial un-patch leaves the module unparseable and the repair is a cmake
# reinstall, so every failure here must abort before the file is touched.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

CMAKE_DIR="$(readlink -f "$(which cmake)" | rev | cut -d'/' -f3- | rev)"

echo -e "\n### Un-Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
grep -q FATAL_ERROR "$IOS_INITIALIZE_CMAKE_FILE" \
  || { echo "error: no FATAL_ERROR line in $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The address needs a single hash and then the call, so prose that names the
# symbol keeps its marker and a run of hashes is left alone.
sed -i '' '/^#[[:space:]]*message[[:space:]]*(FATAL_ERROR/I s/^#//' "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Un-Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Re-Patch file w/ `make patch-cmake` ###'
