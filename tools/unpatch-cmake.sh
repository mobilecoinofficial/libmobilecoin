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
# The address holds the removal to the lines the patch comments out.
sed -i '' '/FATAL_ERROR/ s/^#//' "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Un-Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Re-Patch file w/ `make patch-cmake` ###'
