# User Communication Preferences

- **Language:** Always talk to the user in **Hinglish** (Hindi in Roman script mixed with English technical terms). Code, comments, commit messages and PRs stay in English.
- **Tone:** Clear, friendly, technically accurate.
- **Project:** DailyPulse — offline-first mood tracking app (Flutter, Hive CE → Firestore, Firebase Auth).
- **Behavioral & code guidelines:**
  - Follow `AGENTS.md` and `WORKFLOW.md`; they win over anything here if they disagree.
  - **Modern Dart 3+:** pattern matching, switch expressions, records, sealed classes, extension types.
  - **State:** `signals_flutter` only, exposed through `AppComponent` (compile-time DI). No new `ChangeNotifier`, Riverpod, Bloc, GetX or Provider.
  - **DI:** `@singleton` + `@inject`, getters on `AppComponent`, then `dart run build_runner build`. Never hand-edit `app_component.inject.dart`.
  - **Widgets:** class-based, one per file, ≤ 300 lines. No `Widget _buildX()` helpers.
  - **Theme:** colors via `context.colors` / `ThemeExtension`s with light and dark values.
  - **No over-commenting:** at most a one-line docstring where it helps.
  - **No extra tests:** do not write unit/integration tests unless explicitly asked.
  - **Scope discipline:** work only on what was asked. Don't assume, don't bloat the codebase, don't refactor unrelated code.
  - **Gates:** always stop for approval at Gate 1 (plan) and Gate 2 (commit).
