# EGP Rate Tracker

A production-ready Flutter application for tracking the latest Egyptian Pound (EGP) exchange rates against multiple foreign currencies. The project demonstrates modern Flutter architecture, clean separation of concerns, offline-first capabilities, testability, localization, and maintainable code organization.

> **Purpose:** This project was built as a technical assessment while following production-grade engineering practices rather than simply delivering the required features.

---

# Features

### Exchange Rates

* View the latest EGP exchange rates.
* Display currency code, currency name, and current exchange rate.
* Calculate and display daily change (absolute and percentage).
* Pull-to-refresh support.
* Loading, empty, and error states.

### Historical Data

* View detailed information for each currency.
* Interactive 7-day historical chart.
* Loading shimmer while fetching historical data.
* Friendly fallback UI when no historical data is available.

### Offline-First Experience

* Automatically caches the latest successful response.
* Reads cached data when internet is unavailable.
* Shows connection status using a floating connectivity banner.
* Automatically refreshes data once connectivity is restored.
* Displays the last successful update timestamp when using cached data.

### Localization

* English
* Arabic (RTL support)

### Theme Support

* Light Theme
* Dark Theme

### Quality

* Unit Tests
* Cubit Tests
* Widget Tests
* GitHub Actions Continuous Integration

---

# Architecture

The application follows **Clean Architecture** combined with **Feature-First Organization**, ensuring scalability, maintainability, and clear responsibility boundaries.

```
Presentation
     │
     ▼
Domain (Entities + Use Cases)
     │
     ▼
Repository
     │
     ▼
Data Sources
 ┌──────────────┐
 │ Remote (API) │
 └──────────────┘
 ┌──────────────┐
 │ Local (Hive) │
 └──────────────┘
```

Each layer has a single responsibility:

### Presentation

Responsible for UI rendering and state management.

* Cubit
* Freezed States
* Views
* Reusable Widgets

### Domain

Contains pure business logic independent of Flutter or networking.

* Entities
* Repository Contracts
* Use Cases

### Data

Responsible for retrieving and caching data.

* Retrofit API
* Dio Networking
* Hive Local Storage
* Repository Implementation
* Data Mappers

---

# Project Structure

```
lib
│
├── core
│   ├── bootstrap
│   ├── cache
│   ├── di
│   ├── error
│   ├── l10n
│   ├── networking
│   ├── observer
│   ├── router
│   ├── theme
│   └── widgets
│
├── features
│   └── rates
│       ├── data
│       ├── domain
│       └── presentation
│
└── main.dart
```

The project follows a **feature-first** structure where every feature encapsulates its presentation, domain, and data layers.

---

# Tech Stack

| Category             | Technology                        |
| -------------------- | --------------------------------- |
| Framework            | Flutter                           |
| Language             | Dart                              |
| State Management     | Cubit (flutter_bloc)              |
| Immutable Models     | Freezed                           |
| Dependency Injection | get_it                            |
| Networking           | Dio                               |
| REST Client          | Retrofit                          |
| JSON Serialization   | json_serializable                 |
| Local Database       | Hive                              |
| Connectivity         | flutter_offline                   |
| Charts               | fl_chart                          |
| Localization         | easy_localization                 |
| Loading UI           | shimmer                           |
| Testing              | flutter_test, bloc_test, mocktail |
| CI/CD                | GitHub Actions                    |

---

# Design Principles

The project follows several software engineering principles:

* Clean Architecture
* SOLID Principles
* Dependency Inversion
* Feature Isolation
* Offline-First Strategy
* Repository Pattern
* Single Source of Truth
* Separation of Concerns
* Test-Driven Friendly Design
* Immutable State Management

---

# State Management

The application uses **Cubit** from `flutter_bloc`.

Each feature owns its own Cubit and immutable Freezed state.

Typical state flow:

```
Initial

↓

Loading

↓

Success
│
├── Refreshing
│
└── Updated

↓

Error
```

This keeps UI logic predictable and easy to test.

---

# Networking

Networking is built using:

* Dio
* Retrofit
* Typed API Responses
* Generic ApiResult<T>
* Failure Mapping
* Centralized Exception Handling

The networking layer never exposes raw exceptions outside the data layer.

---

# Offline Strategy

The application implements an **offline-first repository**.

Workflow:

```
Fetch API
      │
      ▼
Success
      │
      ▼
Save to Hive
      │
      ▼
Return Data

If API Fails

      ▼

Read Cache

      │

Cache Exists
      │
      ▼
Return Cached Data

Otherwise

Return Failure
```

This ensures the application remains usable without an internet connection whenever cached data is available.

---

# Localization

The application supports:

* English
* Arabic (RTL)

All user-facing strings are localized using **easy_localization**.

No hardcoded UI strings are used.

---

# Theme

The application provides:

* Light Theme
* Dark Theme

Design tokens centralize:

* Colors
* Typography
* Spacing
* Border Radius

This approach keeps styling consistent across the application.

---

# Testing Strategy

The project includes multiple testing layers.

### Unit Tests

* Data mappers
* Repository
* Use Cases
* Utility functions

### Cubit Tests

* Loading states
* Success states
* Error states
* Offline fallback
* Refresh flow

### Widget Tests

* Rates list
* Detail screen
* Error UI
* Empty UI
* Loading UI

The repository and Cubits are designed to be fully mockable.

---

# Continuous Integration

GitHub Actions automatically runs on every push and pull request.

Pipeline includes:

* Dependency installation
* Static analysis
* Unit tests
* Widget tests

This helps maintain code quality and prevents regressions.

---

# Getting Started

## Prerequisites

* Flutter SDK (latest stable)
* Dart SDK
* Android Studio or VS Code
* Git

---

## Clone the Repository

```bash
git clone <repository-url>
cd egp_rate_tracker
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Run the Application

```bash
flutter run
```

---

## Execute Tests

```bash
flutter test
```

---

## Static Analysis

```bash
flutter analyze
```

---

# Screenshots

```
README Assets/

screenshots/
├── rates_list.png
├── details.png
├── offline.png
├── dark_mode.png

gif/
└── demo.gif
```

> Screenshots and demo GIF can be added once the implementation is complete.

---

# AI Usage

This repository includes an **AI_USAGE.md** document that transparently records AI-assisted development throughout the implementation.

Each entry includes:

* Development phase
* Prompt provided
* AI-generated response summary
* Final engineering decision

The document reflects the actual development timeline rather than retrospective documentation.

---

# Engineering Decisions

Some notable implementation decisions include:

* Clean Architecture to improve maintainability and scalability.
* Repository Pattern to abstract data sources.
* Offline-first behavior using Hive for a resilient user experience.
* Freezed for immutable state modeling.
* Feature-first organization for modular development.
* Centralized dependency injection using get_it.
* Generic ApiResult and Failure models to standardize error handling.
* Parallel historical requests (`Future.wait`) to reduce perceived latency.
* Comprehensive testing across business logic, state management, and UI.

---

# Future Improvements

Potential enhancements beyond the assessment scope include:

* Currency search and filtering.
* Favorites and pinned currencies.
* Exchange rate alerts.
* Multiple base currencies.
* Interactive chart zoom and pan.
* Period selection (7D, 30D, 90D, 1Y).
* Automatic background synchronization.
* Performance monitoring and analytics.
* Accessibility improvements.
* Material 3 dynamic color support.

---

# License

This project is intended for technical assessment and educational purposes.

---

## Author

Developed with a focus on production-ready Flutter architecture, clean code practices, maintainability, and scalability.
