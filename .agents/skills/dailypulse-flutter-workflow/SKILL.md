---
name: dailypulse-flutter-workflow
description: >
  Step-by-step workflow for adding or changing a feature in the DailyPulse Flutter app.
  Activate when building a new screen, widget, signal, repository, Hive/Firestore data
  change or route. Covers feature layout, offline-first data layer, signals_flutter state,
  theme-extension colors, strings, go_router wiring and verification.
---

# DailyPulse Flutter Feature Workflow

Use for any work under `lib/features/` or `lib/core/`. Rules: `AGENTS.md`, `.agents/rules/coding-style.md`. Process (branch, gates, commit): `WORKFLOW.md`.

## Principles
1. **Offline-first:** Hive is written first; Firestore sync is background-only.
2. **Signals:** `signals_flutter` for all new state, exposed through `AppComponent` (compile-time DI). No `ChangeNotifier`, Riverpod, Bloc, GetX, Provider.
3. **Class-based widgets**, one per file, ≤ 300 lines.
4. **Theme tokens:** `context.colors` / `ThemeExtension`s with light **and** dark values.
5. **Scope discipline:** touch only what the task needs. No extra tests unless asked.

---

## Step 1 — Feature folder (new features only)

```
lib/features/<feature>/
├── models/
├── datasource/
├── repository/
├── viewmodels/   # <feature>_signal.dart
└── views/        # screens + widgets/
```
Use only the layers you need. For an existing feature, add files in its current layout.

## Step 2 — Model
- Plain immutable class, `const` constructor, `copyWith`, and `toFirestore` / `fromFirestore` if it syncs.
- If it is stored in Hive: extend the **hand-written adapter** additively (new field index, `null`-tolerant read, bump `_fieldCount`). Never change `typeId`, existing indexes, or the box name.
- Synced documents always include `userId`.

## Step 3 — Datasource / repository
- Local: through `HiveService`. Remote: through `FirestoreService`, every query filtered by `userId`.
- Repository writes locally first, then triggers `SyncService`. An entry with `id == null` is pending sync.
- New Firestore collection → add a per-user rule to `firestore.rules.template` and tell the user to publish it.
- Catch, log with `appLogger.e('msg', error: e, stackTrace: st)` and return a safe fallback (e.g. local data).

```dart
/// Stores and reads streak data, local first.
class StreakRepository {
  Future<void> save(StreakEntry entry, String userId) async {
    await HiveService.putStreak(entry.copyWith(userId: userId));
    _syncService.syncPendingEntries();
  }
}
```

## Step 4 — Signal

```dart
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Streak state backed by signals.
@singleton
class StreakSignal {
  @inject
  StreakSignal(this._repository);

  final StreakRepository _repository;

  final isLoading = signal(false);
  final entries = signal<List<StreakEntry>>(const []);
  late final count = computed(() => entries.value.length);

  Future<void> load(String userId) async {
    isLoading.value = true;
    try {
      entries.value = _repository.getAll();
    } catch (e, st) {
      appLogger.e('Error loading streaks', error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }
}
```

No top-level `final streakSignal = ...` — the instance comes from the DI graph.

## Step 5 — Register in `AppComponent`

In `lib/core/di/app_component.dart` add getters for every new repository/service/signal:

```dart
StreakRepository get streakRepository;
StreakSignal get streakSignal;
```

Annotate the classes with `@singleton` and their constructors with `@inject`. Third-party objects (Firebase, connectivity, plugins) go into a `@module` with `@provides @singleton` (`firebase_module.dart`, `infrastructure_module.dart`). Then regenerate the graph:

```bash
dart run build_runner build
```

Never edit `app_component.inject.dart` by hand.

## Step 6 — Strings, route, theme tokens
- Copy → `lib/core/constant/strings/<feature>_strings.dart` (`abstract final class <Feature>Strings`).
- Route → constant in `AppRoutes` (+ `publicRoutes` if unauthenticated) and a `GoRoute` in `createAppRouter()`.
- New semantic color → add to a `ThemeExtension` with light + dark values and wire it in both themes.

## Step 7 — View
- Separate `StatelessWidget` classes in separate files; read signals via `Watch` / `SignalBuilder` and access state through `appComponent`.

```dart
import 'package:dailypulse/core/di/injection.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final colors = context.colors;
      return Card(
        color: context.cards.journalCard,
        child: Text(
          '${appComponent.streakSignal.count.value}',
          style: context.textTheme.headlineMedium?.copyWith(
            color: colors.onSurface,
          ),
        ),
      );
    });
  }
}
```

- No `Widget _buildX()` helpers; no raw colors; no raw strings; guard `BuildContext` after `await`.
- Handle empty, loading, error and offline states.

## Step 8 — Verify

```bash
dart run build_runner build   # after DI annotation changes
flutter pub get               # only if pubspec or assets changed
flutter analyze               # 0 issues
flutter test
```
Then run the app and check the screen in **light and dark**, online and offline.
