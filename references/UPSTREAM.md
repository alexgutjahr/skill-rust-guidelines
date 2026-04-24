# Upstream Source

This skill mirrors Microsoft's Rust Guidelines from:

- **Repo:** https://github.com/microsoft/rust-guidelines
- **Rendered docs:** https://microsoft.github.io/rust-guidelines/
- **Pinned commit:** `dee22e44cee2888c313257b7e9b87c351c7340bf`
- **Last refreshed:** `2026-04-24`

The 48 `M-<ID>` guidelines are mirrored verbatim from `src/guidelines/<category>/M-<NAME>.md`. This skill does NOT fetch live at invocation — all content is local.

## Refresh procedure

When Microsoft updates the guidelines, re-run the skill build:

```bash
# 1. Re-clone at the new HEAD
rm -rf /tmp/rust-guidelines-upstream
git clone --depth 1 https://github.com/microsoft/rust-guidelines /tmp/rust-guidelines-upstream
NEW_SHA=$(cd /tmp/rust-guidelines-upstream && git rev-parse HEAD)

# 2. Re-run the reference-generation script (see below)
bash ~/.agents/skills/rust-guidelines/references/_regenerate.sh

# 3. Re-run the checklist-generation step (see _regenerate.sh)

# 4. Update this file with the new SHA and date
# 5. Re-run the RED/GREEN test from the plan
```

The regeneration script is `_regenerate.sh` (committed alongside the references). See the implementation plan at `docs/superpowers/plans/2026-04-24-rust-guidelines-skill.md` in the dotfiles repo for the original construction procedure.

## Drift policy

- If upstream adds new guidelines: add them to the appropriate category reference and `checklist.md`, bump the `last refreshed` date.
- If upstream renames an M-ID: update all references and the checklist.
- If upstream changes severity (bumps 0.x → 1.0): update the `<version>` marker in the affected category reference.
