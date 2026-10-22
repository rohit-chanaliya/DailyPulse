# GEMINI.md — DailyPulse (Agent Entry Point)

> **Single source of truth:** [`AGENTS.md`](AGENTS.md) is the authoritative guide for the stack, folder layout, conventions and guardrails. This file only gives Gemini CLI (and other agents) a stable entry point. **Always defer to `AGENTS.md` and [`WORKFLOW.md`](WORKFLOW.md) if anything here disagrees.**

---

## Quick Reference

| Area | Rule |
|---|---|
| **App** | Offline-first mood tracker. Flutter + Dart 3, Firebase Auth, Hive CE → Firestore sync |
| **State** | `signals_flutter` (`signal()`, `computed()`, `Watch`). No new `ChangeNotifier`; no Riverpod/Bloc/GetX/Provider |
| **Routing** | `go_router`; paths in `AppRoutes`, routes in `createAppRouter()` |
| **Widgets** | Class-based only, one per file, ≤ 300 lines. No `Widget _buildX()` helpers |
| **Theme** | Light **and** dark. Colors via `context.colors` / `ThemeExtension`s. No raw `Color(0x…)` in widgets |
| **Strings** | New copy in `core/constant/strings/<feature>_strings.dart` |
| **Data** | Write to Hive first, sync to Firestore in background. Every doc has `userId`. Never touch `MoodEntryAdapter` field indexes |
| **Logging** | `appLogger`, never `print()` |
| **Never** | commit `.env` / `firebase_options.dart`, destructive git, data wipes, unrequested tests |
| **Verify** | `flutter analyze` (0 issues) + `flutter test` |

## Delivery Process (Gate Summary)

1. Clean tree → sync `main` → branch: `feature/<name>` · `bugfix/<name>` · `chore/<name>`.
2. **Plan first → ⛔ Gate 1:** wait for explicit approval before writing code.
3. Build in modular phases (A: data layer, B: assets, C: UI & state — skip what doesn't apply).
4. Review (`dailypulse_pr_reviewer`, `flutter analyze`, `flutter test`) → ⛔ **Gate 2:** wait for commit approval.
5. Commit (Conventional Commits) → push → PR only when asked.

## Communication

Reply to the user in **Hinglish**. Code, comments, commits and PRs stay in English. See `.gemini/skills/user_preferences.md`.
