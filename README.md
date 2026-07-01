# Pulse — Flutter Expense Tracker

A production-inspired Flutter expense tracker built as part of the **PebbleScore Flutter Engineer Take-Home Assessment**.

The application fetches, creates, and deletes expenses from a remote REST API while demonstrating clean architecture, Riverpod state management, robust error handling, meaningful testing, and a maintainable project structure.

---

# Features

* View all expenses from a remote API
* Display a running total formatted in Nigerian Naira (NGN)
* Pull-to-refresh support
* Loading, empty, and error states
* Retry on failed requests
* Add new expenses with form validation
* View expense details
* Delete expenses with confirmation
* Responsive Material 3 interface

---

# Getting Started

## Requirements

* Flutter 3.x
* Dart SDK ^3.3.0

## Installation

```bash
flutter pub get
flutter run
```

---

# State Management

This project uses **Riverpod** with manually declared `AsyncNotifier` providers (without code generation).

`AsyncValue` naturally models the application's loading, success, and error states, making it an excellent fit for the requirements of this assessment while keeping the implementation concise and easy to reason about.

I intentionally avoided code generation to reduce tooling complexity and keep the project straightforward to understand, debug, and explain during the technical walkthrough.


# Architecture

The application follows a layered architecture with clear separation of responsibilities.

```
Presentation (Screens & Widgets)
            ↓
Riverpod Providers
            ↓
Expense Repository
            ↓
Expense API Service (Dio)
            ↓
REST API
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
├── widgets/
├── routing/
├── theme/
└── main.dart
```

This structure keeps presentation, business logic, networking, and shared utilities clearly separated, making the project easier to maintain and extend.

---

# Technical Decisions

## Why Riverpod?

Riverpod was selected because it offers a simple, scalable, and testable state management solution. It provides compile-time safety, dependency injection, and clean separation between UI and business logic without relying on `BuildContext`.

---

## Why the Repository Pattern?

The presentation layer depends on the `ExpenseRepository` abstraction rather than communicating directly with Dio.

This isolates networking concerns from the UI, making the application easier to maintain, test, and extend. If the backend changes or offline caching is introduced later, only the repository implementation needs to change.

---

## Why a Typed Failure Hierarchy?

Instead of exposing Dio exceptions or HTTP status codes directly to the UI, all networking errors are translated into typed `Failure` objects.

This allows the presentation layer to display meaningful user-friendly messages while remaining independent of the networking library. It also keeps error handling consistent across the application and improves testability.

---

# Packages Used

| Package          | Purpose                                     |
| ---------------- | ------------------------------------------- |
| flutter_riverpod | State management                            |
| dio              | HTTP networking                             |
| go_router        | Declarative navigation                      |
| intl             | Nigerian Naira currency and date formatting |
| equatable        | Value equality for models                   |
| mocktail         | Mocking during unit tests                   |

---

# Testing

The project includes a focused test suite covering the application's core business logic.

* **Repository Tests** – Verify that Dio exceptions are translated into typed `Failure` objects such as network failures, validation errors, and server errors.
* **Provider Tests** – Verify expense loading, local state updates after creating an expense without refetching, deletion, and running total calculations.
* **Widget Tests** – Verify that the application launches successfully and renders the initial expense list screen.

Run all tests using:

```bash
flutter test
```

---

# Trade-offs

Given the time constraints of this assessment, I prioritised clean architecture, maintainability, and correctness over additional features.

Areas I would improve include:

1. The category field currently uses a manual validation flag. In a production application I would rely on `DropdownButtonFormField`'s built-in validation to reduce boilerplate.

2. The networking layer performs immediate requests without retry or exponential backoff. For a production fintech application, I would implement retry logic for transient network failures.

3. Test coverage focuses on the application's core business logic. With additional time, I would expand widget and integration testing to cover more user interaction scenarios.

---

# Future Improvements

If this application were to continue beyond the scope of this assessment, I would consider implementing:

* Offline-first support using Hive or Drift
* Edit expense functionality
* Retry with exponential backoff
* Search and filtering
* Pagination for large expense histories
* Improved accessibility support
* Dark mode
* More comprehensive widget tests
* Integration and end-to-end testing

---

# Design Principles

While implementing this assessment, I focused on the following engineering principles:

* Clear separation of concerns
* Small, reusable widgets
* Testable business logic
* Consistent error handling
* Readable and maintainable code
* Scalable project structure

The goal was to build a solution that could realistically serve as the foundation for a production feature rather than simply meeting the functional requirements.

---

# Running the Project

```bash
flutter pub get
flutter run
```

---

# Running Tests

```bash
flutter test
```
