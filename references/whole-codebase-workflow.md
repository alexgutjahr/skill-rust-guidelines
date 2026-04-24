# Whole-codebase review workflow

Use for crate- or workspace-level audits. For single files / modules / diffs, use the targeted workflow in `SKILL.md` instead.

## Procedure

1. **Enumerate crates.** For a workspace, read `Cargo.toml` members; for a single crate, that's the one crate.

2. **Per-crate pre-flight.** Each crate gets its own category filter (see `SKILL.md` pre-flight). A workspace may have one library crate and one binary — filter per crate, not per workspace.

3. **Dispatch one subagent per applicable category, per crate.**
   REQUIRED SUB-SKILL: Use `superpowers:dispatching-parallel-agents` for the actual dispatch pattern.

   Each subagent gets:
   - **Instruction:** "Find violations of the guidelines in `<category>`. Cite every finding by `M-<ID>`. Only cite IDs that appear in your loaded reference file. Return findings only — no preamble, no commentary."
   - **Context files:** `references/<slug>.md` (the category reference) and the list of Rust source files in the crate.
   - **Boundaries:** stay within the category. Don't flag issues belonging to other categories even if spotted.

4. **Collect all subagents' findings.**

5. **Merge into one workspace report** using `references/report-template.md`:
   - De-duplicate by `(M-ID, file, line)`.
   - Group findings by crate, then by category.
   - Within each category: v1.0 (blocking) before v0.x (advisory).
   - If a single M-ID fires across many files, consolidate into one finding with a list of locations.

## Template — subagent prompt

Use this as the body of each dispatched subagent's prompt:

```
You are reviewing a Rust crate's source for violations of a specific category of Microsoft's Rust Guidelines.

## Category

[SLUG] — see the attached reference file.

## Reference file

[CONTENTS of references/<slug>.md]

## Files to review

[LIST of .rs files, with absolute paths]

## Instructions

- Only flag violations of guidelines in the reference file. Ignore anything outside this category.
- Cite every finding by M-ID. Only cite IDs that appear as `## Title (M-<ID>)` headings in the reference.
- Every finding must include:
  - M-ID
  - Title (from the reference heading)
  - Stability (the `<version>` tag — 1.0 or 0.x)
  - file:LINE-LINE reference
  - Offending snippet (verbatim)
  - Suggested change (one paragraph or brief code)
- Do NOT fix anything. Do NOT produce commentary or summary. Return findings only, in Markdown.
- If you find nothing, return exactly: "No findings."

Return format (per finding):

### M-<ID> — <Title> (v<version>)

**File:** `<path>:<LINE>-<LINE>`

<Offending snippet>

<Suggested change>
```

## Output constraints

- Workspace-level report is one document. Don't emit per-category sub-reports unless the user explicitly asks.
- Keep the aggregated report scannable — per-category grouping, collapsed duplicates.
- If more than ~50 findings appear, add a one-line summary at the top: "N findings across K categories; blocking: X, advisory: Y."
