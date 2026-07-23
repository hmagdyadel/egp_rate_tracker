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

### Phase 5 — Module 2: Detail + chart — 2026-07-23 (commit `6a35018`)
**Prompt:** Build Phase 5 Module 2 Detail + chart: DetailState (Freezed: initial/loading/success/error), DetailCubit calling GetHistoricalRatesUseCase for last 7 days (generate dates chronologically starting from 6 days ago up to today), RateDetailScreen with header card (tabular-figure rate, RateChangeBadge, "as of {date}" caption) and fl_chart line chart (minimal gridlines, soft area-gradient fading to transparent, X-axis labels only for first/last/min/max points), Skeletonizer(enabled: true) loading state, ErrorView error state, route argument passing, DI & AppRouter wiring.
**Model returned:** Created DetailState, DetailCubit, RateDetailChart, RateDetailScreen. Registered DetailCubit in GetIt and wired Routes.rateDetail in AppRouter passing CurrencyRate argument. Verified date generation logic (today - (6 - i) days), parallel fetch in repository, fl_chart styling, Skeletonizer loading, 0 analysis issues, and passing unit/widget tests.
**Decision:** Edited — (1) Verified via live curl test that historical endpoints for today/future dates return 404 until published; added an `isToday` check & 404-catch fallback in `RatesRemoteDataSource.getHistoricalRates()` to route to `getLatestRates()`; (2) Confirmed detail header uses the passed-in `CurrencyRate` directly with no redundant network calls; (3) Confirmed null-argument guard in `AppRouter`'s `rateDetail` route is correctly handled.

### Phase 6 — Module 3: Offline cache — 2026-07-23 (commit `c7c7198`)
**Prompt:** Build Phase 6 Module 3 Offline cache: ConnectionBannerWrapper in main.dart wrapping MaterialApp using flutter_offline (red offline banner, green 2.5s reconnect banner), auto-trigger RatesCubit refresh on reconnect, RatesResult entity with isFromCache flag, RatesState.success(isFromCache: true) triggering a "last updated {time}" banner on RatesListScreen, repository fallback logic verification for offline first launch with empty cache.
**Model returned:** Created RatesResult entity, ConnectionBannerWrapper. Updated RatesRepository, RatesRepositoryImpl, GetLatestRatesUseCase, GetCachedRatesUseCase, RatesState, RatesCubit, RatesListScreen, and main.dart. Verified first-launch offline scenario (returns Failure, renders ErrorView & red banner), auto-reconnect trigger, cache timestamp banner, 0 analysis issues, and passing unit/widget tests.
**Decision:** Edited — (1) Confirmed offline→online reconnect refresh trigger uses a `_wasOffline` state guard so it fires only on genuine reconnect transitions and not on initial app launch; (2) Confirmed "last updated" timestamp banner comes from persisted `CurrencyRate.lastUpdated` (original snapshot date from Hive) rather than `DateTime.now()` at render time.

### Phase 7 — Testing pass — 2026-07-23 (commit `7840e17`)
**Prompt:** Build Phase 7 test pass matching lib/ structure 1:1 using mocktail and bloc_test. Highest priority unit tests (RatesMapper, RatesRepositoryImpl, RatesRemoteDataSource, ExceptionMapper, 3 use cases), Cubit tests (RatesCubit, DetailCubit), and Widget tests (RateChangeBadge 3-branch glyphs, RatesListScreen 4 states). Deliberately skip coverage padding.
**Model returned:** Created 10 unit, cubit, and widget test files under test/. Total test count: 34 tests across 11 suites. Bumped skeletonizer constraint to ^2.0.0 for Flutter SDK compatibility and updated Localizations in screen. All 34 tests pass, flutter analyze has 0 issues.
**Decision:** Edited — (1) Confirmed the `Object:` parameter name in `RatesRepositoryImplTest` was a walkthrough transcription error, not real code; (2) The initial 404 fallback test was rejected because it mocked success and never actually threw an exception, meaning it would have passed even with the fallback logic deleted; (3) Rewrote the test with an injectable `historicalApiServiceFactory` in `RatesRemoteDataSource` so historical and latest API calls could be mocked and verified independently, with a real 404 `DioException` thrown; (4) Skeletonizer bumped 1.4.3→2.0.0 for Flutter 3.29+ engine compatibility (no widget API changes); (5) Switched `RatesListScreen` from `context.locale` to `Localizations.localeOf(context)` for test-harness compatibility.

### Phase 8 — Multi-range chart & UX polish — 2026-07-23 (commit `a8c444e`)
**Prompt:** Build multi-range historical chart (7D/1M/6M/1Y/Max) with ChartRange enum, sampled date generation (daily/weekly/monthly), and a pill-style range selector matching RateChangeBadge's visual language. Reject original 5Y range after live curl-testing found API data only starts March 6, 2024; replace with "Max" and build skip-null logic (getHistoricalRatesOrNull) instead of single-date 404-fallback to avoid fabricating flat-line data. Fix all discovered bugs (test-date anchor miscalculation, fl_chart lerp-truncation update bug, error state range mismatch, easy_localization "{date}" placeholder bug, 30-request socket timeout, raw DioException strings in UI). Iterate chart loading state to SpinKitThreeBounce Loader in fixed-height container. Update brand primary color to Indigo (#4F46E5) and lock chart line/gradient to brand Indigo. Apply visual polish pass (unified 2-letter monograms, soft card depth shadows, dominant detail rate hierarchy, corrected 20px chart outer padding).
**Model returned:** Complete Phase 8 multi-range implementation, bug fixes, brand color migration, Loader integration, and UI polish pass across domain, data, cubits, theme, views, and tests. 49 tests pass, flutter analyze has 0 issues.
**Decision:** Edited — extensively, across many rounds, reflecting real bugs found through live device testing and screenshot verification:
- **Multi-range Architecture & API Boundaries:** Built `ChartRange` enum (7D, 1M, 6M, 1Y, MAX) and sampling logic in `DetailCubit`. Rejected the 5Y range after live curl testing established historical API availability starts March 6, 2024. Implemented `getHistoricalRatesOrNull` to drop missing dates entirely rather than using the 404-fallback that would fabricate flat-line data.
- **Bug Fixes:** (1) Verified test-date generation was anchored to real system clock after discovering a test helper assumed 2024 (production code was clean); (2) Added `ValueKey(range)` to `RateDetailChart` to fix `fl_chart`'s `ImplicitlyAnimatedWidget` lerp-truncation bug where chart data didn't visually update on range tab switches; (3) Captured `requestedRange` locally in `DetailCubit.fetchHistoricalRates` so emitted `DetailState.error` carries the exact tab that failed; (4) Fixed `{date}` placeholder translation by replacing `args` with `namedArgs: {'date': formattedDate}`; (5) Added `_fetchInBatches(dates, batchSize: 6)` chunking in `RatesRepositoryImpl` to eliminate mobile network socket timeouts (1M completed in 1.6s, MAX in 2.2s); (6) Redesigned `Failure` hierarchy to separate user-friendly messages from raw `DioException` technical details (`technicalDetails`).
- **Loading UI & Skeletonizer:** Replaced `SpinKitThreeBounce` spinner with `RateDetailChartSkeleton` in `RateDetailScreen`'s `initial` and `loading` states. Wrapped `RateDetailChart` in `Skeletonizer(enabled: true)` with `isSkeleton: true` mode rendering a static muted-gray line/fill (`AppColors.dividerLight`/`dividerDark`). Tuned `_dummyPoints` to a low, near-flat baseline (`~48.60`) so the skeleton renders as a neutral, low placeholder shape near the X-axis, avoiding high-swinging curves that look like real data and eliminating layout jumps when success swaps in the real chart.
- **Brand Color & Chart Aesthetics:** Evaluated 3 accessible options and migrated `AppColors.primary` from blue to Indigo (`#4F46E5`). Removed red/green conditional coloring from `RateDetailChart`, locking line stroke and gradient fill to brand Indigo so `RateChangeBadge` exclusively owns direction signaling.
- **Visual Polish & Layout Pass:** (1) Switched avatar chips from mixed Arabic words/symbols to unified 2-letter country monograms (`US`, `EU`, `GB`, `SA`, `JP`); (2) Created `appCardDecoration` with soft elevation shadows (`blurRadius: 12/16`); (3) Restructured `RateDetailScreen` header hierarchy around a dominant `42px w800` hero rate display with vertical breathing room; (4) Attempted edge-to-edge chart bleed which clipped X-axis date labels, requiring a second corrective pass setting outer chart `Padding` to `EdgeInsets.only(left: 20, right: 20)` and removing per-index label padding branching.

### Phase 8 follow-up — Chart skeleton loading state fix — 2026-07-23 (commit `c5de4db`)
**Prompt:** Fix the chart loading state in RateDetailScreen: initial and loading branches previously shipped SpinKitThreeBounce (a spinner), violating the assessment requirement ("Chart must show a loading state (shimmer, not spinner)"). Implement a proper Skeletonizer loading skeleton for the chart, investigate fl_chart CustomPainter shimmer limitations, and document the full iteration path.
**Model returned:** Created `RateDetailChartSkeleton` in `lib/features/rates/presentations/widgets/rate_detail_chart_skeleton.dart` wrapping `RateDetailChart` in `Skeletonizer(enabled: true)` with `isSkeleton: true` mode, updated `RateDetailScreen` `initial`/`loading` states to render `RateDetailChartSkeleton`, added `test/features/rates/presentations/widgets/rate_detail_chart_skeleton_test.dart`, and updated `test/features/rates/presentations/views/rate_detail_screen_test.dart`. 50 tests pass, 0 analysis issues.
**Decision:** Edited across multiple rounds — reflecting real architectural and visual trade-offs disproven during interactive review:
- **Original Violation Discovered:** The initial Phase 8 build used `SpinKitThreeBounce` (`Loader`), violating the explicit mandate for a shimmer loading state on the chart.
- **First Attempt (Rejected as confusing):** Wrapped the real `RateDetailChart` with high-swinging dummy `HistoricalRatePoint` values inside `Skeletonizer(enabled: true)`. Result: visually looked like an active real data curve during fetch, confusing users into thinking real data had already loaded.
- **Second Attempt (Rejected & Reverted):** Built a completely separate fake-shapes placeholder (`Container`/`DecoratedBox` bars, zero `fl_chart` code) to force a cartoonish shimmer block look. Rejected and reverted because it created visual clutter and failed to reuse the production chart layout component.
- **Final Approach (Accepted):** Returned to wrapping `RateDetailChart`, but solved both issues:
  1. Added `isSkeleton: true` to `RateDetailChart` that swaps the brand Indigo line/gradient to static muted gray (`AppColors.dividerLight`/`dividerDark`) instead of expecting `Skeletonizer` to animate canvas drawings (confirmed `Skeletonizer` only bone-masks `RenderParagraph`/`RenderBox` nodes, not custom canvas paths).
  2. Flattened dummy points to a low, near-flat baseline (`~48.60`) near the X-axis so the rendered skeleton reads as a quiet placeholder, eliminating visual layout jumps when `success` swaps in real data.
- **Verification & Test Coverage:** Confirmed only the 4 bottom X-axis date labels shimmer-animate (`Skeletonizer` + `CustomPainter` technical limitation), while the chart curve sits static in neutral gray. Added `rate_detail_chart_skeleton_test.dart` (verifying `RateDetailChart` renders with `isSkeleton: true` and 7 dummy points) and updated `rate_detail_screen_test.dart` assertion to check `find.byType(RateDetailChartSkeleton)`.
- **Debug Logs & Loader Cleanup:** Removed 4 leftover debug `log()` calls from `RateDetailScreen` `state.when(...)` view branches and deleted unused `lib/core/widgets/loader.dart` (`SpinKitThreeBounce`) & `flutter_spinkit` dependency.
- **Chart Touch Tooltip:** Configured `lineTouchData` in `RateDetailChart` with 2-decimal rate formatting (`spot.y.toStringAsFixed(2)`) and high-contrast theme-aware styling (`AppColors.surfaceDark`/`surfaceLight` background, `AppColors.dividerDark`/`dividerLight` 1px border, and `AppColors.textPrimaryDark`/`textPrimaryLight` bold caption text).

### CI setup — GitHub Actions analyze & test pipeline — 2026-07-23 (commit `27ca8c1`)
**Prompt:** Fill in the existing stub workflow file under `.github/workflows/` with a minimal, working GitHub Actions pipeline that sets up stable Flutter, runs `flutter pub get`, `flutter analyze`, and `flutter test`, with pub dependency caching.
**Model returned:** Created `.github/workflows/ci.yml` triggering on push/pull_request to `main`/`master`, using `subosito/flutter-action@v2` with `cache: true`, running `flutter analyze` and `flutter test`. No build, code-signing, or deployment steps.
**Decision:** Accepted as-is.

### App Icon & Splash Screen — Native branding and animated splash — 2026-07-23 (commit `e9e7e19`)
**Prompt:** Draw an app icon and use it, and draw a professional splash screen and use it.
**Model returned:** Generated high-resolution custom fintech app icon (`assets/images/app_icon.png`) and gold/indigo branding artwork (`assets/images/splash_logo.png`) using `generate_image`, generated native Android/iOS launcher icons via `flutter_launcher_icons`, configured native launch screens via `flutter_native_splash`, and built animated `SplashScreen` widget in `lib/features/splash/presentations/views/splash_screen.dart`. 49 unit/widget tests pass, 0 analysis issues.
**Decision:** Accepted as-is.

### Rate Card Animations — Continuous pulse & price update fade transitions — 2026-07-23 (commit `9726f7c`)
**Prompt:** Make the card that shows the dollar price to be shown as makes a fade-in fade-out with perfect animation.
**Model returned:** Enhanced `RateListItem` with smooth entrance `FadeTransition` & `SlideTransition` animations, `AnimatedSwitcher` price update fade-in/out transitions, and custom primary highlight styling for the USD card.
**Decision:** Edited — User requested refining the transition into a continuous repeating breathing/pulse effect where the card container scales smoothly down to `0.97` and returns to `1.0` in a continuous loop (`_pulseController.repeat(reverse: true)` using `Curves.easeInOut`).











