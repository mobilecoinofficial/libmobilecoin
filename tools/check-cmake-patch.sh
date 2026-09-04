#!/bin/bash
# Drive the real patch and un-patch scripts over the fixture set and compare
# each verdict against tools/fixtures/cmake/expected.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURES="$ROOT/tools/fixtures/cmake"
EXPECTED="$FIXTURES/expected"

[ -f "$EXPECTED" ] || { echo "error: no $EXPECTED" >&2; exit 1; }

# A fake install keeps the run off the cmake the developer builds with. The
# scripts resolve their target from `which cmake`, so the fake has to be found.
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT
mkdir -p "$SANDBOX/bin" "$SANDBOX/share/cmake/Modules/Platform"
printf '#!/bin/sh\necho fake cmake\n' > "$SANDBOX/bin/cmake"
chmod +x "$SANDBOX/bin/cmake"
MODULE="$SANDBOX/share/cmake/Modules/Platform/iOS-Initialize.cmake"

export PATH="$SANDBOX/bin:$PATH"
RESOLVED="$(command -v cmake)"
[ "$RESOLVED" = "$SANDBOX/bin/cmake" ] || {
  echo "error: cmake resolves to $RESOLVED, not the sandbox; refusing to touch a real install" >&2
  exit 1
}

LOG="$SANDBOX/run.log"

# Echoes "<patch> <repatch> <round trip>" verdicts for the fixture named in $1.
run_fixture() {
  local fixture="$1" rc=0 patch repatch roundtrip after
  cp "$fixture" "$MODULE"

  rc=0
  "$ROOT/tools/patch-cmake.sh" > "$LOG" 2>&1 || rc=$?
  if [ "$rc" -eq 0 ] && ! cmp -s "$fixture" "$MODULE"; then
    patch=CHANGED
  elif [ "$rc" -ne 0 ] && cmp -s "$fixture" "$MODULE"; then
    patch=REFUSED
  else
    # A zero exit over an unchanged file is the failure this check exists for,
    # so it gets a verdict of its own rather than folding into REFUSED.
    echo "exit=$rc" >&2
    cat "$LOG" >&2
    printf 'UNEXPECTED NA NA\n'
    return 0
  fi

  # A patched module is the input to the next run, so a second patch has to be
  # a no-op rather than a refusal.
  repatch=NA
  if [ "$patch" = CHANGED ]; then
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
  if [ "$patch" = CHANGED ]; then
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
# count check below fails an empty directory here rather than inside the loop.
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
  want="$(grep -E "^${name}[[:space:]]" "$EXPECTED")" || rc=$?
  if [ "$rc" -ne 0 ]; then
    echo "FAIL $name: no row in $EXPECTED" >&2
    broken=1
    continue
  fi
  want="$(echo "$want" | awk '{print $2, $3, $4}')"

  got="$(run_fixture "$fixture")"

  if [ "$got" = "$want" ]; then
    printf 'ok   %-12s %s\n' "$name" "$got"
  else
    printf 'FAIL %-12s want %s, got %s\n' "$name" "$want" "$got" >&2
    broken=1
  fi
done

# A row naming a fixture that is gone would otherwise pass unnoticed, and the
# shape it covered would stop being tested.
while read -r name _; do
  case "$name" in ''|'#'*) continue ;; esac
  [ -f "$FIXTURES/$name.cmake" ] || {
    echo "FAIL $name: a row in $EXPECTED names no fixture" >&2
    broken=1
  }
done < "$EXPECTED"

exit "$broken"
