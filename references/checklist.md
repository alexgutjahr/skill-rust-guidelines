# Checklist — All 48 Rust Guidelines

Quick-triage reference. Use the category files for full rule bodies.

**Stability:** `1.0` = stable, enforce as blocking. `0.x` = evolving, surface as advisory.

| M-ID | Title | v | Applies | One-liner (`<why>`) |
|------|-------|---|---------|---------------------|
| [M-CONCISE-NAMES](#M-CONCISE-NAMES) | Names are Free of Weasel Words | 1.0 | All | To improve readability. |
| [M-DOCUMENTED-MAGIC](#M-DOCUMENTED-MAGIC) | Magic Values are Documented | 1.0 | All | To ensure maintainability and prevent misunderstandings when refactoring. |
| [M-LINT-OVERRIDE-EXPECT](#M-LINT-OVERRIDE-EXPECT) | Lint Overrides Should Use `#[expect]` | 1.0 | All | To prevent the accumulation of outdated lints. |
| [M-LOG-STRUCTURED](#M-LOG-STRUCTURED) | Use Structured Logging with Message Templates | 0.1 | All | To minimize the cost of logging and to improve filtering capabilities. |
| [M-PANIC-IS-STOP](#M-PANIC-IS-STOP) | Panic Means 'Stop the Program' | 1.0 | All | To ensure soundness and predictability. |
| [M-PANIC-ON-BUG](#M-PANIC-ON-BUG) | Detected Programming Bugs are Panics, Not Errors | 1.0 | All | To avoid impossible error handling code and ensure runtime consistency. |
| [M-PUBLIC-DEBUG](#M-PUBLIC-DEBUG) | Public Types are Debug | 1.0 | All | To simplify debugging and prevent leaking sensitive data. |
| [M-PUBLIC-DISPLAY](#M-PUBLIC-DISPLAY) | Public Types Meant to be Read are Display | 1.0 | All | To improve usability. |
| [M-REGULAR-FN](#M-REGULAR-FN) | Prefer Regular over Associated Functions | 1.0 | All | To improve readability. |
| [M-SMALLER-CRATES](#M-SMALLER-CRATES) | If in Doubt, Split the Crate | 1.0 | All | To improve compile times and modularity. |
| [M-STATIC-VERIFICATION](#M-STATIC-VERIFICATION) | Use Static Verification | 1.0 | All | To ensure consistency and avoid common issues. |
| [M-UPSTREAM-GUIDELINES](#M-UPSTREAM-GUIDELINES) | Follow the Upstream Guidelines | 1.0 | All | To avoid repeating mistakes the community has already learned from, and to have a codebase that does not surprise users and contributors. |
| [M-DONT-LEAK-TYPES](#M-DONT-LEAK-TYPES) | Don't Leak External Types | 0.1 | Library | To prevent accidental breakage and long-term maintenance cost. |
| [M-ESCAPE-HATCHES](#M-ESCAPE-HATCHES) | Native Escape Hatches | 0.1 | Library | To allow users to work around unsupported use cases until alternatives are available. |
| [M-TYPES-SEND](#M-TYPES-SEND) | Types are Send | 1.0 | Library | To enable the use of types in Tokio and behind runtime abstractions |
| [M-AVOID-WRAPPERS](#M-AVOID-WRAPPERS) | Avoid Smart Pointers and Wrappers in APIs | 1.0 | Library | To reduce cognitive load and improve API ergonomics. |
| [M-DI-HIERARCHY](#M-DI-HIERARCHY) | Prefer Types over Generics, Generics over Dyn Traits | 0.1 | Library | To prevent patterns that don't compose, and design lock-in. |
| [M-ERRORS-CANONICAL-STRUCTS](#M-ERRORS-CANONICAL-STRUCTS) | Error are Canonical Structs | 1.0 | Library | To harmonize the behavior of error types, and provide a consistent error handling. |
| [M-ESSENTIAL-FN-INHERENT](#M-ESSENTIAL-FN-INHERENT) | Essential Functionality Should be Inherent | 1.0 | Library | To make essential functionality easily discoverable. |
| [M-IMPL-ASREF](#M-IMPL-ASREF) | Accept `impl AsRef<>` Where Feasible | 1.0 | Library | To give users flexibility calling in with their own types. |
| [M-IMPL-IO](#M-IMPL-IO) | Accept `impl 'IO'` Where Feasible ('Sans IO') | 0.1 | Library | To untangle business logic from I/O logic, and have N*M composability. |
| [M-IMPL-RANGEBOUNDS](#M-IMPL-RANGEBOUNDS) | Accept `impl RangeBounds<>` Where Feasible | 1.0 | Library | To give users flexibility and clarity when specifying ranges. |
| [M-INIT-BUILDER](#M-INIT-BUILDER) | Complex Type Construction has Builders | 0.3 | Library | To future-proof type construction in complex scenarios. |
| [M-INIT-CASCADED](#M-INIT-CASCADED) | Complex Type Initialization Hierarchies are Cascaded | 1.0 | Library | To prevent misuse and accidental parameter mix ups. |
| [M-SERVICES-CLONE](#M-SERVICES-CLONE) | Services are Clone | 1.0 | Library | To avoid composability issues when sharing common services. |
| [M-SIMPLE-ABSTRACTIONS](#M-SIMPLE-ABSTRACTIONS) | Abstractions Don't Visibly Nest | 0.1 | Library | To prevent cognitive load and a bad out of the box UX. |
| [M-AVOID-STATICS](#M-AVOID-STATICS) | Avoid Statics | 1.0 | Library | To prevent consistency and correctness issues between crate versions. |
| [M-MOCKABLE-SYSCALLS](#M-MOCKABLE-SYSCALLS) | I/O and System Calls Are Mockable | 0.2 | Library | To make otherwise hard-to-evoke edge cases testable. |
| [M-NO-GLOB-REEXPORTS](#M-NO-GLOB-REEXPORTS) | Don't Glob Re-Export Items | 1.0 | Library | To prevent accidentally leaking unintended types. |
| [M-STRONG-TYPES](#M-STRONG-TYPES) | Use the Proper Type Family | 1.0 | Library | To have and maintain the right data and safety variants, at the right time. |
| [M-TEST-UTIL](#M-TEST-UTIL) | Test Utilities are Feature Gated | 0.2 | Library | To prevent production builds from accidentally bypassing safety checks. |
| [M-FEATURES-ADDITIVE](#M-FEATURES-ADDITIVE) | Features are Additive | 1.0 | Library | To prevent compilation breakage in large and complex projects. |
| [M-OOBE](#M-OOBE) | Libraries Work Out of the Box | 1.0 | Library | To be easily adoptable by the Rust ecosystem. |
| [M-SYS-CRATES](#M-SYS-CRATES) | Native `-sys` Crates Compile Without Dependencies | 0.2 | Library | To have libraries that 'just work' on all platforms. |
| [M-APP-ERROR](#M-APP-ERROR) | Applications may use Anyhow or Derivatives | 0.1 | App | To simplify application-level error handling. |
| [M-MIMALLOC-APPS](#M-MIMALLOC-APPS) | Use Mimalloc for Apps | 0.1 | App | To get significant performance for free. |
| [M-ISOLATE-DLL-STATE](#M-ISOLATE-DLL-STATE) | Isolate DLL State Between FFI Libraries | 0.1 | FFI | To prevent data corruption and undefined behavior. |
| [M-UNSAFE-IMPLIES-UB](#M-UNSAFE-IMPLIES-UB) | Unsafe Implies Undefined Behavior | 1.0 | All (unsafe) | To ensure semantic consistency and prevent warning fatigue. |
| [M-UNSAFE](#M-UNSAFE) | Unsafe Needs Reason, Should be Avoided | 0.2 | All (unsafe) | To prevent undefined behavior, attack surface, and similar 'happy little accidents'. |
| [M-UNSOUND](#M-UNSOUND) | All Code Must be Sound | 1.0 | All (unsafe) | To prevent unexpected runtime behavior, leading to potential bugs and incompatibilities. |
| [M-HOTPATH](#M-HOTPATH) | Identify, Profile, Optimize the Hot Path Early | 0.1 | All | To end up with high performance code. |
| [M-THROUGHPUT](#M-THROUGHPUT) | Optimize for Throughput, Avoid Empty Cycles | 0.1 | All | To ensure COGS savings at scale. |
| [M-YIELD-POINTS](#M-YIELD-POINTS) | Long-Running Tasks Should Have Yield Points. | 0.2 | All | To ensure you don't starve other tasks of CPU time. |
| [M-CANONICAL-DOCS](#M-CANONICAL-DOCS) | Documentation Has Canonical Sections | 1.0 | All (public) | To follow established and expected Rust best practices. |
| [M-DOC-INLINE](#M-DOC-INLINE) | Mark `pub use` Items with `#[doc(inline)]` | 1.0 | All (public) | To make re-exported items 'fit in' with their non re-exported siblings. |
| [M-FIRST-DOC-SENTENCE](#M-FIRST-DOC-SENTENCE) | First Sentence is One Line; Approx. 15 Words | 1.0 | All (public) | To make API docs easily skimmable. |
| [M-MODULE-DOCS](#M-MODULE-DOCS) | Has Comprehensive Module Documentation | 1.1 | All (public) | To allow for better API docs navigation. |
| [M-DESIGN-FOR-AI](#M-DESIGN-FOR-AI) | Design with AI use in Mind | 0.1 | Library | To maximize the utility you get from letting agents work in your code base. |

---

**Total: 48 guidelines** — if this count is wrong, run `_regenerate.sh` and rebuild the checklist.
