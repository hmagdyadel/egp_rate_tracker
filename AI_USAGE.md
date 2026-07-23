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

### Phase 3 — Data layer — 2026-07-23 (commit `25457be`)
**Prompt:** Build Phase 3 data layer: RatesResponseModel (json_serializable), RatesMapper (rate inversion + change math in its own class), RatesRemoteDataSource, RatesLocalDataSource (Hive), RatesRepositoryImpl (offline-first: API → cache → fallback), ExceptionMapper (DioException → Failure), HiveService, wire everything into get_it. Historical rates already uses Future.wait for parallel fetches.
**Model returned:** 8 new files across core/ and features/rates/data/. RatesResponseModel matches API shape. RatesMapper inverts rates (1/raw) and computes daily change. Repository fetches today+yesterday in parallel, caches, falls back to cache on error. DI wires: HiveService → Dio → ApiService → data sources → repository → use cases. Also bumped json_annotation ^4.9.0→^4.12.0 and added DioExceptionType.transformTimeout case.
**Decision:** Accepted as-is. Verified: (1) locked in color mapping for Phase 4 where isPositiveChange (rate increased/EGP weakened) = RED and isNegativeChange = GREEN; (2) independently verified transformTimeout is a valid DioExceptionType in Dio 5.x.

### Phase 4 — Module 1: Rates list — 2026-07-23 (commit `78fb3c7`)
**Prompt:** Build Phase 4 Module 1 Rates list: RatesState (Freezed: initial/loading/success/empty/error), RatesCubit calling GetLatestRatesUseCase, RatesListScreen with RefreshIndicator, RateListItem with tabular figures, avatar chip, localized strings, and RateChangeBadge soft-tinted pill using ▲/▼ glyphs and RED-for-isPositiveChange / GREEN-for-isNegativeChange mapping, shimmer skeleton loading rows on first load, centered ErrorView & EmptyView, tap navigation to detail route.
**Model returned:** Created RatesState (freezed union), RatesCubit, ErrorView, EmptyView, RatesListShimmer, RateChangeBadge, RateListItem, RatesListScreen. Wired RatesCubit in GetIt and updated AppRouter. Applied theme tokens & easy_localization. Verified flutter analyze (0 issues) and flutter test (all pass).
**Decision:** Edited — User requested two adjustments before approval: (1) Replaced `shimmer` package with `skeletonizer` (`skeletonizer: ^1.4.3`), wrapping `RateListItem` layouts with dummy data bones in `RatesListSkeleton`; (2) Refined `RateChangeBadge` with an explicit third neutral branch (`changeAbsolute == 0`) rendering a neutral gray pill with an em dash (`—`) glyph. All verified with 0 analysis issues and passing tests.

### Phase 5 — Module 2: Detail + chart — 2026-07-23
**Prompt:** Build Phase 5 Module 2 Detail + chart: DetailState (Freezed: initial/loading/success/error), DetailCubit calling GetHistoricalRatesUseCase for last 7 days (generate dates chronologically starting from 6 days ago up to today), RateDetailScreen with header card (tabular-figure rate, RateChangeBadge, "as of {date}" caption) and fl_chart line chart (minimal gridlines, soft area-gradient fading to transparent, X-axis labels only for first/last/min/max points), Skeletonizer(enabled: true) loading state, ErrorView error state, route argument passing, DI & AppRouter wiring.
**Model returned:** Created DetailState, DetailCubit, RateDetailChart, RateDetailScreen. Registered DetailCubit in GetIt and wired Routes.rateDetail in AppRouter passing CurrencyRate argument. Verified date generation logic (today - (6 - i) days), parallel fetch in repository, fl_chart styling, Skeletonizer loading, 0 analysis issues, and passing unit/widget tests.
**Decision:** Edited — (1) Verified via live curl test that historical endpoints for today/future dates return 404 until published; added an `isToday` check & 404-catch fallback in `RatesRemoteDataSource.getHistoricalRates()` to route to `getLatestRates()`; (2) Confirmed detail header uses the passed-in `CurrencyRate` directly with no redundant network calls; (3) Confirmed null-argument guard in `AppRouter`'s `rateDetail` route is correctly handled.


