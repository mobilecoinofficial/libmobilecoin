#!/bin/bash
# A partial un-patch leaves the module unparseable and the repair is a cmake
# reinstall, so every failure here must abort before the file is touched.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

CMAKE_DIR="$(perl -MCwd -e 'print Cwd::abs_path shift' "$(which cmake)" | rev | cut -d'/' -f3- | rev)"
[ -n "$CMAKE_DIR" ] || { echo "error: $0 cannot resolve the cmake install" >&2; exit 1; }

echo -e "\n### Un-Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The guard tests the expression the sed addresses, so an un-patch of an
# unpatched module exits 1 here.
MSG='[Mm][Ee][Ss][Ss][Aa][Gg][Ee]'
grep -qE "^#[[:space:]]*${MSG}[[:space:]]*\([[:space:]]*FATAL_ERROR" "$IOS_INITIALIZE_CMAKE_FILE" \
  || { echo "error: no commented message(FATAL_ERROR call in $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }
# The address needs a single hash and then the call, so prose that names the
# symbol keeps its marker and a run of hashes is left alone.
# The patch writes its hash at column 0 and keeps the call's own indentation,
# so every line it commented carries the same text between the hash and the
# command name. A line that carries different text was commented by hand, and
# the sed below cannot tell the two apart.
SHAPES="$(grep -E "^#[[:space:]]*${MSG}[[:space:]]*\([[:space:]]*FATAL_ERROR" "$IOS_INITIALIZE_CMAKE_FILE" \
  | sed -E "s/^#([[:space:]]*)${MSG}.*/[\1]/" | sort -u | wc -l | tr -d ' ')"
[ "$SHAPES" -eq 1 ] || {
  echo "error: the commented message(FATAL_ERROR calls in $IOS_INITIALIZE_CMAKE_FILE carry $SHAPES different indentations, so this script did not write them all" >&2
  exit 1
}

sed -i '' "/^#[[:space:]]*${MSG}[[:space:]]*([[:space:]]*FATAL_ERROR/ s/^#//" "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Un-Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Re-Patch file w/ `make patch-cmake` ###'
