# AI Usage Log — egp_rate_tracker

This file documents how AI was used throughout this project, end to end. Entries are appended chronologically as work happens (via `scripts/log_ai_usage.py`), so their order and dates should track the actual commit history.

Each entry records: the prompt, a short summary of what the model returned, and whether it was accepted as-is, edited, or rejected — and why.

---

<!-- ENTRIES START -->
<!-- New entries are appended below this line by scripts/log_ai_usage.py — do not remove this marker. -->

### Phase 1 — Scaffolding — 2026-07-23 (commit `0d32d8c`, committed together with Phase 2)
**Prompt:** Build Phase 1 scaffolding exactly as described in EGP_RATE_TRACKER_PLAN.md: folder structure, ApiConstants with two base URLs, DioFactory + Retrofit ApiService, empty get_it setup, AppRouter with two routes, theme tokens + light/dark ThemeData, easy_localization with en/ar JSON, CustomBlocObserver, bootstrap.dart, empty CI workflow. User requested removing equatable (redundant with Freezed) and adding intl explicitly.
**Model returned:** Full Phase 1 scaffold: 20+ files across lib/core/, lib/features/rates/ stubs, assets/translations/, .github/workflows/. All dependencies resolved, build_runner generated Retrofit code, flutter analyze passes with 0 issues. Fixed Hive version (4.0.0→2.2.3, doesn't exist), retrofit_generator version (9.x→10.x, source_gen conflict with freezed 3.x), and ApiService return type (Map<String,dynamic>→dynamic, avoids generated fromJson on dynamic).
**Decision:** Edited — user removed equatable and added intl before approving. Three version/codegen issues discovered during build and fixed in-flight. Note: Phase 1 was not committed separately as planned — it was committed in the same commit as Phase 2 (`0d32d8c`). The original hash I recorded (`6ea8fcf`) was wrong; it pointed to a prior unrelated commit.

### Phase 2 — Domain layer — 2026-07-23 (commit `0d32d8c`)
**Prompt:** Build Phase 2 domain layer: CurrencyRate entity, HistoricalRatePoint entity, RatesRepository abstract class, three thin use cases, expand Failure into NetworkFailure/ServerFailure/CacheFailure/NoInternetFailure. Also created ApiResult<T> sealed class in core/networking/.
**Model returned:** 8 new files: sealed Failure hierarchy (core/error/), sealed ApiResult<T> with when() (core/networking/), two entities (domain/entities/), abstract RatesRepository (domain/repositories/), three thin use cases (domain/usecases/). Removed .gitkeep stubs from domain folders. flutter analyze 0 issues, flutter test passes.
**Decision:** Accepted as-is.

### Phase 2 follow-up — Freezed entities — 2026-07-23
**Prompt:** User asked: would converting CurrencyRate and HistoricalRatePoint to @freezed classes instead of manual ==/hashCode be simpler? Only if it's a clean swap.
**Model returned:** Converted both entities to @freezed (no json annotations). Required `abstract class` keyword for Freezed 3.2+ mixin compatibility. build_runner, flutter analyze (0 issues), flutter test all pass.
**Decision:** Accepted as-is.
