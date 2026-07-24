# EGP Rate Tracker

A production-ready Flutter application for tracking live and historical Egyptian Pound (EGP) exchange rates against key foreign currencies (USD, EUR, GBP, SAR, JPY). Built with Clean Architecture, Cubit state management, offline-first caching, interactive multi-range historical charts, and full localization support.

---

## Screenshots / Demo

*(Add screenshots or a screen recording demo here)*

- **Rates List Screen**: Displays live exchange rates against EGP with direction badges and USD primary pulse animation.
- **Rate Detail Screen & Multi-Range Chart**: Interactive historical trend chart (`7D`, `1M`, `6M`, `1Y`, `MAX`) with high-contrast touch tooltips.
- **Offline State & Cached Snapshot**: Floating `ConnectionBannerWrapper` status banner and snapshot timestamp bar when displaying cached Hive data.
- **Shimmer Loading State**: `Skeletonizer` shimmer loading placeholders across rates list and chart views.

---

## Features

- **Live Rates List**: Real-time EGP exchange rates for 5 major currencies (`USD`, `EUR`, `GBP`, `SAR`, `JPY`) with daily percentage & absolute rate change indicators (`▲` / `▼` / `—`).
- **USD Highlight & Pulse Animation**: Continuous subtle breathing pulse animation (`ScaleTransition`) and primary accent styling for the USD card.
- **Pull-to-Refresh**: Seamless list refresh updating latest exchange rates.
- **Multi-Range Historical Chart**: Interactive `fl_chart` trend visualization supporting `7D`, `1M`, `6M`, `1Y`, and `MAX` date ranges with chunked API batching.
- **Touch Tooltip**: High-contrast, theme-aware tooltip displaying formatted 2-decimal rate values and date labels on chart touch.
- **Offline-First Caching**: Automatic local Hive storage fallback when offline, displaying a "Last updated: {date}" snapshot timestamp banner.
- **Offline Reconnect Banner**: Global `ConnectionBannerWrapper` displaying connectivity status banners and triggering automatic auto-refresh on network reconnection.
- **Resilient States**: Complete Loading (`Skeletonizer`), Error (`ErrorView` with retry), and Empty UI handling across all modules.
- **Localization**: Full English and Arabic (RTL) localization via `easy_localization`.
- **Light & Dark Theme**: Custom contrast-checked design system with modern Indigo primary branding (`AppColors.primary = #4F46E5`).

---

## Architecture

The project strictly follows **Clean Architecture** combined with **Feature-First Folder Organization**:

```
lib/
├── core/                   # Shared cross-cutting concerns (DI, Theme, Error, Router, Networking)
├── features/
│   ├── rates/              # Main currency rate domain & feature logic
│   │   ├── data/           # Remote API (Retrofit/Dio), Local Storage (Hive), Mappers, Repositories
│   │   ├── domain/         # Entities, Repository Interfaces, Use Cases
│   │   └── presentations/  # Cubits, States (Freezed), Views, Widgets
│   └── splash/             # Initial animated branding splash screen
```

### Key Architectural Principles
- **Domain Layer Isolation**: Pure Dart entities and use cases zero-dependent on Flutter UI, Dio, or Hive.
- **State Management**: `Cubit` + immutable `Freezed` union states (`initial`, `loading`, `success`, `error`, `empty`) ensuring exhaustive UI branching with `state.when(...)`.
- **Offline-First Repository Pattern**: Fetches remote API data → updates local Hive cache → returns data. On network or server failure, seamlessly falls back to cached Hive data.

---

## Tech Stack

Derived directly from `pubspec.yaml`:

| Category | Package | Version |
| :--- | :--- | :--- |
| **Framework** | Flutter | `>=3.12.2` |
| **State Management** | `flutter_bloc` | `^9.1.1` |
| **Immutable Models** | `freezed_annotation` | `^3.0.0` |
| **Dependency Injection** | `get_it` | `^8.0.3` |
| **Networking** | `dio` / `retrofit` | `^5.8.0+1` / `^4.4.2` |
| **Serialization** | `json_annotation` | `^4.12.0` |
| **Local Storage** | `hive` / `hive_flutter` | `^2.2.3` / `^1.1.0` |
| **Connectivity** | `flutter_offline` | `^4.0.0` |
| **Charts** | `fl_chart` | `^0.70.2` |
| **Loading Shimmer** | `skeletonizer` | `^2.0.0` |
| **Localization** | `easy_localization` | `^3.0.7+1` |
| **Testing** | `mocktail` / `bloc_test` | `^1.0.4` / `^10.0.0` |

---

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI workflow (analyze + test)
├── assets/
│   ├── images/                # App icon & splash screen branding assets
│   └── translations/          # en.json & ar.json localization files
├── lib/
│   ├── core/
│   │   ├── bootstrap/         # App initialization & Hive setup
│   │   ├── di/                # GetIt dependency injection setup
│   │   ├── error/             # Failure hierarchy & ExceptionMapper
│   │   ├── networking/        # DioFactory & ApiService (Retrofit)
│   │   ├── router/            # AppRouter & Routes
│   │   ├── theme/             # AppColors, AppSpacing, AppTextStyles, AppTheme
│   │   └── widgets/           # ConnectionBannerWrapper, ErrorView, Skeleton
│   ├── features/
│   │   ├── rates/
│   │   │   ├── data/          # Data sources, mappers, repository implementation
│   │   │   ├── domain/        # Entities (CurrencyRate, HistoricalRatePoint, ChartRange), Use Cases
│   │   │   └── presentations/ # Cubits (RatesCubit, DetailCubit), Views, Widgets
│   │   └── splash/            # SplashScreen view & branding animation
│   └── main.dart
├── test/                      # Tests mirroring lib/ structure
├── AI_USAGE.md                # End-to-end AI development log
└── pubspec.yaml
```

---

## Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.12.2` (Stable channel)
- **Dart SDK**: `>=3.0.0`
- **Git**

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd egp_rate_tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (Freezed & Retrofit):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Run all tests:**
   ```bash
   flutter test
   ```

6. **Run static analysis:**
   ```bash
   flutter analyze
   ```

---

## API Reference

This app consumes the free, public Currency Exchange Rate API (`currency-api.pages.dev`, no API key required):

- **Latest Rates Base URL**: `https://latest.currency-api.pages.dev/v1/currencies/`
- **Historical Rates Base URL**: `https://{YYYY-MM-DD}.currency-api.pages.dev/v1/currencies/` (e.g. `https://2026-07-22.currency-api.pages.dev/v1/currencies/`)
- **Endpoint**: `egp.json`

---

## Continuous Integration (CI)

A GitHub Actions pipeline is configured in [.github/workflows/ci.yml](file:///.github/workflows/ci.yml). On every `push` and `pull_request` to `main` or `master`, the workflow automatically:
1. Sets up stable Flutter SDK with dependency caching.
2. Executes `flutter pub get`.
3. Runs `flutter analyze` (failing build on lint issues).
4. Runs `flutter test` (failing build on test failures).

---

## Testing

The project includes **49 passing unit, cubit, and widget tests**:
- **Domain & Data Unit Tests**: Verification of `ExceptionMapper`, data mappers, and repository chunked batching (`_fetchInBatches`).
- **Cubit Tests**: Full state transition coverage for `RatesCubit` and `DetailCubit` (loading, success, error, empty, range selection).
- **Widget Tests**: Testing `RatesListScreen`, `RateDetailScreen`, `RateDetailChartSkeleton`, `ChartRangeSelector`, `RateChangeBadge`, and `SplashScreen`.

---

## AI Usage Log

This repository includes a comprehensive [AI_USAGE.md](file:///AI_USAGE.md) log at the root directory. It documents the prompt, AI model output summary, commit reference hash, and engineering decisions for every phase of development.
