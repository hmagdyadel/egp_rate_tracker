# egp_rate_tracker — Build Plan

Confirmed stack: Cubit + Freezed (states) + entities + Retrofit + Dio + json_serializable + get_it (DI) + Hive (cache) + flutter_offline (connectivity) + easy_localization (.tr()) + fl_chart + shimmer + mocktail/bloc_test + GitHub Actions CI. A lightweight `CustomBlocObserver` is included for state-transition logging. No flutter_screenutil, no Firebase — out of scope for this assessment.

Each phase below = one focused commit (or a couple of small commits). After every phase, add an entry to `AI_USAGE.md` before moving on — don't batch it at the end, the timestamps need to track with commits.

---

## Folder structure

```
lib/
  core/
    di/                    -> get_it setup
    networking/            -> Dio factory, ApiResult<T>, ApiConstants
    error/                 -> Failure + subtypes, exception -> failure mapper
    cache/                 -> HiveService
    router/                -> AppRouter
    theme/                 -> design tokens (spacing, colors, text styles), ThemeData light/dark
    l10n/                  -> easy_localization assets (assets/translations/en.json, ar.json)
    observer/              -> CustomBlocObserver
    widgets/               -> shared widgets (shimmer wrapper, error view, empty view, ConnectionBannerWrapper)
    bootstrap.dart           -> app init: WidgetsFlutterBinding, EasyLocalization.ensureInitialized(), setupGetIt(), Bloc.observer
  features/
    rates/
      data/
        models/            -> RatesModel (json_serializable)
        datasources/       -> RatesRemoteDataSource, RatesLocalDataSource
        repositories/      -> RatesRepositoryImpl
      domain/
        entities/          -> CurrencyRate (entity, no json annotations)
        repositories/      -> RatesRepository (abstract)
        usecases/          -> GetLatestRatesUseCase, GetHistoricalRatesUseCase, GetCachedRatesUseCase
      presentations/
        cubit/             -> RatesCubit, RatesState (freezed)
        views/             -> RatesListScreen, RateDetailScreen
        widgets/           -> RateListItem, RateChangeBadge
  main.dart
```

Test folder mirrors this 1:1 under `test/`, per the old project's convention.

---

## API Reference

Base: `https://latest.currency-api.pages.dev/v1/currencies/{base}.json`
Historical: `https://{YYYY-MM-DD}.currency-api.pages.dev/v1/currencies/{base}.json`

No auth, no key, no rate limit. Base currency is always `egp`, so every call hits `.../currencies/egp.json`.

| Purpose | URL |
|---|---|
| Latest rates | `https://latest.currency-api.pages.dev/v1/currencies/egp.json` |
| Yesterday's rates (for daily change) | `https://{yesterday's date}.currency-api.pages.dev/v1/currencies/egp.json` |
| Historical (7-day chart) | `https://{date}.currency-api.pages.dev/v1/currencies/egp.json`, one call per date, last 7 days |

Response shape: `{ "date": "2026-07-23", "egp": { "usd": 0.019227, "eur": ..., "gbp": ..., "sar": ..., "jpy": ... } }`. You only need 5 of the ~200 keys — pluck `usd`, `eur`, `gbp`, `sar`, `jpy` in the mapper, ignore the rest (no need to model the full response).

Since the historical host itself is date-templated (not a path segment), your `ApiConstants`/`DioFactory` needs the base URL built per-call rather than fixed at Dio-instance creation — e.g. a method `historicalBaseUrl(DateTime date) => 'https://${formatDate(date)}.currency-api.pages.dev/v1/currencies/'`, and pass it as Retrofit's `@DioFactory` baseUrl parameter or override per-request with `dio.options.baseUrl` before the call. Worth a comment in code explaining why, since it's a slightly unusual pattern next to your `PeopleRepository`'s fixed-baseUrl example.

Display math: `rate = 1 / egp[code]` (e.g. `1 / 0.019227 ≈ 52.01` EGP per USD). Daily change = today's inverted rate minus yesterday's inverted rate; percent = `change / yesterday_rate * 100`.

---

## UI Design Hints

The brief explicitly grades "UI & UX (attention to details)" as a separate line from architecture, so treat visual polish as a real phase, not an afterthought bolted onto Phase 4/5.

**List screen**
- Lead with the number, not the label — a currency list is a numbers screen. Rate in a large, tabular-figure font (use `FontFeature.tabularFigures()` so digits align vertically down the list); currency code as a bold small caption above it; full name as a muted subtitle.
- Change badge as a small pill (rounded, soft-tinted background — not solid red/green fill, which reads harsh) with a ▲/▼ glyph, not just color, so it's not color-only (accessibility, and reads fine at a glance).
- Give each row a subtle leading element — a colored initial-letter avatar or a small flag/currency-symbol chip — so the list doesn't read as five identical text rows.
- Skeleton loading (shimmer placeholders shaped like the actual rows), not a centered spinner, on first load — consistent with the shimmer requirement on the chart, and reads as more deliberate.
- Empty/error states: an icon + one-line message + a retry button, centered — never just text.

**Detail screen**
- Big number treatment again at the top (current rate), change pill beside it, "as of {date}" in a muted caption underneath — don't let the chart be the only thing that establishes context.
- Chart: keep gridlines minimal or omit them, use a soft area-gradient under the line (fades to transparent) rather than a flat stroke — reads as far more finished for very little extra code in `fl_chart`. Label only the first/last/min/max points instead of every X-axis tick, since 7 dates cramped onto a small screen gets noisy fast.
- Green/red should be the same tokens as the list badge — one change-color pair defined once in your theme, reused everywhere, not redefined per-widget.

**System-wide**
- Pick a genuinely restrained palette: one primary/brand color, one green, one red, and 2-3 neutrals for text/background/dividers. Resist adding more — a small, consistent palette reads as more "designed" than a colorful one.
- Consistent corner radius and spacing scale (e.g. 8/12/16/24 spacing tokens, one card radius) applied everywhere via your theme tokens file — inconsistent radii/spacing is the single biggest tell of an un-designed app.
- Dark mode isn't just inverted colors — check the change-color pair still has enough contrast on a dark background, and that the shimmer/chart gradient don't look muddy.
- Test the Arabic layout for real, not just "does the delegate load" — numbers and currency codes (USD, EGP) should likely stay LTR even inside an RTL row (wrap them in `Directionality(textDirection: TextDirection.ltr, ...)`), while labels and layout mirror. This is a detail that specifically separates "translated" from "actually RTL-aware," and it's cheap to get right if you decide it up front.
- Micro-interaction budget: pull-to-refresh, a tap ripple/scale on list rows, and a fade/slide transition into the detail screen are enough — don't chase animation for its own sake, the brief rewards polish, not flourish.

---

## Phase 1 — Scaffolding
- Folder skeleton above (empty files with class stubs are fine)
- `ApiConstants` with the two base URLs (latest + historical-by-date pattern)
- `DioFactory` + `ApiService` (Retrofit interface, both endpoints — historical takes the date as part of the path, so you'll build the URL per-call or use `@Path`)
- `get_it` setup file (empty registrations for now, wired up as layers land)
- `AppRouter` skeleton with the two routes
- Theme tokens file + light/dark `ThemeData`
- `assets/translations/en.json` + `ar.json`, `easy_localization` wired into `bootstrap.dart`/`MaterialApp` (`supportedLocales: [en, ar]`, `path: 'assets/translations'`)
- `CustomBlocObserver` (logs state transitions), set as `Bloc.observer` in `bootstrap.dart`
- Empty `.github/workflows/ci.yml` (can just checkout + `flutter pub get` for now, filled in Phase 8)
- Create `AI_USAGE.md` at repo root with the header/format you'll use, commit it now (not at the end)

## Phase 2 — Domain layer
- `CurrencyRate` entity: code, name, rate (EGP per unit), change absolute, change percent, last updated date — no json annotations, this is pure Dart
- `HistoricalRatePoint` entity: date + rate, for the chart
- `RatesRepository` abstract class: `getLatestRates()`, `getHistoricalRates(List<DateTime> dates, String currencyCode)`, `getCachedRates()`
- Three use cases wrapping those repository calls 1:1 (thin — just call through, this is what the eval criteria wants to see as domain-driven separation, not clever logic)
- Expand `Failure` into `NetworkFailure`, `ServerFailure`, `CacheFailure`, `NoInternetFailure`

## Phase 3 — Data layer
- `RatesResponseModel` (json_serializable) matching the API's `{ egp: { usd: ..., eur: ... } }` shape
- Mapper: raw model + yesterday's model -> `List<CurrencyRate>` entities (this is where the invert-the-rate and diff math lives — keep it in the mapper, not the Cubit)
- `RatesRemoteDataSource`: wraps `ApiService`, throws typed exceptions on Dio errors
- `RatesLocalDataSource`: wraps `HiveService`, save/read last-known rates + last-updated timestamp
- `RatesRepositoryImpl`: offline-first strategy matching your `PeopleRepositoryImpl` pattern — try the API first, cache successful responses, on `DioException`/error fall back to cache, and if there's no cache either, return an explicit `Failure`. Returns `ApiResult<T>` throughout.
- Wire all of the above into `get_it`

## Phase 4 — Module 1: Rates list
- `RatesState` (Freezed): initial / loading / success(List<CurrencyRate>, {isRefreshing}) / empty / error(message)
- `RatesCubit`: calls `GetLatestRatesUseCase`, computes/attaches change coloring
- `RatesListScreen`: list of `RateListItem` (code, name, rate, colored change), pull-to-refresh, loading/error/empty states, tap navigates to detail with the selected `CurrencyRate`
- Apply design tokens + localization strings here (no hardcoded colors/strings)

## Phase 5 — Module 2: Detail + chart
- Separate `DetailState`/`DetailCubit` (or extend RatesCubit if you prefer one cubit per feature — your call, but keep it consistent with how PeopleCubit split `getPersonDetails` as a separate method/state)
- `GetHistoricalRatesUseCase` call: 7 dates, extract the one currency from each response
- `fl_chart` line chart widget, `shimmer` while loading, friendly error message on failure/empty data
- Detail screen shows current rate, change, last-updated date, then the chart below

## Phase 6 — Module 3: Offline cache
- Wrap the app (or at least the rates flow) in `flutter_offline`'s `OfflineBuilder`, feeding a `ConnectionBannerWrapper` — reuse your existing floating banner pattern (red while offline, brief green flash on reconnect)
- `RatesRepositoryImpl` already handles the fetch/cache/fallback logic from Phase 3 — this phase is mostly wiring the connectivity signal into the UI and triggering a refresh on reconnect
- On reconnect: auto-trigger `RatesCubit.refresh()`
- Show a "last updated X" indicator on the list when serving cached data (distinct from the banner, which just signals connectivity — the indicator signals data freshness)
- Make sure Module 1's error/empty states don't fire when there's valid cached data to fall back to

## Phase 7 — Testing pass
- Unit tests: mappers (rate inversion + diff math — this is the highest-value test in the whole app), use cases, repository (mock both data sources)
- Cubit tests (`bloc_test`): every state transition for both list and detail cubits — success, error, empty, offline-fallback
- Widget tests: list screen (loading/success/error/empty render correctly), detail screen renders chart states
- Optional: golden test for the list item / chart if time allows

## Phase 8 — Polish + CI/CD + docs
- Fill in `ci.yml`: `flutter analyze` + `flutter test` on push/PR to main; optional APK build artifact
- README: setup steps, architecture overview, screenshots/GIF
- Final `AI_USAGE.md` pass — check timestamps line up with actual commits, not written retrospectively
- RTL pass in Arabic, dark mode pass

---

## AI_USAGE.md entry format (use from Phase 1 onward)

```
### [Phase / feature] - YYYY-MM-DD
**Prompt:** <what you asked>
**Model returned:** <1-2 line summary of what it gave you>
**Decision:** Accepted as-is / Edited (why) / Rejected (why)
```

Keep entries short and honest — a rejected or edited suggestion with a real reason is worth more to the interviewer than five "accepted as-is" entries.

---

## A few extra suggestions

- **Chart data shape**: fetch the 7 historical dates in parallel (`Future.wait`), not sequentially — matters for perceived load time and is an easy thing to point to in AI_USAGE.md as something you specifically directed the AI to do.
- **Rate direction bug risk**: the API gives EGP-to-foreign; you need foreign-to-EGP (invert). This is the single easiest correctness bug to ship — put a unit test on it first, before wiring up the UI, so it can't slip through.
- **Consistent `ApiResult<T>`**: keep using the old project's `ApiResult.when(success/failure)` pattern all the way from data source through repository through use case through cubit — don't let raw exceptions leak into the domain layer.
- **Freezed `@Default` for refreshing-style flags**: the old `PeopleStates.success` pattern (data + a bool flag) maps directly onto an `isRefreshing` flag for pull-to-refresh — reuse that shape.
- **Don't over-engineer the use-case layer**: keep them thin (repository call + maybe input validation only). Reviewers can tell when a use-case layer is padding vs. genuinely separating concerns.
