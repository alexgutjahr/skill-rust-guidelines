# Report Template

Use this structure when producing a rust-guidelines findings report. Every finding cites its `M-<ID>` anchor; readers can follow the link to Microsoft's rendered docs.

## Header block

```
# Rust Guidelines Review

**Scope:** <target — file(s), crate, or workspace>
**Project type:** <library | application | workspace with N crates>
**Upstream reference:** microsoft/rust-guidelines @ <SHA from UPSTREAM.md>
**Date:** <ISO date>
**Categories applied:** <list, e.g., Universal, Library/UX, Safety, Documentation>
```

## Summary line

One line: `N blocking (v1.0) / M advisory (v0.x) findings across K guidelines`.

## Blocking section (v1.0 findings)

Group by category. Each category heading is `## <Category>`. Under it, one subsection per finding:

````markdown
### [M-<ID>](https://microsoft.github.io/rust-guidelines/guidelines/<category>/M-<ID>.html) — <Title> (v1.0)

**File:** `path/to/file.rs:LINE-LINE`

<Why the finding matters — paraphrase or quote the guideline's `<why>`>

**Offending snippet:**
```rust
<exact lines from the code>
```

**Suggested change:**
<one paragraph describing the fix, or a brief code sketch showing the direction. Do NOT rewrite the whole function unless the fix is a 1–3 line change.>
````

## Advisory section (v0.x findings)

Same format as Blocking, but heading says `(v0.x — advisory)`. Include a one-line reminder at the top of the section: `These guidelines are evolving; take as suggestions, not requirements.`

## Out-of-scope / uncheckable notes

Any guidelines the skill could not verify from the code alone (e.g., `M-HOTPATH` requires profiling data, `M-MOCKABLE-SYSCALLS` requires understanding test strategy). List them here with one line each, as "consider".

## Tooling reminder

Close with:
> Also run `cargo clippy -- -D warnings`, `cargo fmt --check`, `cargo audit`, and (for unsafe) `cargo +nightly miri test`. See M-STATIC-VERIFICATION for recommended lint configuration — this skill complements, not replaces, those tools.

## Example (skeleton)

````markdown
# Rust Guidelines Review

**Scope:** `src/cache.rs`, `src/store.rs`
**Project type:** library crate
**Upstream reference:** microsoft/rust-guidelines @ a1b2c3d
**Date:** 2026-04-24
**Categories applied:** Universal, Library/UX, Library/Resilience, Safety, Documentation

**Summary:** 2 blocking / 1 advisory finding across 3 guidelines.

## Blocking

### Library/UX

#### [M-AVOID-WRAPPERS](https://microsoft.github.io/rust-guidelines/...) — Avoid Smart Pointers and Wrappers in APIs (v1.0)

**File:** `src/cache.rs:12-14`

Public APIs that expose `Rc<T>`, `Arc<T>`, `Box<T>`, or `RefCell<T>` force those implementation choices on every consumer.

**Offending snippet:**
```rust
pub struct Cache {
    inner: Rc<HashMap<String, String>>,
}
```

**Suggested change:** Own the `HashMap` directly (`inner: HashMap<String, String>`) or, if shared ownership is genuinely required, expose behavior (methods) rather than the wrapper type.

### Library/Resilience

#### [M-AVOID-STATICS](...) — Avoid Statics (v1.0)

<...>

## Advisory

### Performance

#### [M-YIELD-POINTS](...) — Long-Running Tasks Should Have Yield Points (v0.2 — advisory)

<...>

## Out of scope

- `M-HOTPATH` — requires profiling data not present in the reviewed files.

## Tooling reminder

Also run `cargo clippy` / `cargo fmt` / `cargo audit`. See `M-STATIC-VERIFICATION`.
````
