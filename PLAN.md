# DailyPulse — Product Plan

> Source of truth for *what we are building and in what order*. Engineering rules live in [`AGENTS.md`](AGENTS.md); delivery process in [`WORKFLOW.md`](WORKFLOW.md).

## 1. Vision

A calm mood-tracking app. Log how you feel, see your patterns, and (after launch) let up to 4 people you trust see a small garden of plants that reflects each member's mood.

- **Principle:** fewer features, but safe and correct.
- **Market:** worldwide.
- **Platform:** Android only (Google Play) for now.
- **Minimum age:** 16+.
- **Languages:** English first; keep strings localization-ready.

## 2. Architecture (decided)

- **Backend:** Firebase (Auth + Firestore). Project `dailyplus-mobile-app`, Firestore in `asia-south1` (kept as is).
- **Local DB (Hive):** offline cache and pending-sync queue only.
- **Pattern:** MVVM. ViewModel = `signals_flutter` `XSignal`, data via Repository, DI via `AppComponent`.
- **Plan:** stay on Firebase Spark (free). Nothing in scope needs Cloud Functions or push.

## 3. Scope

### Phase 1 — Play Store launch

| # | Feature |
|---|---|
| 1 | Fast mood logging: multiple times per day, back-fill past days |
| 2 | Tags ("What happened?"): sleep, work, family, friends, exercise, loneliness, health |
| 3 | History and calendar view |
| 4 | Insights: best/worst day, time of day, tag-to-mood link |
| 5 | Daily reminder (local notification) |
| 6 | Privacy: consent, account delete, data export, disclaimer |
| 7 | "Need help?" link in Settings (static, optional) |

### Phase 2 — after launch

| # | Feature |
|---|---|
| 8 | Trusted Circle: one group, max 5 members (you + 4) |
| 9 | Garden: one plant per member (max 5), shows the owner's mood as weather |
| 10 | Cheers: pre-set kind messages (no free text) |

Circle, Garden and Cheers ship together; without the garden, a circle has nothing to show.

### Not planned

AI of any kind, public community feed, goals/points/leaderboards, streak guilt, free-text chat, diagnosis-style scores.

## 4. Build order

| Step | Work | Phase |
|---|---|---|
| 0 | Fix data-loss in History sync (`HiveService.clear()` wipes unsynced entries); fix Firestore rule mood range (app uses 0–5, rules reject 0) | 1 |
| 1 | Tracking: fast log, tags, calendar, insights, reminder | 1 |
| 2 | Privacy: consent, delete/export, disclaimer, "Need help?" link | 1 |
| 3 | Production release: remaining items in §6, then promote to production | 1 |
| 4 | Trusted Circle + Cheers | 2 |
| 5 | Garden and plants | 2 |

## Start here (next session)

**Step 0 — fix before building anything new.**

1. `lib/features/mood/data/repositories/mood_repository.dart` — `fetchAndSyncFromFirebase` calls `HiveService.clear()` and replaces local data with the Firestore snapshot. This drops unsynced entries (`id == null`), and `FirestoreService.fetchMoodEntries` returns `[]` on error, which can wipe everything. Merge instead of clear: keep pending entries, and never replace local data when the fetch failed.
2. `firestore.rules` — mood range must be `0..5` (app uses a zero-based `level`). The local file says `1..6` and the deployed rules say `1..5`, so "Frustrated" (0) never syncs.
3. Do not deploy rules until the owner asks.
4. Verify with `flutter analyze` and `flutter test`.

Open question for the owner: is any version already live on production, or is this the first release? (Affects Hive migration care.)

## 5. Safety rules (apply to every step)

- Nothing is shared by default. Sharing is opt-in and can be revoked at any time.
- No automatic alerts to other people.
- Plants show weather, not "good/bad"; a plant never dies. Show a note: "Rain doesn't mean an emergency."
- Only the derived weather state is shared, never the raw mood or note.
- No medical claims. The app is not medical advice or an emergency service.
- Collect the minimum data; never log notes, emails or tokens at `info` or above.
- Firestore rules are never weakened; nothing is deployed without explicit approval.

## 6. Play Store launch checklist

Already done on the Play Console side (closed testing passed, privacy policy URL and store setup added):

- [x] Privacy policy URL
- [x] Closed testing requirement
- [x] Store listing and related Play Console setup

Still to do before pushing to production:

- [ ] In-app account deletion (and a web URL for deletion requests, if the Play Console asks for one)
- [ ] Re-check that the Data Safety form still matches what Phase 1 collects (tags, reminders)
- [ ] Release signing key; release SHA-1 added to Firebase (Google Sign-in)
- [ ] Bump version in `pubspec.yaml` and build the release bundle (`flutter build appbundle --release`)

## 7. Technical notes and risks

- Hive schema: new fields (e.g. tags) get a new index (6+) and must read `null` from old data. Never renumber or reuse indexes.
- Firestore rules use `hasOnly([...])`; every new field needs a rules update.
- Reminders need a new package (`flutter_local_notifications`); confirm with the owner before adding.
- Check that History and Insights handle several entries per day.
- Phase 2 rules: only group members read the group's plants; each member writes only their own plant; nobody reads another user's `moods`.
- Region stays `asia-south1`. Revisit only if latency or user data-residency demands appear.

## 8. Decisions log

| Decision | Choice |
|---|---|
| AI features | None |
| Crisis help | Removed; only an optional "Need help?" link |
| Weekly goals / points | Removed |
| Circle size | One group, max 5 (you + 4) |
| Plant | Weather metaphor, one per member, post-launch |
| Cheers | Kept (post-launch, with Circle) |
| Firestore region | Stay on `asia-south1` |
| Platform | Android only |
