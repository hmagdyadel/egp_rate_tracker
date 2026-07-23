# Project instructions — egp_rate_tracker

This file is read automatically by Claude Code (and works as `.cursorrules` for Cursor, or a system/project prompt for any other AI coding tool) at the start of every session in this repo.

## Stack & conventions
Cubit + Freezed (states), entities in `domain/`, Retrofit + Dio, json_serializable models, get_it (DI), Hive (cache), flutter_offline (connectivity + `ConnectionBannerWrapper`), easy_localization (`.tr()`, `assets/translations/en.json` + `ar.json`), fl_chart, shimmer, mocktail + bloc_test. Follow the feature-based `data/domain/presentations` folder structure already in this repo. See `EGP_RATE_TRACKER_PLAN.md` for the phase-by-phase build plan and UI direction.

## AI_USAGE.md — mandatory, automatic, every turn

`AI_USAGE.md` at the repo root logs how AI was used on this project, for the technical assessment reviewer. This is not optional and not something to batch at the end — **update it as part of the same turn you do the work, every time**, the same way you'd update code.

Rule: **any turn where you generate, edit, or suggest non-trivial code or a real decision, append one entry to `AI_USAGE.md` before ending that turn.** Skip only pure Q&A that produced no code/decision (e.g. "what does this error mean").

Append using exactly this format, filled in truthfully — don't invent a decision the user didn't make:

```
### [Phase / feature] — YYYY-MM-DD
**Prompt:** <the user's actual request, summarized if long>
**Model returned:** <1-2 line summary of what you produced>
**Decision:** Accepted as-is / Edited (what changed and why) / Rejected (why)
```

- Use today's real date. If you can run a shell command, pull the current git short commit (`git rev-parse --short HEAD`) after committing and include it in the header line, e.g. `### Phase 3 — 2026-07-24 (commit \`a1b2c3d\`)` — this is what lets the reviewer check timestamps against the actual commit history, so don't skip it when git is available.
- "Decision" must reflect what actually happened in this conversation — if the user asked you to change your own output, that's **Edited**, not **Accepted as-is**. If they asked for something and then didn't use it, that's **Rejected**. Be honest here even when it's unflattering to the suggestion — the reviewer is explicitly grading judgment about AI output, not a clean record.
- Append only — never rewrite or delete earlier entries in this file.
- If you're not sure whether something counts as "meaningful," err toward logging it — a few extra short entries cost nothing; a missing entry for a real decision undermines the whole log's credibility.
