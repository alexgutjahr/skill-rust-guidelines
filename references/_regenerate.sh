#!/usr/bin/env bash
# Regenerate category reference files from a pinned upstream clone.
# Run after updating /tmp/rust-guidelines-upstream. Idempotent.
set -euo pipefail

SRC=/tmp/rust-guidelines-upstream/src/guidelines
DST="$(cd "$(dirname "$0")" && pwd)"

# Mapping: upstream directory (relative to src/guidelines/) → reference filename (without .md)
# Applies-to marker for each category (used in the generated file header).
declare -A MAP=(
  ["universal"]="universal|Universal — applies to all Rust code (libraries and applications)"
  ["libs/interop"]="library-interop|Library — interoperability with the ecosystem"
  ["libs/ux"]="library-ux|Library — public API user experience"
  ["libs/resilience"]="library-resilience|Library — robustness and testability"
  ["libs/building"]="library-building|Library — build and packaging"
  ["apps"]="applications|Applications — binary/application crates only"
  ["ffi"]="ffi|FFI — applies when the crate produces a cdylib/staticlib or uses extern \"C\""
  ["safety"]="safety|Safety — applies whenever unsafe is used; M-UNSOUND applies everywhere"
  ["performance"]="performance|Performance — applies whenever throughput or latency matters"
  ["docs"]="documentation|Documentation — applies to all public items"
  ["ai"]="ai|AI — library design hints for AI-agent consumers"
)

total=0
for upstream in "${!MAP[@]}"; do
  IFS='|' read -r slug applies <<< "${MAP[$upstream]}"
  outfile="$DST/${slug}.md"
  catdir="$SRC/$upstream"

  if [ ! -d "$catdir" ]; then
    echo "ERROR: missing upstream directory: $catdir" >&2
    echo "      → adjust the MAP in _regenerate.sh to match actual upstream layout" >&2
    exit 1
  fi

  # Build the reference file
  {
    echo "# ${slug}"
    echo ""
    echo "**Applies to:** ${applies}"
    echo ""
    echo "**Source:** \`src/guidelines/${upstream}\` in microsoft/rust-guidelines (pinned; see UPSTREAM.md)"
    echo ""
    echo "---"
    echo ""
    if [ -f "$catdir/README.md" ]; then
      cat "$catdir/README.md"
      echo ""
      echo "---"
      echo ""
    fi
    for g in "$catdir"/M-*.md; do
      [ -f "$g" ] || continue
      cat "$g"
      echo ""
      echo "---"
      echo ""
    done
  } > "$outfile"

  count=$(ls "$catdir"/M-*.md 2>/dev/null | wc -l | tr -d ' ')
  total=$((total + count))
  echo "Wrote $outfile ($count guidelines)"
done

echo ""
echo "Total: $total guidelines across ${#MAP[@]} reference files"
if [ "$total" -ne 48 ]; then
  echo "WARNING: expected 48, got $total — verify upstream hasn't added/removed guidelines" >&2
fi

# ---------------------------------------------------------------------------
# Build references/checklist.md by scanning category reference files for M-ID
# headings and extracting title, <version>, and <why> rationale.
# ---------------------------------------------------------------------------

OUT="$DST/checklist.md"

# applies-to per category file (slug → applies-to label for the checklist column)
declare -A APPLIES=(
  ["universal"]="All"
  ["library-interop"]="Library"
  ["library-ux"]="Library"
  ["library-resilience"]="Library"
  ["library-building"]="Library"
  ["applications"]="App"
  ["ffi"]="FFI"
  ["safety"]="All (unsafe)"
  ["performance"]="All"
  ["documentation"]="All (public)"
  ["ai"]="Library"
)

{
  echo "# Checklist — All 48 Rust Guidelines"
  echo ""
  echo "Quick-triage reference. Use the category files for full rule bodies."
  echo ""
  echo "**Stability:** \`1.0\` = stable, enforce as blocking. \`0.x\` = evolving, surface as advisory."
  echo ""
  echo "| M-ID | Title | v | Applies | One-liner (\`<why>\`) |"
  echo "|------|-------|---|---------|---------------------|"

  for slug in universal library-interop library-ux library-resilience library-building applications ffi safety performance documentation ai; do
    f="$DST/${slug}.md"
    [ -f "$f" ] || { echo "Missing $f" >&2; exit 1; }
    applies="${APPLIES[$slug]}"

    # For each M-* heading, grab: title, M-ID, then the nearest <why> and <version>.
    awk -v applies="$applies" '
      BEGIN { title=""; id=""; why=""; ver="" }
      /^## .*\(M-[A-Z][A-Z0-9-]+\)/ {
        # Emit previous row if complete
        if (id != "") {
          gsub(/\|/, "\\|", why)
          printf("| [%s](#%s) | %s | %s | %s | %s |\n", id, id, title, ver, applies, why)
        }
        # Parse new heading: "## Title (M-FOO) { #M-FOO }"
        line = $0
        sub(/^## /, "", line)
        # Extract M-ID
        match(line, /M-[A-Z][A-Z0-9-]+/)
        id = substr(line, RSTART, RLENGTH)
        # Title is everything before " (M-"
        split(line, parts, / \(M-/)
        title = parts[1]
        gsub(/^ +| +$/, "", title)
        why=""; ver=""
        next
      }
      /<why>/ {
        if (why == "") {
          why = $0
          sub(/.*<why>/, "", why)
          sub(/<\/why>.*/, "", why)
        }
      }
      /<version>/ {
        if (ver == "") {
          ver = $0
          sub(/.*<version>/, "", ver)
          sub(/<\/version>.*/, "", ver)
        }
      }
      END {
        if (id != "") {
          gsub(/\|/, "\\|", why)
          printf("| [%s](#%s) | %s | %s | %s | %s |\n", id, id, title, ver, applies, why)
        }
      }
    ' "$f"
  done

  echo ""
  echo "---"
  echo ""
  echo "**Total: 48 guidelines** — if this count is wrong, run \`_regenerate.sh\` and rebuild the checklist."
} > "$OUT"

echo "Wrote $OUT"
grep -cE '^\| \[M-' "$OUT" | xargs -I {} echo "Rows: {}"
