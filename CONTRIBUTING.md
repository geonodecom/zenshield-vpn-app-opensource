# Contributing to ZenShield VPN

Thanks for your interest in contributing! This project is scoped to
**authentication and VPN connectivity** — please keep PRs focused on that,
or open an issue first to discuss a larger change.

## Getting set up

Follow `README.md` §1–§2 to get the app building and running locally. In
short:

```bash
flutter pub get
ios/fetch_native.sh      # or macos/fetch_native.sh — Android/Windows fetch automatically on first build
flutter run -d android   # or ios / windows / macos
```

No API keys are required to build, run, or connect the VPN — see README §3
for the fully optional ones (analytics, crash reporting).

> **Note:** three upstream native repos this project builds against
> (`zenshield-windows-service`, `zenshield-singbox-geonode-sdk-patch`,
> `zenshield-singbox-utils`) are not public yet. If a native build step
> fails because one of those repos 404s for you, open an issue and we'll
> help — this is expected to be resolved as those repos are published.

## Before opening a pull request

1. **Regenerate code if you touched anything generated.** Freezed models,
   `injection_container.config.dart`, and localizations are checked in
   generated — regenerate after any relevant change:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter gen-l10n   # if you edited lib/l10n/app_en.arb
   ```
2. **Run analysis and tests:**
   ```bash
   flutter analyze
   flutter test
   ```
   Both must pass clean — CI runs the same checks (see
   `.github/workflows/ci.yml`).
3. **Keep the diff scoped.** Avoid unrelated formatting/refactor churn in
   the same PR as a feature/fix — it makes review harder.
4. **Update `README.md`** if you change setup steps, add a dependency, or
   touch the native build scripts.

## Code style

- Follow the existing `flutter_bloc`/`side_effect_bloc` pattern for new
  features (`bloc` / `event` / `side_effect` / `state`).
- Use `injectable`/`get_it` for dependency wiring — don't instantiate
  services manually inside widgets.
- Don't add comments that restate what the code already says; only
  document non-obvious constraints or workarounds.

## Reporting bugs / requesting features

Open a GitHub issue using the appropriate template. For security
vulnerabilities, see `SECURITY.md` instead — please don't file those
publicly.

## Code of Conduct

This project follows the `CODE_OF_CONDUCT.md`. By participating, you're
expected to uphold it.
