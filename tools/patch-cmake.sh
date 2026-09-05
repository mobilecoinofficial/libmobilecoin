#!/bin/bash
# `make setup` depends on this patch, so any failure here must abort the
# script before the success echo.
set -euo pipefail

command -v cmake >/dev/null || { echo "error: cmake not on PATH" >&2; exit 1; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

CMAKE_DIR="$(perl -MCwd -e 'print Cwd::abs_path shift' "$(which cmake)" | rev | cut -d'/' -f3- | rev)"

echo -e "\n### Patching iOS-Initialize.cmake file in $CMAKE_DIR ###"

IOS_INITIALIZE_CMAKE_FILE="$CMAKE_DIR/share/cmake/Modules/Platform/iOS-Initialize.cmake"

[ -f "$IOS_INITIALIZE_CMAKE_FILE" ] || { echo "error: no $IOS_INITIALIZE_CMAKE_FILE" >&2; exit 1; }

# The sed writes a copy, because an in place edit that a later check refuses
# would leave the install half commented and every rerun red.
PATCHED="$(mktemp)"
PROBE_ERR="$(mktemp)"
trap 'rm -f "$PATCHED" "$PROBE_ERR"' EXIT
cp "$IOS_INITIALIZE_CMAKE_FILE" "$PATCHED"

# CMake matches a command name in any case and reads a mode argument exactly,
# so a command name below is spelled out as a list and a mode is taken as written.
MSG='[Mm][Ee][Ss][Ss][Aa][Gg][Ee]'

# The first branch tests the expression the sed addresses. A module carrying
# neither form is one the sed cannot reach, and a commented one is patched.
#
# The hash carries a marker, because the un-patch restores only the lines this
# sed wrote and leaves a call a person commented alone.
if grep -qE "^[[:space:]]*${MSG}[[:space:]]*\([[:space:]]*FATAL_ERROR" "$PATCHED"; then
  sed -i '' "/^[[:space:]]*${MSG}[[:space:]]*([[:space:]]*FATAL_ERROR/ s/^/#libmobilecoin#/" "$PATCHED"
elif ! grep -qE "^#(libmobilecoin#)?[[:space:]]*${MSG}[[:space:]]*\([[:space:]]*FATAL_ERROR" "$PATCHED"; then
  echo "error: no message(FATAL_ERROR call in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# The live call the sed cannot reach leads its continuation line with the mode,
# quoted, bracketed or bare, behind any bracket comments. A mode is followed by
# the message text, so a token that ends its line or runs straight into a
# bracket closer is a value rather than a mode.
if grep -qE '^[[:space:]]*(#\[=*\[.*\]=*\][[:space:]]*)*("FATAL_ERROR"|\[=*\[FATAL_ERROR\]=*\]|FATAL_ERROR)[[:space:]]+[^[:space:]]' "$PATCHED"; then
  echo "error: an unpatched FATAL_ERROR line remains in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# CMake reads the mode through a quoted or a bracket argument, and the sed
# address takes the bare token, so a call in either form survives the sed.
if grep -qE "^[[:space:]]*${MSG}[[:space:]]*\([[:space:]]*(\"FATAL_ERROR\"|\[=*\[FATAL_ERROR\]=*\])" "$PATCHED"; then
  echo "error: a quoted FATAL_ERROR call remains in $IOS_INITIALIZE_CMAKE_FILE" >&2
  exit 1
fi

# The greps above read one line at a time. Loading the copy is what decides,
# because a call spread over several lines or reached through a variable is
# visible only to cmake itself.
#
# The two paths sit on opposite sides of the SDK test a module branches on, so
# a live call under either branch aborts one of the loads.
for SYSROOT in /definitely-not-an-sdk /definitely-not-an-sdk/MacOSX; do
  if ! cmake -DSTUB="$ROOT/tools/cmake-probe" -DMODULE="$PATCHED" -DSYSROOT="$SYSROOT" \
       -P "$ROOT/tools/cmake-probe/probe.cmake" >/dev/null 2>"$PROBE_ERR"; then
    # A probe that cannot read the module reports neither a live call nor a
    # clean one, so it names itself rather than the module.
    if grep -q "PROBE BROKEN" "$PROBE_ERR"; then
      echo "error: the cmake probe cannot read $IOS_INITIALIZE_CMAKE_FILE" >&2
    else
      echo "error: cmake still aborts on the patched $IOS_INITIALIZE_CMAKE_FILE" >&2
    fi
    cat "$PROBE_ERR" >&2
    exit 1
  fi
done

# cat keeps the destination's own owner and mode, which a move out of mktemp
# would replace with a private temporary's.
cat "$PATCHED" > "$IOS_INITIALIZE_CMAKE_FILE"

echo -e "### $IOS_INITIALIZE_CMAKE_FILE Patched ###"

echo -e '```'
cat "$IOS_INITIALIZE_CMAKE_FILE"
echo -e '```'

# shellcheck disable=SC2016  # backticks are markdown, not a subshell
echo -e '### Un-patch file w/ `make unpatch-cmake` ###'
