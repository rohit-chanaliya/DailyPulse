---
trigger: always_on
---

# DailyPulse Coding Style Guide

## Dart / Flutter

### Modern Dart 3+
- Prefer `switch` expressions (`return switch (v) { ... };`) with `when` guards over `if-else` cascades.
- Use typed records for multi-value returns and destructuring: `final (:lat, :lon) = coords;`.
- Model UI states and unions with `sealed class` for exhaustive matching.
- Use class modifiers (`final`, `sealed`, `interface`, `base`) when they clarify intent; `abstract final class` for constant holders (see `AppRoutes`).
- Use `extension type` for typed IDs/wrappers, `_` for unused parameters, `const` constructors wherever possible.
- Prefer `?.` / `??` / pattern matching over `!` and aggressive casts.

### Widgets
- **Class-based widgets only.** No `Widget _buildX()` helpers — create a `StatelessWidget` / `StatefulWidget`.
- Each non-trivial widget lives in its own `snake_case.dart` file.
- **Max 300 lines per UI file.** Extract sub-widgets before crossing it. Never grow a file that is already over the limit.
- Keep `build` methods shallow; extract repeated subtrees into widgets, not methods.
- Mark widgets and subtrees `const` where possible.
- Never use `BuildContext` after an `await` without checking `mounted` (`context.mounted` in stateless code).

### Feature Architecture (new features)
```
features/<feature>/
├── models/      # plain data / DTOs
├── mappers/     # entity <-> DTO transforms
├── datasource/  # raw Hive / Firestore access
├── repository/  # business logic + coordination
├── services/    # framework / system wrappers
├── viewmodels/  # <name>_signal.dart
└── views/       # screens + widgets
```
Use only the layers the feature needs. Do not restructure existing features unless asked.

### State (signals_flutter)
- A `XSignal` class owns `signal<T>()` fields, `computed()` derived values and action methods; one top-level instance per file (`final xSignal = XSignal();`).
- Read signals in the UI with `Watch((context) => ...)` or `SignalBuilder`; keep the reactive region small.
- No new `ChangeNotifier` / `notifyListeners()`. No Riverpod, Bloc, GetX, Provider, GetIt.

### Theming
- Colors: `context.colors` (ColorScheme) or a `ThemeExtension` (`context.mood`, `.status`, `.cards`, `.gradients`, `.splash`, `.onboarding`).
- New semantic color → add it to a `ThemeExtension` with **light and dark values**; wire it in `light_theme.dart`, `dark_theme.dart` and `context_extensions.dart` if it is a new extension.
- Never use raw `Color(0xFF...)` / `Colors.xxx`, legacy `AppConstants.moodColors*`, or `@Deprecated` `AppTheme` color statics in widgets.
- Typography via `context.textTheme` / `AppTypography`.
- Every screen must look correct in light and dark.

### Strings, Routes, Logging
- New user-facing copy → `core/constant/strings/<feature>_strings.dart`.
- Route paths → `AppRoutes`; declare in `createAppRouter()`; use `context.go` / `context.push`.
- Logging → `appLogger.d/i/w/e` (pass `error:` and `stackTrace:` on `e`). Never `print()`.

### Data
- Hive first, sync second. Firestore only through `FirestoreService`, always scoped by `userId`.
- Hive adapters: additive changes only (new field index, null-tolerant read). Never reuse or renumber indexes.

### Naming
- Classes / enums / extension types: `UpperCamelCase`. Files: `snake_case.dart`.
- Variables, methods, constants, enum values: `lowerCamelCase`.
- Signal classes `<Name>Signal`, top-level instance `<name>Signal`; strings classes `<Feature>Strings`.

### Imports (flutter_lints)
1. `dart:` imports
2. `package:flutter/...` and other packages
3. `package:dailypulse/...` (project imports; relative imports are tolerated inside a feature)

### Comments
- One-line docstrings for public classes/methods when they add information. No narration of obvious code, no commented-out code.

### Do NOT
- Write tests, docs or abstractions the user didn't ask for.
- Silence the analyzer with `// ignore:` instead of fixing the cause.
- Add a dependency without telling the user (package, reason, what it replaces).
- Put secrets, tokens or personal data (mood notes, emails) in logs or source.
