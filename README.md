# ZenShield VPN

A Flutter VPN app (Android + iOS + Windows + macOS) built on [sing-box](https://github.com/SagerNet/sing-box).

## 1. Prerequisites

Install these before anything else:

| Tool | Needed for |
|---|---|
| [Flutter SDK 3.35.6](https://docs.flutter.dev/release/archive) (stable) | Everything — newer versions may cause build errors |
| Go 1.24+ | Building native binaries (all platforms) |
| `gomobile`/`gobind` from `github.com/sagernet/gomobile@v0.1.8` (not vanilla `golang.org/x/mobile`) | Building the Android/iOS/macOS native binaries — see §6 for why the fork matters |
| Android SDK + NDK | Building the Android native binary |
| mingw-w64 (`x86_64-w64-mingw32-gcc`) | Building the Windows native binary from Linux/macOS |
| Visual Studio (Desktop C++ workload) | Building/running the Windows app itself |
| Xcode | Building the iOS/macOS native binaries — macOS host only, can't cross-compile |

Run `flutter doctor` after installing to confirm your setup.

## 2. Get the app running (no keys needed for this part)

```bash
# 1. Clone
git clone <this-repo-url>
cd zenshield-vpn-app

# 2. Install Flutter dependencies
flutter pub get

# 3. Build the native tunnel binaries for iOS/macOS — required, not optional
#    (Xcode builds fail without them). One-time step; re-run only when you
#    want to update the tunnel core.
ios/fetch_native.sh                  # for iOS
macos/fetch_native.sh                # for macOS

# Android/Windows build these automatically the first time you build/run
# (Gradle/CMake hook — see §6), no manual step needed. Both skip the
# clone+build on every later run once the binary already exists.

# 4. Run it
flutter run -d android   # or: flutter run -d ios / flutter run -d windows / flutter run -d macos
```

At this point the app **builds, runs, and connects the VPN tunnel** with no
further setup. Firebase ships with safe placeholder config (see §4), and
every key in §3 is optional — omitting all of them just turns off a few
secondary features (see the table), nothing crashes.

## 3. Optional: add your own keys

None of these are required to build or run the app, or to connect the VPN.
Add only the ones for features you want.

| Key | Enables | Without it |
|---|---|---|
| `GEONODE_API_KEY` | Bandwidth-sharing SDK (proprietary, fetched from pub.dev) | Feature off |
| `GEONODE_APP_ID_ANDROID` | ^ same feature, Android | Feature off |
| `GEONODE_SDK_API_KEY_WINDOWS` | ^ same feature, Windows | Feature off |
| `GEONODE_SDK_API_KEY_MACOS` | ^ same feature, macOS | Feature off |
| `AMBILYTICS_MEASUREMENT_ID` | Which GA4 property Windows analytics reports to (defaults to the original project's — see §5) | Uses the default |
| `AMBILYTICS_API_SECRET` | Windows analytics ping (see §5 to get your own) | Skipped |
| `GEONODE_TCP_AUTH_SECRET` | Auth password for a debug curl command the SDK logs (proxy diagnostics) | Debug log just shows an empty password field — harmless |

### How to add them — step by step

1. Get the real values from whoever owns them (not in this repo — that's the
   point).
2. Create a file at the repo root, e.g. `secrets.json` (already gitignored,
   so it's never committed):
   ```json
   {
     "GEONODE_API_KEY": "...",
     "GEONODE_APP_ID_ANDROID": "...",
     "GEONODE_SDK_API_KEY_WINDOWS": "...",
     "GEONODE_SDK_API_KEY_MACOS": "...",
     "AMBILYTICS_API_SECRET": "...",
     "GEONODE_TCP_AUTH_SECRET": "..."
   }
   ```
   Only include the keys you actually have — you don't need all of them.
3. Build/run with that file instead of typing each flag by hand:
   ```bash
   flutter run -d android --dart-define-from-file=secrets.json
   flutter build apk --release --dart-define-from-file=secrets.json
   flutter build windows --release --dart-define-from-file=secrets.json
   flutter build macos --release --dart-define-from-file=secrets.json
   ```
4. **Windows installer packaging only** (a separate step, not a `--dart-define`):
   open `windows/packaging/exe/make_config.yaml` and replace
   `code_sign_cert_thumbprint` with your real value locally before running
   `fastforge` (don't commit the real value back).

### To remove/rotate a key later

Delete its line from `secrets.json` (or the whole file) and rebuild — every
key above degrades gracefully to "feature off," so nothing breaks.

### The Geonode SDK keys specifically: two ways to supply them

The four `GEONODE_*`/`GEONODE_SDK_API_KEY_*` keys (bandwidth-sharing SDK) can
be supplied in two different ways, depending on who's doing it:

**Way 1 — set it before building (developer).** Either of these two methods
works, pick whichever's more convenient — both just fill in the same value:

- `--dart-define`/`secrets.json`, as described above, **or**
- hardcode it directly in `lib/config/constants/common_constants.dart`, where
  each key is declared like this:
  ```dart
  static const String geonodeApiKey = String.fromEnvironment(
    'GEONODE_API_KEY',        // a flag name — don't put your key here
    defaultValue: '',         // ← paste your real key here instead
  );
  ```
  Replace the empty `defaultValue: ''` with your real key and rebuild — no
  `--dart-define` needed.

**Way 2 — enter it at runtime, in the app itself (end user).** If bandwidth
sharing is turned on but no key was supplied at build time (neither method
in Way 1), the app shows its own **Geonode SDK Setup** screen after login,
with two fields to paste the key/app ID into directly — no rebuild required.
This is what an ordinary end user, not a developer, sees and uses.

## 4. Optional: Firebase setup (crash reporting)

This repo ships **placeholder** `android/app/google-services.json`,
`ios/Runner/GoogleService-Info.plist`, `macos/Runner/GoogleService-Info.plist`,
and `lib/firebase_options.dart` so the app works with zero Firebase setup on
any platform — app runs normally, Crashlytics crash reporting is just
silently disabled.
`lib/main.dart`'s `_setupFirebase()` detects the placeholder config failing
to initialize and skips every Crashlytics call afterward instead of
throwing — a missing/invalid Firebase setup can never crash the app.

**Important — these files must always be updated together, never by hand:**
`lib/main.dart` calls `Firebase.initializeApp(options:
DefaultFirebaseOptions.currentPlatform)`, i.e. it always uses the explicit
values from `lib/firebase_options.dart` — it does **not** fall back to
reading `google-services.json`/`GoogleService-Info.plist` natively (that
native-auto-config approach doesn't work here anyway since this app also
targets Web, which has no such file to read from). So editing only
`google-services.json` (or only the `.plist`) and leaving
`firebase_options.dart` as the placeholder will not enable Firebase — it'll
still silently no-op. Always use `flutterfire configure` (below), which
regenerates every platform's file together, consistently, from one real
project. Don't hand-edit any of them.

**Step by step, to set up your own project and enable real crash reporting:**

1. Go to https://console.firebase.google.com and sign in with any Google
   account.
2. Click **Add project** → give it any name → when asked, **turn on Google
   Analytics for this project** (leave it on — this also creates the GA4
   property §5 uses for Windows analytics) → **Create project**.
3. Install the FlutterFire CLI (one-time): `dart pub global activate flutterfire_cli`.
4. From the repo root, run:
   ```bash
   flutterfire configure
   ```
   Pick the Firebase project you just created, then select **android, ios,
   and macos** when it asks which platforms to configure. This automatically
   writes a real `lib/firebase_options.dart` and downloads a real
   `android/app/google-services.json` + `ios/Runner/GoogleService-Info.plist`
   + `macos/Runner/GoogleService-Info.plist` — you don't need to touch any of
   these files by hand.
5. Rebuild: `flutter run -d android` (or `-d ios` / `-d macos`). Crashes now show up in
   Firebase Console → Crashlytics.

**Optional follow-up — Google Sign-In under your own project:** in Firebase
Console go to **Authentication → Sign-in method → Google → Enable**. This
creates OAuth client IDs under the hood (visible in Google Cloud Console →
APIs & Services → Credentials). Copy the "Web client" ID into
`googleSignInServerClientId` and the Android client into
`googleSignInAndroidClientId` in `lib/config/constants/common_constants.dart`
if you want Google Sign-In to authenticate against your own project instead
of the original one.

Google Sign-In on Android also checks the app's signing certificate, not just
the client ID — so you additionally need to register your keystore's SHA-1
fingerprint against the Android app in **Firebase Console → Project settings
→ Your apps → (Android app) → Add fingerprint**. Debug and release builds
sign with different certificates, so add both if you test both:

```bash
# Debug keystore (used by `flutter run` / debug builds):
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android | grep SHA1

# Release keystore (path/alias/password from android/key.properties):
keytool -list -v -keystore <your-release-keystore>.jks -alias <your-key-alias>
```

Without the matching SHA-1 registered, Google Sign-In fails (typically a
`DEVELOPER_ERROR` / `ApiException: 10`) even with a correct client ID —
re-run `flutterfire configure` after adding a fingerprint if it doesn't pick
up automatically.

If you're contributing back upstream, don't commit your own real
`google-services.json` / `firebase_options.dart` — keep those local to your
fork/build machine.

## 5. Optional: Windows analytics setup (`ambilytics` / GA4 Measurement Protocol)

Windows has no official Firebase SDK, so this app reports basic usage
analytics on Windows via Google Analytics 4's **Measurement Protocol**
instead — a plain HTTP request, no SDK needed (see `lib/main.dart`'s
`_setupFirebase()`, Windows branch). It needs two values: which GA4
property to send to (`AMBILYTICS_MEASUREMENT_ID`), and a secret proving
you're allowed to write to it (`AMBILYTICS_API_SECRET`). Skip this
entirely and it's silently disabled — nothing breaks.

**Step by step, to get your own measurement ID + API secret:**

1. Do §4 first (create a Firebase project **with Google Analytics turned
   on**) — that automatically creates a linked GA4 property for you.
2. Go to https://analytics.google.com and open the property with the same
   name as your Firebase project.
3. Click **Admin** (gear icon, bottom-left) → **Data Streams** → click the
   stream for your app.
4. At the top of that page, copy the **Measurement ID** (looks like
   `G-XXXXXXXXXX`).
5. Scroll down on the same page to **"Measurement Protocol API secrets"** →
   click **Create** → give it any nickname (e.g. `windows-build`) → copy
   the generated **Secret value** — you only see it once.
6. Use both values:
   ```bash
   flutter build windows --release \
     --dart-define=AMBILYTICS_MEASUREMENT_ID=G-XXXXXXXXXX \
     --dart-define=AMBILYTICS_API_SECRET=your-secret-here
   ```
   (or add both to `secrets.json` as in §3).

## 6. Native binary dependencies (details)

The sing-box tunnel core and its wrappers are **not committed to this repo**
— too large for a normal commit and not worth a Git LFS bandwidth budget.
§2 already covers running the build scripts; details:

- **Android** (`android/app/libs/ZenshieldBox.aar`) — the Kotlin code
  imports classes from it directly, so the build *fails* without it, not
  just at runtime. `android/app/build.gradle` runs `android/fetch_native.sh`
  automatically before `preBuild` if the `.aar` is missing, so this happens
  on its own the first time you build/run — no manual step.
- **iOS** (`ios/ZenshieldBox.xcframework`) — same situation as Android: Swift
  code in `ios/Tunnel/` links against it directly, so Xcode builds *fail*
  without it. `ios/fetch_native.sh` mirrors the upstream Makefile's own
  `ios:` build target exactly (package, tags, target, ldflags), just renamed
  to match what `ios/Runner.xcodeproj` references. Run it manually (§2) —
  not wired into an Xcode Run Script phase.
- **Windows** (`singbox-tunnel.exe` at repo root, `windows/core/zenshield_core.dll`)
  — needed for the VPN connection to work at runtime; the app still compiles
  without them. `windows/CMakeLists.txt` runs
  `windows/packaging/build_native.sh` automatically on the first `cmake`
  configure if either file is missing, so this also happens on its own.
- **macOS** (`macos/zenshieldBox.xcframework`) — same situation as Android:
  Swift code in `macos/Tunnel/` and `macos/SystemTunnel/` links against it
  directly, so Xcode builds *fail* without it. `macos/fetch_native.sh`
  reconstructs the exact `gomobile bind` flags by matching the previously
  committed framework's structure (there's no known-good reference command
  for this exact target in the upstream Makefile, unlike iOS above) —
  verified working as of this writing, but re-verify if this command ever
  changes. Run it manually (§2) — not wired into an Xcode Run Script phase.

All four scripts accept an optional tag/commit to pin an exact version
(e.g. `android/fetch_native.sh v1.2.0`) — recommended for reproducible builds.
The Android/Windows auto-hooks (above) always run with no pinned ref; pass
one by running the script manually once, ahead of time — the hook's
missing-file check then finds the binary already there and skips.

All four also need `gomobile`/`gobind` installed from the
`github.com/sagernet/gomobile` fork (`v0.1.8`), not vanilla
`golang.org/x/mobile` — the Android Kotlin code calls low-level Go
reference-management APIs (`Seq.destroyRef`, `refnum`) that vanilla
gomobile's generated bindings no longer expose publicly, so vanilla gomobile
breaks the Android build specifically. iOS/macOS builds don't hit that same
issue (their Swift code doesn't touch those APIs), but use the same fork
here too since that's the toolchain actually tested against.

Three source repos must be public for these scripts to work:
`zenshield-windows-service`, `zenshield-singbox-geonode-sdk-patch`, and
`zenshield-singbox-utils` (a build-time dependency of the sing-box fork,
referenced via a local-path `replace` in its `go.mod` — the scripts already
clone both as siblings, as required).

## 7. Windows installer (EXE) packaging

Only needed for building a distributable, signed installer — not for
`flutter run -d windows`.

```bash
dart pub global activate fastforge

cd geonode_sdk && flutter pub get && cd ..
cd packages/desktop_updater && flutter pub get && cd ../..

fastforge package --flutter-build-args=verbose --platform windows --targets exe
```

Output lands in `dist/`. See §3 step 4 for filling in the code-signing
config first.

## 8. macOS packaging (signed, notarized build)

Only needed for a distributable, notarized `.app`/DMG — not for
`flutter run -d macos`. Unlike Windows, this is a manual Xcode flow, not
scripted:

1. Run `dart run desktop_updater:release macos` from the repo root — this
   builds the app and creates the folder structure under `dist/` (you can
   also create the folders manually):
   - **Path:** `dist/<buildNumber>/<pubspec_name>-<version>+<buildNumber>-macos/`
   - **Example:** `dist/18/zenshield-0.1.18+18-macos/`
2. Open `macos/Runner.xcworkspace` in Xcode (the `.xcworkspace`, not
   `.xcodeproj`).
3. **Product → Archive**, wait for it to finish.
4. In the Organizer window, click **Distribute App → Direct Distribution**,
   wait for the notarized export.
5. Place the exported `.app` into the `dist/...-macos/` folder from step 1,
   replacing the original unsigned bundle.

## 9. Windows / macOS OTA update archive

Uses the [desktop_updater](https://pub.dev/packages/desktop_updater) package
(local copy in `packages/desktop_updater`):

**Windows:**
```bash
dart run desktop_updater:release windows
dart run desktop_updater:archive windows
```
Archive lands in `dist/<buildNumber>/<version>+<build>-windows/`.

**macOS** (after completing §8's steps 1–5 so a signed `.app` is already in
place):
```bash
dart run desktop_updater:archive macos
```
This finds the signed `.app` in the latest `dist/` build-number folder,
copies its `Contents` into `dist/<buildNumber>/<version>+<buildNumber>-macos/`,
and generates a `hashes.json` there.

For either platform: upload the resulting folder (including `hashes.json`
on macOS) to a public URL and add/update the version entry in your
app-archive JSON manifest, with `url` pointing at that folder's base URL.

## 10. Split APK (Android)

```bash
flutter build apk --release --split-per-abi
```
