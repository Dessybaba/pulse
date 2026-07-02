# Pulse — Flutter Expense Tracker

A personal expense tracker built for the PebbleScore Flutter Engineer take-home assessment.

The application communicates with a remote REST API to fetch, create, and delete expenses while displaying a running total formatted in Nigerian Naira. It demonstrates clean architecture, Riverpod state management, proper error handling, testing, and a responsive user experience.

---

## Features

- Fetch expenses from a remote REST API
- Add new expenses with form validation
- Delete expenses with confirmation
- Pull-to-refresh support
- Running total formatted in Nigerian Naira (NGN)
- Loading, empty, and retryable error states
- Light and dark theme support
- Custom animated Pulse signature loading indicator
- Repository-based architecture with Riverpod state management

---

## How to Run

### Requirements

- Flutter 3.x
- Dart SDK ^3.3.0

### Installation

```bash
flutter pub get
flutter run
```

---

## State Management

The application uses **Riverpod** with manually implemented `AsyncNotifier` providers (without code generation).

`AsyncNotifier` together with `AsyncValue` provides a clean way to model loading, success, and error states while keeping business logic separate from the presentation layer.

Riverpod was chosen because it provides:

- Reactive state management
- Excellent testability
- Minimal boilerplate
- Clear separation of concerns

---

## Architecture

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── models/
├── services/
├── repositories/
├── providers/
├── routing/
├── screens/
├── widgets/
└── theme/
```

### Why Repository Pattern?

The presentation layer never communicates directly with Dio.

Screens and providers depend on the abstract `ExpenseRepository`, allowing the networking implementation to change without affecting the rest of the application.

### Why a Failure Hierarchy?

Networking exceptions are translated into typed `Failure` objects before reaching the UI.

This allows the presentation layer to display meaningful messages without depending on HTTP status codes or Dio-specific exceptions.

---

## API

The application communicates with the PebbleScore mock REST API using Dio.

Supported operations include:

- Fetch all expenses
- Create a new expense
- Delete an expense

Networking concerns remain isolated inside the API service while repositories convert transport exceptions into domain-specific failures.

---

## Design System

The application includes a lightweight custom design system.

- **Color Palette:** Deep teal with pulse-coral accents
- **Typography:** Space Grotesk, Inter, and IBM Plex Mono
- **Motion:** Subtle fade and slide animations
- **Signature Element:** Custom animated Pulse/ECG loading indicator inspired by the application's name

---

## Packages Used

| Package | Purpose |
|----------|---------|
| flutter_riverpod | State management |
| dio | REST API communication |
| go_router | Navigation |
| intl | Currency and date formatting |
| equatable | Value equality |
| google_fonts | Typography |
| mocktail | Unit testing |

---

## Testing

The project contains meaningful tests covering the application's core behaviour.

- Repository tests verifying Dio exception mapping
- Provider tests verifying state updates and running totals
- Widget smoke test verifying application startup

Run the tests using:

```bash
flutter test
```

### Testing Philosophy

Rather than maximizing test quantity, the focus was on testing the application's most important behaviour:

- Repository error translation
- State management
- Running total calculation
- Basic application startup

---

## Trade-offs

Due to the assignment timeline, a few implementation decisions were intentionally kept simple.

1. Category validation is handled manually instead of using `DropdownButtonFormField`'s built-in validator.
2. Local state is updated immediately after successful create and delete operations instead of performing a full synchronization with the server.
3. Retry with exponential backoff has not yet been implemented for transient network failures.

---

## Future Improvements

With additional development time I would add:

- Offline caching using Hive or Drift
- Retry with exponential backoff
- More widget and integration tests
- Persist user-selected theme mode
- Pagination for large datasets
- Search and filtering capabilities

