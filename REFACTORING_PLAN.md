# DailyPulse — Senior Architect Refactoring Blueprint

> **Purpose:** Actionable, step-by-step architectural refactoring guide to scale **DailyPulse** (`161 Dart files`, `~14.8k LOC`) to medium-to-large production standards while improving readability, testability, and maintainability.
>
> **Strategy:** Incremental Strangler Pattern — **6 atomic, PR-sized phases**. Never do a "big bang" rewrite. After every phase, `flutter analyze` (0 issues) and `flutter test` must pass before moving to the next phase.
>
> **Companion Docs:** Follow all guardrails in [`AGENTS.md`](AGENTS.md) and the delivery process in [`WORKFLOW.md`](WORKFLOW.md).

---

## 1. Executive Scorecard (Baseline Audit)

| Dimension | Baseline Score | Target Score | Key Gap Identified |
| :--- | :---: | :---: | :--- |
| **Offline-First & Sync Engine** | **8.5 / 10** | **9.5 / 10** | Strong idempotent `localId` sync & merge; needs nullable `copyWith` fix & unit tests. |
| **Compile-Time DI (`inject`)** | **6.5 / 10** | **9.5 / 10** | `HiveService`, `AppPreferences`, and `DeepLinkService` use `static` globals instead of DI. |
| **State Management (`signals`)** | **6.0 / 10** | **9.5 / 10** | `AuthSignal` is a 547-line God object; UI mixes `StreamBuilder`, `SignalBuilder`, and manual reloads. |
| **Design System & Theming** | **6.5 / 10** | **9.5 / 10** | `custom_button.dart` (522 lines, 7 classes) and `snackbar_utils.dart` use hardcoded hex/Material colors. |
| **Feature Folder Symmetry** | **5.0 / 10** | **9.0 / 10** | 4 different folder layouts across features (`data/presentation`, `views/viewmodels`, `screens/widgets`). |
| **Security & Navigation** | **6.0 / 10** | **9.5 / 10** | Plaintext password passed in `GoRouterState.extra`; router calls `FirebaseAuth.instance` directly. |
| **Testing & Static Analysis** | **2.0 / 10** | **8.5 / 10** | Only 2 test files for 161 source files; `analysis_options.yaml` lacks strict type checks. |

---

## 2. Target Architecture (Before vs. After)

```text
CURRENT (Hybrid / Leaky)                    TARGET (Clean MVVM + Pure DI + Reactive Single Source)
========================                    ======================================================
UI Screen                                   UI Screen (Stateless / SignalBuilder, ≤300 lines)
  ├── StreamBuilder (Hive stream) ❌          └── Watches Computed / Signal only (1 reactive path)
  ├── SignalBuilder (MoodSignal)                     │
  └── Direct Callbacks (handleSignUp) ❌             ▼
         │                                  ViewModel (`XSignal` @singleton, ≤180 lines)
         ▼                                    ├── Pure reactive state (`signal`, `computed`)
God Signal (AuthSignal 547 lines) ❌          └── Calls Repository returning `Result<T>`
  ├── FirebaseAuth / GoogleSignIn SDK                │
  └── MoodRepository                                 ▼
         │                                  Repository (`@singleton` @inject)
         ▼                                    ├── Coordinates Local + Remote + Sync
Static Globals (`HiveService.put`) ❌         └── Zero static calls (100% constructor-injected)
                                                     │
                                             ┌───────┴────────┐
                                             ▼                ▼
                                      LocalDataSource   RemoteDataSource
                                      (Injected Box)    (FirestoreService)
```

---

## 3. Master Refactoring Roadmap (6 Atomic Phases)

| Phase | Branch Name | Focus Area | Risk | Est. Effort |
| :--- | :--- | :--- | :---: | :---: |
| **Phase 1** | `refactor/di-and-local-storage` | Convert static `HiveService` & `AppPreferences` to injected singletons; fix `copyWith` & box name drift | Low | 1–2 hrs |
| **Phase 2** | `refactor/unify-mood-reactivity` | Single reactive source of truth in `MoodSignal` + `computed()` state in `InsightsSignal` | Low | 1 hr |
| **Phase 3** | `refactor/auth-layer-split` | Split 547-line `AuthSignal` into `AuthRepository` + `AuthErrorMapper` + thin `AuthSignal`; remove password from router `extra` | Med | 2–3 hrs |
| **Phase 4** | `refactor/design-system-and-buttons` | Split 522-line `custom_button.dart` into 7 files + replace raw hex/Material colors with `ThemeExtension` tokens | Low | 1.5 hrs |
| **Phase 5** | `refactor/feature-folder-symmetry` | Standardize MVVM folder layout across `auth`, `mood`, `history`, `insights`, `settings`, `onboarding` | Low | 1 hr |
| **Phase 6** | `chore/strict-lints-and-test-suite` | Enable strict analyzer rules + add unit tests for sync/merge, adapters, and signals + sync `firestore.rules.template` | Low | 2 hrs |

---

## Phase 1: Pure Dependency Injection & Data Layer Cleanup

- **Branch:** `refactor/di-and-local-storage`
- **Objective:** Eliminate static service calls (`HiveService.*`, `AppPreferences.*`) so every repository and service is constructor-injected and mockable in unit tests. Fix model and constant bugs.

### Checklist & Exact File Changes
- [x] **1. Fix Hive Box Constant Drift (`lib/core/constant/constants.dart`)**
  - Currently `AppConstants.hiveBoxName` is `'mood_box'` (line 5), while `HiveService.boxName` (`lib/features/mood/data/local/hive_service.dart:11`) opens `'mood_entries'`.
  - Keep `'mood_entries'` as the single constant (to preserve existing user data on disk) and remove legacy `AppConstants.moodColors` / `moodColorsDark` (lines 10–26).
- [x] **2. Fix Nullable `MoodEntry.copyWith` (`lib/features/mood/data/models/mood_entry.dart:51-69`)**
  - Currently `note: note ?? this.note` prevents clearing a `note` or `title` back to `null`.
  - Use a sentinel value (`static const Object _unset = Object();`) for nullable fields (`note`, `id`, `userId`, `title`) so passing `note: null` explicitly clears the field.
- [x] **3. Provide Open Hive Boxes in `InfrastructureModule` (`lib/core/di/infrastructure_module.dart`)**
  - Keep `await HiveService.init()` and `await AppPreferences.init()` in `main.dart` before `initDependencies()`.
  - Add `@provides @singleton Box<MoodEntry> provideMoodBox() => Hive.box<MoodEntry>(HiveService.boxName);`
  - Add `@provides @singleton Box<dynamic> providePreferencesBox() => Hive.box<dynamic>(AppPreferences.boxName);`
- [x] **4. Make `HiveService` & `AppPreferences` Injectable Singletons**
  - Annotate `HiveService` (`lib/features/mood/data/local/hive_service.dart`) with `@singleton` and `@inject HiveService(this._moodBox)`. Convert static methods (`put`, `putAll`, `delete`, `getAllForUser`, `getPendingForUser`, `watchForUser`, `deleteAllForUser`) to instance methods.
  - Annotate `AppPreferences` (`lib/core/services/app_preferences.dart`) with `@singleton` and `@inject AppPreferences(this._box)`. Inject it into `OnboardingRepository` (`lib/features/onboarding/repository/onboarding_repository.dart`) and `ThemeSignal` (`lib/features/settings/presentation/signals/theme_signal.dart`).
  - Inject `HiveService` into `MoodRepository` (`lib/features/mood/data/repositories/mood_repository.dart`) and `SyncService` (`lib/features/mood/data/services/sync_service.dart`).
- [x] **5. Regenerate DI & Verify**
  - Run `dart run build_runner build`
  - Run `flutter analyze` and `flutter test`

---

## Phase 2: Unify Reactive Data Flow (Single Source of Truth)

- **Branch:** `refactor/unify-mood-reactivity`
- **Objective:** Replace mixed `StreamBuilder` + manual `reloadLocalEntries()` + `SignalBuilder` patterns with a single reactive signal pipeline driven automatically by Hive box changes.

### Checklist & Exact File Changes
- [x] **1. Auto-Sync `MoodSignal.entries` with Hive (`lib/features/mood/presentation/signals/mood_signal.dart`)**
  - Subscribe to `_repository.watchEntries(_userId)` inside `MoodSignal` whenever `_authSignal.user` changes (or on local Hive box writes) so `entries.value` updates automatically — even when `SyncService` merges or updates entries in the background.
  - Add a `newestFirst = signal<bool>(true)` and `late final orderedEntries = computed(...)` inside `MoodSignal`.
  - Remove dead/unsafe `streamMoodEntries(String userId)` (`line 78`), which bypassed Hive and read Firestore directly.
- [x] **2. Simplify `HistoryScreen` (`lib/features/history/screens/history_screen.dart`)**
  - Remove `StreamBuilder<List<MoodEntry>>` (`line 44`) and `initState -> reloadLocalEntries()` (`line 28`).
  - Convert `HistoryScreen` to read `appComponent.moodSignal.orderedEntries` via `SignalBuilder` / `Watch`.
- [x] **3. Move Heavy Chart Calculations into `InsightsSignal` (`lib/features/insights/presentation/signals/insights_signal.dart`)**
  - Currently `InsightsScreen.build()` (`lib/features/insights/screens/insights_screen.dart:45-46`) recalculates `MoodSeriesUtils.series()` and `MoodSeriesUtils.weekAverages()` on every widget rebuild.
  - Add `final granularity = signal<MoodGranularity>(MoodGranularity.all);` to `InsightsSignal`.
  - Add `late final seriesPoints = computed(() => MoodSeriesUtils.series(_moodSignal.entries.value, granularity.value));`
  - Add `late final weekAverages = computed(() => MoodSeriesUtils.weekAverages(_moodSignal.entries.value, DateTime.now()));`
  - Convert `InsightsScreen` from `StatefulWidget` to a clean `StatelessWidget`.
- [x] **4. Regenerate DI & Verify**
  - Run `dart run build_runner build`
  - Run `flutter analyze` and `flutter test`

---

## Phase 3: Deconstruct `AuthSignal` (547 Lines) & Harden Router Security

- **Branch:** `refactor/auth-layer-split`
- **Objective:** Break the 547-line `AuthSignal` God-object into a clean Repository + Error Mapper + ViewModel, move hardcoded strings to `AuthStrings`, and stop passing plaintext passwords through `GoRouterState.extra`.

### Checklist & Exact File Changes
- [x] **1. Create `Result<T>` Type (`lib/core/utils/result.dart`)**
  - Create a lightweight sealed class for domain operations:
    ```dart
    sealed class Result<T> {
      const Result();
    }

    final class Ok<T> extends Result<T> {
      const Ok(this.value);
      final T value;
    }

    final class Err<T> extends Result<T> {
      const Err([this.message]);
      final String? message;
    }
    ```
- [x] **2. Extract `AuthErrorMapper` (`lib/features/auth/data/auth_error_mapper.dart`)**
  - Move `_getErrorMessage` and `_getResetErrorMessage` out of `lib/features/auth/presentation/signals/auth_signal.dart:425-458`.
  - Move all remaining hardcoded error strings (`'Password is too weak'`, `'Email is already registered'`, `'Incorrect password'`, etc.) into `lib/core/constant/strings/auth_strings.dart`.
- [x] **3. Extract `AuthRepository` (`lib/features/auth/data/auth_repository.dart`)**
  - Move all direct `FirebaseAuth` and `GoogleSignIn` SDK calls, `kIsWeb` branching, timeouts, and re-authentication helpers (`_hasRecentLogin`, `_reauthenticate`, `_googleCredential`) from `AuthSignal` into `@singleton class AuthRepository`.
  - Expose `AuthRepository` on `AppComponent`.
- [x] **4. Slim Down `AuthSignal` (`lib/features/auth/presentation/signals/auth_signal.dart`)**
  - Keep `AuthSignal` reactive and thin: only signals (`status`, `user`, `errorMessage`), auth stream listener, and methods delegating to `AuthRepository` + `MoodRepository` (547 → 248 lines).
  - Remove imperative callback wrappers (`handleSignIn`, `handleSignUp`, `handleGoogleSignIn` at lines `212, 398, 410`). Screens `await` the action and react after `if (!mounted) return;`.
- [x] **5. Remove Plaintext Password from Navigation (`lib/features/auth/screens/sign_up_screen.dart:68` & `lib/core/router/app_router.dart:65-73`)**
  - Sign-up now keeps the unverified user signed in (the router already blocks unverified users from protected routes), so `verifyEmail` receives `email` only.
  - `VerifyEmailScreen` resends through `currentUser.sendEmailVerification()` and checks status via `checkEmailVerified()`.
- [x] **6. Split `SignUpScreen` Below 300 Lines (`lib/features/auth/screens/sign_up_screen.dart`)**
  - Extracted the form card into `lib/features/auth/widgets/sign_up_form_card.dart` (315 → 188 lines).
- [x] **7. Inject `AuthSignal` into Router (`lib/core/router/app_router.dart:32, 169`)**
  - Replaced direct `FirebaseAuth.instance` calls in `app_router.dart` with `appComponent.authSignal`.
- [x] **8. Regenerate DI & Verify**
  - Run `dart run build_runner build`
  - Run `flutter analyze` and `flutter test`

### Hardening added during implementation
- `AuthSignal` starts background sync only for verified users.
- `firestore.rules` and `firestore.rules.template` gate all collections on `request.auth.token.email_verified`.
- The verify screen offers "Use another account" (signs out the unverified session).
- Splash routes unverified users to the verify screen instead of sign-in.

---

## Phase 4: Design System Cleanup & Widget Decomposition

- **Branch:** `refactor/design-system-and-buttons`
- **Objective:** Enforce the **1 widget per file** and **≤ 300 lines per UI file** rules on `custom_button.dart` (522 lines) and eliminate all raw hex/Material colors in widgets and utilities.

### Checklist & Exact File Changes
- [x] **1. Split `lib/core/widgets/custom_button.dart` (522 lines) into 7 Dedicated Files**
  - `lib/core/widgets/buttons/app_button.dart` (`AppButton`, `AppButtonVariant`, `AppButtonSize`)
  - `lib/core/widgets/buttons/app_date_picker_button.dart` (`AppDatePickerButton`)
  - `lib/core/widgets/buttons/app_checkbox_button.dart` (`AppCheckboxButton`)
  - `lib/core/widgets/buttons/app_tab_button.dart` (`AppTabButton`)
  - `lib/core/widgets/buttons/app_icon_button.dart` (`AppIconButton`, `AppIconButtonSize`)
  - `lib/core/widgets/buttons/app_toggle_button.dart` (`AppToggleButton`)
  - `lib/core/widgets/buttons/app_pill_button.dart` (`AppPillButton`)
  - Kept `lib/core/widgets/custom_button.dart` as a 12-line barrel re-export.
- [x] **2. Replace Hardcoded Colors in Buttons with `ThemeExtension` Tokens**
  - Added `ButtonColors` (`lib/core/theme/extensions/button_colors.dart`, light + dark) and registered it in `context_extensions.dart`, `light_theme.dart` and `dark_theme.dart`.
  - All raw hex values (`#402B20`, `#2C221D`, `#F5EFEB`, `#38302B`, `#EAE2DA`, …) moved out of the widgets into the extension.
- [x] **3. Theme-Aware `SnackBarUtils` & `DialogUtils`**
  - `snackbar_utils.dart` now uses `context.status.error/success/info`.
  - `dialog_utils.dart` danger action uses `context.status.error`.
- [x] **4. Remove Deprecated Theme Statics (`lib/core/theme/app_theme.dart:20-27`)**
  - Removed unused `@Deprecated` statics; `nav_bar_item.dart` now reads `colorScheme`.
- [x] **5. Verify in Both Light & Dark Themes**
  - Run `flutter analyze` and `flutter test`

---

## Phase 5: Feature Folder Symmetry (Standardizing MVVM Layout)

- **Branch:** `refactor/feature-folder-symmetry`
- **Objective:** Align all features under `lib/features/` to follow the same predictable layout defined in `AGENTS.md §5.2` so developers never have to guess where a file lives.

### Target Layout Per Feature
```text
lib/features/<feature>/
├── models/          # Plain data models & route args
├── datasource/      # Local (Hive) and Remote (Firestore / Auth SDK) wrappers
├── repository/      # Business logic & offline/online coordination
├── viewmodels/      # @singleton XSignal classes (<name>_signal.dart)
└── views/           # Screen widgets + widgets/ subfolder
    └── widgets/
```

### Checklist & Exact File Moves (`git mv`)
- [ ] **1. `lib/features/auth/`**
  - `data/` → `datasource/` & `repository/`
  - `presentation/signals/auth_signal.dart` → `viewmodels/auth_signal.dart`
  - `screens/` → `views/`
  - `widgets/` → `views/widgets/`
- [ ] **2. `lib/features/history/`**
  - `screens/` → `views/`
  - `widgets/` → `views/widgets/`
- [ ] **3. `lib/features/insights/`**
  - `presentation/signals/insights_signal.dart` → `viewmodels/insights_signal.dart`
  - `screens/` → `views/`
  - `widgets/` → `views/widgets/`
- [ ] **4. `lib/features/settings/`**
  - `presentation/signals/theme_signal.dart` → `viewmodels/theme_signal.dart`
  - `screens/` → `views/`
  - `widgets/` → `views/widgets/`
- [ ] **5. `lib/features/mood/`**
  - `data/models/` + `presentation/models/` → `models/`
  - `data/local/` + `data/remote/` → `datasource/`
  - `data/repositories/` → `repository/`
  - `data/services/` → `services/`
  - `presentation/signals/` → `viewmodels/`
  - `presentation/screens/` → `views/`
  - `presentation/widgets/` → `views/widgets/`
- [ ] **6. Regenerate DI & Verify**
  - Run `dart run build_runner build`
  - Run `flutter analyze` and `flutter test`

---

## Phase 6: Engineering Guardrails — Strict Lints, Rules Sync & Test Suite

- **Branch:** `chore/strict-lints-and-test-suite`
- **Objective:** Lock in architectural quality with compile-time strictness and automated tests covering critical offline-first invariants.

### Checklist & Exact File Changes
- [ ] **1. Harden `analysis_options.yaml`**
  ```yaml
  include: package:flutter_lints/flutter.yaml

  analyzer:
    exclude:
      - build/**
      - android/**
      - ios/**
      - "**/*.inject.dart"
    language:
      strict-casts: true
      strict-inference: true
      strict-raw-types: true

  linter:
    rules:
      - always_declare_return_types
      - prefer_final_locals
      - unawaited_futures
      - avoid_print
      - use_build_context_synchronously
  ```
- [ ] **2. Sync `firestore.rules.template` with `firestore.rules`**
  - `firestore.rules` (142 lines) has strict schema validation (`hasOnly`, `isValidMood`, note length `<= 1000`, immutable `userId`/`createdAt`), whereas `firestore.rules.template` (58 lines) is outdated. Copy the hardened rules into `firestore.rules.template`.
- [ ] **3. Add High-ROI Unit Tests (`test/`)**
  - `test/features/mood/mood_entry_test.dart`:
    - Verify `copyWith(note: null)` clears nullable fields.
    - Verify `MoodEntryAdapter` clamps out-of-range mood levels (`-1 -> 0`, `99 -> 5`) and handles missing binary fields gracefully.
  - `test/features/mood/mood_repository_sync_test.dart`:
    - Verify `fetchAndSyncFromFirebase` keeps unsynced local entries (`id == null`).
    - Verify remote deletions remove only synced entries of that `userId` and never touch another user's entries.
    - Verify network failure falls back to local Hive data without wiping the box.
  - `test/features/insights/mood_series_utils_test.dart`:
    - Verify `MoodSeriesUtils.series()` and `weekAverages()` across empty lists, single entries, and multiple entries on the same day.
- [ ] **4. Final Verification Gate**
  - Run `flutter analyze` (0 issues)
  - Run `flutter test` (all tests green)

---

## 4. How to Run Each Phase (Execution Protocol)

When starting any phase from this document, follow [`WORKFLOW.md`](WORKFLOW.md):

1. Check clean git state:
   ```bash
   git status
   git checkout main && git pull origin main
   ```
2. Create the phase branch:
   ```bash
   git checkout -b <phase-branch-name>
   ```
3. Implement only the checklist items for that phase.
4. Regenerate DI if any `@singleton` / `@inject` / `@module` changed:
   ```bash
   dart run build_runner build
   ```
5. Run verification gate:
   ```bash
   flutter analyze
   flutter test
   ```
6. Run `dailypulse_pr_reviewer` before committing, then commit with Conventional Commits (`refactor(mood): ...`, `refactor(auth): ...`).
