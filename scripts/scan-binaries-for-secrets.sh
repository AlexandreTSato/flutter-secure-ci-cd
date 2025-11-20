#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/scan-binaries-for-secrets.sh path/to/artifact1.apk path/to/other.aab
# Saída: 0 => ok, 1 => found secrets

PATTERNS=(
  "AKIA[0-9A-Z]{16}"                    # AWS access key ID
  "-----BEGIN (RSA|PRIVATE|EC) PRIVATE KEY-----"
  "AIza[0-9A-Za-z-_]{35}"               # Google API key pattern (approx)
  "8L[a-zA-Z0-9_-]{70,}"                # Example long tokens (adjust)
  "xox[baprs]-[0-9A-Za-z-]+"            # Slack token pattern
  "ssh-rsa AAAA[0-9A-Za-z+/=]{100,}"    # ssh public key inlined
  "eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_.-]{10,}\.[A-Za-z0-9_.-]{10,}" # JWT-ish
)

FOUND=0
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

for ART in "$@"; do
  if [ ! -f "$ART" ]; then
    echo "⚠️ Artifact not found: $ART"
    continue
  fi
  echo "🔎 Scanning artifact: $ART"
  BASENAME=$(basename "$ART")
  OUT="$TMPDIR/${BASENAME}.strings.txt"
  # extract printable strings
  strings "$ART" > "$OUT" || true

  for PAT in "${PATTERNS[@]}"; do
    if grep -E -n "$PAT" "$OUT" > "$TMPDIR/match.txt" 2>/dev/null; then
      echo "❌ Possible secret found in $ART (pattern: $PAT)"
      head -n 20 "$tmp" || true
      cat "$TMPDIR/match.txt"
      FOUND=1
    fi
  done

  # also scan compressed files inside (zip)
  if unzip -l "$ART" >/dev/null 2>&1; then
    mkdir -p "$TMPDIR/unzipped"
    unzip -q "$ART" -d "$TMPDIR/unzipped"
    # scan extracted files for patterns (limit to large text files)
    grep -R --binary-files=without-match -nE "$(IFS="|"; echo "${PATTERNS[*]}")" "$TMPDIR/unzipped" || true
    # if any match found above, set FOUND
    if [ $? -eq 0 ]; then FOUND=1; fi
  fi
done

if [ "$FOUND" -gt 0 ]; then
  echo "❌ Secrets detected in artifacts!"
  exit 1
else
  echo "✅ No obvious secrets found in artifacts."
  exit 0
fi
