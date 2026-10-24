# DailyPulse Development & Engineering Workflow

> **Operating procedure for every task in DailyPulse.** Follow the steps in order. Architecture rules and guardrails are in [`AGENTS.md`](AGENTS.md) / [`GEMINI.md`](GEMINI.md).

---

## 1. Start from a fresh `main`
1. Check the working tree:
   ```bash
   git status
   ```
   **If it is not clean: STOP and ask the user** what to do with the uncommitted changes (commit them on their current branch, carry them over, or leave them). Never stash, discard or reset without explicit instruction.
2. Once clean, sync `main`:
   ```bash
   git checkout main && git pull origin main
   ```

---

## 2. Create a branch
Never write code or commit directly on `main`.

| Type | Pattern | Example |
|---|---|---|
| Feature | `feature/<short-name>` | `feature/mood-streaks` |
| Bug fix | `bugfix/<short-name>` | `bugfix/history-date-offset` |
| Refactor | `refactor/<short-name>` | `refactor/split-home-mood-screen` |
| Chore | `chore/<short-name>` | `chore/update-readme` |

---

## 3. Plan before code
- **New feature or refactor** — write a plan in chat before touching code. It must list:
  - Goal and affected screens/features (mood, history, insights, settings, auth, onboarding).
  - Data layer changes: Hive model/adapter fields, Firestore fields/collections and rules, sync impact.
  - State: new/changed `XSignal` classes and signals.
  - UI: new widget files (class-based, ≤ 300 lines each), routes in `AppRoutes`, strings file, theme tokens (light **and** dark values).
  - Assets needed (SVG/PNG) and `pubspec.yaml` registration.
  - Subagents involved.
  - ⚠️ **GATE 1: STOP and wait for explicit approval ("start coding" / "proceed").**
- **Small bug fix** — explain root cause, files affected and the fix in 2–4 lines, then ⚠️ wait for the user's go-ahead.

---

## 4. Build
Phases are modular. **Skip any phase that doesn't apply** (e.g. a pure UI polish skips Phase A).

### Phase A — Data layer (if applicable)
- **Specialist:** `dailypulse_frontend_builder`.
- Models/adapters: only additive Hive changes (new field index, null-tolerant reads). Never renumber or remove fields.
- Writes: Hive first, then `SyncService`. Firestore only via `FirestoreService`, always with `userId`.
- Services and repositories are `@singleton` + `@inject`; third-party objects come from `@module` classes. Run `dart run build_runner build` after binding changes.
- Update `firestore.rules.template` for any new collection; remind the user to publish the rules (never deploy yourself).
- Offline, empty and error states handled and logged via `appLogger`.

### Phase B — Visual assets (if applicable)
- **Specialist:** `dailypulse_asset_generator`.
- SVG/PNG under `assets/` (matching subfolder), registered under `flutter: assets:` in `pubspec.yaml`, then `flutter pub get`.
- Assets must look right in both light and dark themes.

### Phase C — UI & state
- **Specialist:** `dailypulse_frontend_builder`.
- Signal in `viewmodels/` (or the feature's existing signals folder), registered as `@singleton` + `@inject` with a getter on `AppComponent`; widgets as separate classes in separate files; route + `AppRoutes` constant; strings in `core/constant/strings/`.
- After changing DI annotations, run `dart run build_runner build` and commit the regenerated `app_component.inject.dart`.
- Colors only via `context.colors` / `ThemeExtension`s; add tokens for both themes.
- Shared helpers in `core/utils/`.
- Check the screen in **light and dark** and with an empty / offline state.

---

## 5. Review & auto-fix
Before staging anything, invoke **`dailypulse_pr_reviewer`**:

1. **Architecture & style audit/auto-fix:** class-based widgets, ≤ 300 lines, signals via `AppComponent`, compile-time DI bindings regenerated, theme tokens, strings, `AppRoutes`, offline-first rules, no `print()`.
2. **Verification:**
   ```bash
   flutter analyze   # must report 0 issues
   flutter test      # must pass
   ```
3. **Optional read-only audit:** `code-reviewer` for correctness, data safety and security against `main`.
4. **Gate 2 — PR-readiness scorecard** with verdict `[READY TO MERGE]` or `[CHANGES REQUIRED]`.
   ⚠️ **STOP: wait for explicit commit approval.**

---

## 6. Commit and PR
1. **Commit** only after Gate 2 approval, English, Conventional Commits:
   ```bash
   git commit -m "feat(mood): add weekly streak card"
   ```
   Scopes: `mood`, `history`, `insights`, `settings`, `auth`, `onboarding`, `theme`, `router`, `sync`, `core`, `assets`, `deps`.
2. **Push & PR:** `git push -u origin <branch>`; invoke **`pr-describer`** for title and body. Open the PR against `main` **only when the user asks**.
3. **After merge:**
   ```bash
   git checkout main
   git pull origin main
   git branch -d <branch-name>
   ```
