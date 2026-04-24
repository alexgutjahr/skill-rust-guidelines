# skill-rust-guidelines

A [Claude Code](https://claude.com/claude-code) skill that reviews Rust code against **Microsoft's Rust Guidelines** and produces a structured findings report with per-rule citations.

> **Upstream source:** [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines) · rendered at [microsoft.github.io/rust-guidelines](https://microsoft.github.io/rust-guidelines/)

## What it does

- Loads all 48 `M-<ID>` guidelines (organised by Microsoft's 11 category buckets: universal, library/interop, library/ux, library/resilience, library/building, applications, ffi, safety, performance, documentation, ai).
- Detects project type from `Cargo.toml` (library vs application vs FFI-bearing vs workspace) and filters applicable rules — no library-only findings against an app, no app-only findings against a library.
- Supports two review modes:
  - **Targeted** — a single file, module, or PR diff, walked in-thread.
  - **Whole-codebase** — a crate or Cargo workspace, dispatched across parallel subagents (one per applicable category) and merged into a single report.
- Cites every finding by `M-<ID>` with a link to the rendered doc, the offending snippet, and a suggested change.
- Splits output into **Blocking (v1.0 stable)** and **Advisory (v0.x evolving)** sections — using Microsoft's own stability signal.
- **Report-only.** The skill does not modify code. If you want fixes, ask as a follow-up once you've read the report.

## Not a replacement for

`cargo clippy`, `cargo fmt`, `cargo audit`, or `miri`. The skill references `M-STATIC-VERIFICATION` and reminds you to run those tools — it complements, not replaces, them.

## Installation

### Claude Code

Skills live at `~/.claude/skills/` (user-wide) or `.claude/skills/` (per-project). Symlink the repo in:

```bash
git clone git@github.com:alexgutjahr/skill-rust-guidelines.git ~/some/path/skill-rust-guidelines
ln -s ~/some/path/skill-rust-guidelines ~/.claude/skills/rust-guidelines
```

Restart your Claude Code session and it will appear in the available-skills list.

### Other agent harnesses

The skill follows the [agentskills.io specification](https://agentskills.io/specification) — `SKILL.md` with YAML frontmatter (`name`, `description`) plus a `references/` directory. Any harness that loads skills from a directory should work: point it at `skill-rust-guidelines/` as the skill root.

## Usage

Invoke via a natural-language request. Triggers include:

- "Review this Rust file against Microsoft's guidelines"
- "Audit this Rust crate"
- "Check `src/lib.rs` for Rust quality issues"
- "Run a rust-guidelines review on the workspace"

The skill will:

1. Ask for scope if ambiguous (single file or whole codebase).
2. Read `Cargo.toml` to pick applicable categories.
3. Walk the code — targeted mode in-thread, whole-codebase mode via parallel subagents.
4. Produce a report, grouped by stability (blocking/advisory) and category, with every finding cited by `M-<ID>`.

### Example output

See [`references/report-template.md`](references/report-template.md) for the exact report format.

## Repository layout

```
.
├── SKILL.md                      # Entry point (≤550 words, what Claude loads first)
├── README.md                     # This file
├── .gitignore
└── references/
    ├── UPSTREAM.md               # Provenance + refresh procedure
    ├── _regenerate.sh            # Regenerates all references + checklist from upstream
    ├── checklist.md              # 48-row flat triage table (M-ID, title, version, applies-to, rationale)
    ├── report-template.md        # Findings report format
    ├── whole-codebase-workflow.md # Parallel-dispatch procedure for workspaces
    └── <category>.md × 11        # Per-category guideline content (universal.md, safety.md, …)
```

Reference files are mirrored **verbatim** from the upstream `src/guidelines/<category>/M-*.md` markdown at a pinned commit. `<why>` one-line rationales and `<version>` stability markers are preserved and used by the skill at review time.

## Refreshing from upstream

When Microsoft updates their guidelines:

```bash
# Fetch upstream at its latest HEAD
rm -rf /tmp/rust-guidelines-upstream
git clone --depth 1 https://github.com/microsoft/rust-guidelines /tmp/rust-guidelines-upstream

# Regenerate references + checklist
bash references/_regenerate.sh

# Update references/UPSTREAM.md with the new SHA + date
# Review the diff, then commit
git diff
git commit -am "Refresh guidelines from microsoft/rust-guidelines@<SHA>"
```

See [`references/UPSTREAM.md`](references/UPSTREAM.md) for full detail.

## Design notes

- **Report-only:** flagging and fixing are different jobs. Keeping this skill to review-only means you get a clean, high-signal report you can act on in whatever order makes sense.
- **Pre-flight filter:** running every guideline against every crate produces noise. Filtering by project type (library/app/FFI) is the difference between "useful" and "ignore this".
- **Stability preservation:** Microsoft flags rules as `1.0` (stable, must) vs `0.x` (evolving, should). The skill surfaces that distinction so you can triage — don't block a PR on advisory findings.
- **Parallel dispatch for workspaces:** a 50-crate workspace against 48 rules is 2,400 checks. One subagent per category gives Claude's context window a chance to breathe.

## Attribution & license

This skill mirrors content from [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines), licensed under the [MIT License](https://github.com/microsoft/rust-guidelines/blob/main/LICENSE). This skill is independently authored and is **not** an official Microsoft project.

The skill's own code (the `SKILL.md` workflow, `_regenerate.sh`, `report-template.md`, `whole-codebase-workflow.md`) is released under the [MIT License](LICENSE).

## Contributing

Improvements to the skill workflow, the report template, or the pre-flight filter are welcome — open an issue or PR.

For upstream guideline content, file issues against [microsoft/rust-guidelines](https://github.com/microsoft/rust-guidelines/issues) directly. Changes there flow into this skill via `_regenerate.sh`.
