# Upstream Source

This skill mirrors Microsoft's Rust Guidelines from:

- **Repo:** https://github.com/microsoft/rust-guidelines
- **Rendered docs:** https://microsoft.github.io/rust-guidelines/
- **Pinned commit:** `dee22e44cee2888c313257b7e9b87c351c7340bf`
- **Last refreshed:** `2026-04-24`

The 48 `M-<ID>` guidelines are mirrored verbatim from `src/guidelines/<category>/M-<NAME>.md`. This skill does NOT fetch live at invocation — all content is local, already committed to the repo, and ready to use on clone.

## Refresh procedure

> Only needed when Microsoft updates the guidelines. `regenerate.sh` is idempotent — re-running it against the same upstream SHA produces byte-identical output.

```bash
# 1. Re-clone at the new HEAD
rm -rf /tmp/rust-guidelines-upstream
git clone --depth 1 https://github.com/microsoft/rust-guidelines /tmp/rust-guidelines-upstream
NEW_SHA=$(cd /tmp/rust-guidelines-upstream && git rev-parse HEAD)

# 2. Regenerate all references + checklist in one pass
bash references/regenerate.sh

# 3. Update this file with the new SHA and date
# 4. Review the diff, commit
git diff
git commit -am "Refresh guidelines from microsoft/rust-guidelines@${NEW_SHA}"
```

The regeneration script is `regenerate.sh` (committed alongside the references). It expects the upstream clone at `/tmp/rust-guidelines-upstream` and writes category files + `checklist.md` in a single invocation.

## Drift policy

- If upstream adds new guidelines: `regenerate.sh` picks them up automatically (new `M-*.md` files under an existing category). If a new category directory appears, add it to the `MAP` in `regenerate.sh`.
- If upstream renames an M-ID: handled automatically by regeneration; just verify the `checklist.md` diff and any hand-written cross-references in `SKILL.md` / `report-template.md`.
- If upstream changes severity (bumps 0.x → 1.0): `<version>` marker updates automatically; verify the checklist reflects the new stability.
