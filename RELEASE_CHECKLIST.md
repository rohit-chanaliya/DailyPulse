# DailyPulse — Release Checklist

> Last updated: 9 November 2026
> Branch: `chore/release-review`
> App: `com.scanflowstudio.dailypulse`
> Firebase project: `dailyplus-mobile-app`

## Hard dates

| Date | What |
|---|---|
| 9 Nov 2026 | Code review and release fixes (this branch) |
| **11 Nov 2026, 2:59 PM IST** | New upload key becomes valid; only then can an AAB be uploaded |
| 20 Nov 2026 | Target: AAB on Play testing track, all console forms done |
| 10 Dec 2026 | Target: production release live (buffer before the deadline) |
| **16 Dec 2026** | Google's deadline: developer account closes if the app is not published |

---

## Developer tasks (Rohit)

### Must do before upload
- [ ] Review and merge `chore/release-review` PR
- [ ] Test the release build on a physical device (list below)
- [x] Add **App signing key** fingerprints in Firebase Console → Project settings → Your apps → Android → Add fingerprint:
  - SHA-1: `06:A5:A6:85:53:B8:1B:8C:31:5F:4A:2C:C5:BC:5A:24:91:E6:6D:00`
  - SHA-256: `B4:95:9E:61:9B:4D:AC:7A:A4:6B:D2:94:28:68:FA:59:3D:E1:38:95:C6:C4:E0:FE:90:AA:E7:E8:7A:04:EE:63`
- [x] Deploy Firestore indexes: `firebase deploy --only firestore:indexes`
- [x] Deploy hosting (after the PR merges): `firebase deploy --only hosting`
- [ ] Check the biggest version code used in Play Console → Test and release → App bundle explorer. Currently set to **10** in `pubspec.yaml` (`1.0.2+10`).

### Play Console → App content (all required)
- [x] Trader status declared (non-trader)
- [ ] Data safety form
  - App info and performance → **Crash logs**: collected, not shared, required, purpose Analytics
  - App info and performance → **Diagnostics**: collected, not shared, required, purpose Analytics
  - **Device or other IDs**: collected, not shared, required, purpose Analytics
  - Personal info → Name, Email, User IDs (required)
  - Personal info → Other info (gender, DOB, location) — optional
  - Health and fitness → Health info (mood levels) — optional
  - App activity → Other user-generated content (notes, titles, tags, feedback) — optional
  - Encrypted in transit: Yes; Data deletion link: `https://dailyplus-mobile-app.web.app/delete-account`
- [ ] Health apps declaration
- [ ] Target audience (the privacy policy says 16+; the app has no age check — keep them aligned)
- [ ] Content rating questionnaire
- [ ] App access: give a verified test account (email + password) for the reviewer
- [ ] Ads: No

### Play Console → Store listing
- [ ] App name, short description (80 chars), full description
- [ ] App icon 512×512
- [ ] Feature graphic 1024×500
- [ ] At least 2 phone screenshots
- [ ] Privacy policy URL: `https://dailyplus-mobile-app.web.app/privacy`

### Upload and release
- [ ] On/after 11 Nov 2:59 PM: upload `build/app/outputs/bundle/release/app-release.aab`
  (build it with `flutter build appbundle --release`)
- [ ] Upload to internal/closed testing first, install from Play, and re-test login
- [ ] Promote to production → Send for review
- [ ] Watch the Play pre-launch report and Crashlytics for 48 hours after release

### Physical device test (release build)
- [ ] Email sign-up, verification link, sign-in
- [ ] Google Sign-In (needs the fingerprints added above)
- [ ] Forgot password / reset link
- [ ] Log a mood, add a journal entry, check History and Insights
- [ ] Airplane mode: log an entry, go online, confirm sync
- [ ] Daily reminder fires at the local time
- [ ] Profile: save DOB/location/gender, upload a photo, pick a preset
- [ ] Feedback submit (check the document appears in Firestore)
- [ ] Delete account; confirm local data is gone and the web deletion page works
- [ ] One test crash on a release build, then confirm it shows in Crashlytics
- [ ] Rotate the device (app should stay portrait), press back, open the app offline
- [ ] Install on a small and a large screen once

---

## Agent tasks (done in this branch)

### Fixed in code
- [x] Cancel the daily reminder on sign out
- [x] Delete local traces on account deletion: queued feedback (same user only), avatar file, saved path
- [x] `allowBackup=false` plus `dataExtractionRules` so mood notes never leave via backup
- [x] Portrait lock
- [x] Dark splash (`#161210`), regenerated with `flutter_native_splash`
- [x] `firestore.indexes.json` for `moods` (`userId` ASC, `timestamp` DESC) and wired into `firebase.json`
- [x] `release.bat` builds an AAB; `release_apk.bat` builds a test APK
- [x] Version `1.0.2+10`, Settings version string updated
- [x] Removed 41 unused asset constants and files (assets 4.5 MB → 3.6 MB)
- [x] Removed 5 unused widgets and 30 unused strings
- [x] Bundled the Urbanist font files under `assets/google_fonts/` and disabled runtime fetching
- [x] Added `HiveBootstrap` with corrupt-box quarantine, safe `AppPreferences` readers and `StartupErrorApp` fallback
- [x] Dark `NormalTheme` window background (`#161210`) across all Android style configs (no white flash)
- [x] Added upload-key SHA-256 to `assetlinks.json`, monochrome `ic_notification` vector, awaited `GoogleSignIn.initialize()`, deleted replaced avatar files, capped and batched `pending_feedback`, shortened splash to ~3 s
- [x] Regression checks: `flutter analyze` 0 issues, `flutter test` 26 passed, release AAB builds and is signed

### Known, intentionally not changed
- [ ] Dark-only theme for the `1.0.x` line; light mode is deferred to a later release.
- [ ] `pending_feedback` TTL pruning is deferred to `1.0.3` (queue is capped at 50 entries and wiped on account deletion).
- [ ] `history_calendar_strip.dart` is 321 lines (guideline is 300). Pre-existing; split it when that file is next touched.
- [ ] Password minimum stays at 6 characters unless requested.
- [ ] No crash-reporting opt-out toggle, so Data safety lists crash data as "required".

---

## Commands

```bash
# Test build for a physical device (signed with the upload key)
flutter build apk --release

# Play Store upload build
flutter build appbundle --release

# Deploy backend config
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
firebase deploy --only hosting
```

## Fingerprints (public, safe to share)

| Key | SHA-1 | Used for |
|---|---|---|
| Upload key (local keystore) | `DD:42:26:B7:45:2F:64:CE:AF:94:FE:E1:C2:F8:8C:61:13:D1:E0:F9` | Signing the AAB we upload |
| Play App Signing key | `06:A5:A6:85:53:B8:1B:8C:31:5F:4A:2C:C5:BC:5A:24:91:E6:6D:00` | Signing the build users install; used in Firebase and `assetlinks.json` |

Play App Signing SHA-256: `B4:95:9E:61:9B:4D:AC:7A:A4:6B:D2:94:28:68:FA:59:3D:E1:38:95:C6:C4:E0:FE:90:AA:E7:E8:7A:04:EE:63`

Local keystore: `~/dailypulse-upload.jks` (password is only in `android/key.properties`, which is git-ignored).
Keep an offline backup of the keystore and the password.
