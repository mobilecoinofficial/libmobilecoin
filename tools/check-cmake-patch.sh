#!/bin/bash
# Drive the real patch and un-patch scripts over the fixture set and compare
# each verdict against tools/fixtures/cmake/expected.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURES="$ROOT/tools/fixtures/cmake"
EXPECTED="$FIXTURES/expected"

[ -f "$EXPECTED" ] || { echo "error: no $EXPECTED" >&2; exit 1; }

# A fake install keeps the run off the cmake the developer builds with. It sits
# on PATH ahead of every other one, and the assert below proves it won.
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/bin" "$SANDBOX/share/cmake/Modules/Platform"

# The patch loads its own output, so the sandbox needs a working cmake. A
# wrapper leaves the install directory inside the sandbox, which a symlink would
# resolve away to the real one.
REAL_CMAKE="$(command -v cmake)" || { echo "error: cmake not on PATH" >&2; exit 1; }
printf '#!/bin/sh\nexec "%s" "$@"\n' "$REAL_CMAKE" > "$SANDBOX/bin/cmake"
chmod +x "$SANDBOX/bin/cmake"
MODULE="$SANDBOX/share/cmake/Modules/Platform/iOS-Initialize.cmake"

export PATH="$SANDBOX/bin:$PATH"
RESOLVED="$(command -v cmake)"
[ "$RESOLVED" = "$SANDBOX/bin/cmake" ] || {
  echo "error: cmake resolves to $RESOLVED outside the sandbox, refusing to touch a real install" >&2
  exit 1
}

LOG="$SANDBOX/run.log"

# Echoes "<patch> <repatch> <round trip>" verdicts for the fixture named in $1.
run_fixture() {
  local fixture="$1" rc=0 first_rc=0 patch repatch roundtrip after
  cp "$fixture" "$MODULE"

  rc=0
  "$ROOT/tools/patch-cmake.sh" > "$LOG" 2>&1 || rc=$?
  first_rc="$rc"
  if [ "$rc" -ne 0 ]; then
    if cmp -s "$fixture" "$MODULE"; then
      patch=REFUSED
    else
      # A refusal that already moved the file leaves the module half written.
      echo "exit=$rc" >&2
      cat "$LOG" >&2
      patch=REFUSED_DIRTY
    fi
  elif cmp -s "$fixture" "$MODULE"; then
    # Legitimate only for a module that is already patched, so the row for
    # every other fixture names CHANGED and a silent no-op fails against it.
    patch=NOOP
  else
    patch=CHANGED
  fi

  # A zero exit has to leave no live call behind. The first expression reads a
  # call the sed address skips, and the second a mode that leads its own line.
  if [ "$first_rc" -eq 0 ] && {
       grep -qE '^[^#]*[Mm][Ee][Ss][Ss][Aa][Gg][Ee][[:space:]]*\([[:space:]]*(FATAL_ERROR|"FATAL_ERROR"|\[=*\[FATAL_ERROR\]=*\])' "$MODULE" \
    || grep -qE '^[[:space:]]*(#\[=*\[.*\]=*\][[:space:]]*)*("FATAL_ERROR"|\[=*\[FATAL_ERROR\]=*\]|FATAL_ERROR)[[:space:]]+[^[:space:]]' "$MODULE"; }
  then
    patch=LIVE
  fi

  # A patched module is the input to the next run, so a second patch has to
  # exit 0 and move nothing.
  repatch=NA
  if [ "$first_rc" -eq 0 ]; then
    after="$SANDBOX/after-first.cmake"
    cp "$MODULE" "$after"
    rc=0
    "$ROOT/tools/patch-cmake.sh" > "$LOG" 2>&1 || rc=$?
    if [ "$rc" -ne 0 ]; then
      repatch=FAILED
    elif cmp -s "$after" "$MODULE"; then
      repatch=IDEMPOTENT
    else
      repatch=CHANGED
    fi
  fi

  roundtrip=NA
  if [ "$first_rc" -eq 0 ]; then
    rc=0
    "$ROOT/tools/unpatch-cmake.sh" > "$LOG" 2>&1 || rc=$?
    if [ "$rc" -ne 0 ]; then
      roundtrip=UNPATCH_FAILED
    elif cmp -s "$fixture" "$MODULE"; then
      roundtrip=IDENTITY
    else
      roundtrip=CHANGED
    fi
  fi

  printf '%s %s %s\n' "$patch" "$repatch" "$roundtrip"
}

broken=0

# An unmatched glob arrives as a literal path, so nullglob drops it and the
# count check below catches an empty directory before the loop runs.
shopt -s nullglob
FILES=("$FIXTURES"/*.cmake)
[ ${#FILES[@]} -gt 0 ] || { echo "error: no fixtures in $FIXTURES" >&2; exit 1; }

# The crlf fixture covers its shape only while it carries a CR. A checkout that
# normalises it leaves this check green over a second copy of shipped.
grep -q $'\r' "$FIXTURES/crlf.cmake" || {
  echo "error: $FIXTURES/crlf.cmake carries no CR, so its shape is untested" >&2
  exit 1
}

for fixture in "${FILES[@]}"; do
  name="$(basename "$fixture" .cmake)"
  rc=0
  row="$(grep -E "^${name}[[:space:]]" "$EXPECTED")" || rc=$?
  if [ "$rc" -ne 0 ]; then
    echo "FAIL $name: no row in $EXPECTED" >&2
    broken=1
    continue
  fi
  # The awk below drops a malformed sibling of a well formed row, and a two line
  # want splits the FAIL message, so the row count is settled first.
  if [ "$(echo "$row" | wc -l | tr -d ' ')" -ne 1 ]; then
    echo "FAIL $name: more than one row in $EXPECTED" >&2
    broken=1
    continue
  fi
  # $2 $3 $4 alone matches a five field row on its first three verdicts, so NF
  # gates the print.
  want="$(echo "$row" | awk 'NF == 4 { print $2, $3, $4 }')"
  if [ -z "$want" ]; then
    echo "FAIL $name: its row in $EXPECTED carries other than three verdicts" >&2
    broken=1
    continue
  fi

  got="$(run_fixture "$fixture")"

  if [ "$got" = "$want" ]; then
    printf 'ok   %-14s %s\n' "$name" "$got"
  else
    printf 'FAIL %-14s want %s, got %s\n' "$name" "$want" "$got" >&2
    broken=1
  fi
done

# A row naming a fixture that is gone would otherwise pass unnoticed, and the
# shape it covered would stop being tested.
while read -r name _ || [ -n "$name" ]; do
  case "$name" in ''|'#'*) continue ;; esac
  [ -f "$FIXTURES/$name.cmake" ] || {
    echo "FAIL $name: a row in $EXPECTED names no fixture" >&2
    broken=1
  }
done < "$EXPECTED"

exit "$broken"
