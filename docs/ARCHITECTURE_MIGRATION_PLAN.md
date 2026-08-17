# ZenShield — Architecture Migration Plan

**Branch:** `zenshield_new_architecture`
**Goal:** Adopt the *morning-plan* folder pattern — a strict per-feature
`data / domain / presentation` nesting with explicit
`dataSource → repository → useCase` separation.

> **Scope is structural only.** We copy the *folder shape* and the
> *layer separation*. We do **NOT** change UI, features, or runtime behavior.
> We also intentionally **keep** ZenShield's stronger conventions:
> `freezed`, `injectable`, `side_effect_bloc`, typed exceptions.
> (morning-plan uses hand-written JSON / manual get_it / plain Bloc / fpdart —
> those are *not* copied; converting to them would be a downgrade.)

---

## 1. Current layout (before)

ZenShield splits layers at the **top level**:

```
lib/features/<name>/        → data + domain, flat (repo+impl same file, use_case, models)
lib/presentation/modules/<name>/  → UI + bloc (bloc, event, side_effect, view, state/)
```

Problem the migration solves: a single feature's code is scattered across two
top-level trees, and repository *contract* + *implementation* live in one file.

## 2. Target layout (after)

Each feature becomes one self-contained vertical slice:

```
lib/feature/<name>/
├── data/
│   ├── dataSources/      <name>_remote_data_source.dart   (raw Dio / SDK calls)
│   ├── model/            *.dart (+ *.freezed.dart / *.g.dart stay together)
│   └── repoImplementation/  <name>_repository_impl.dart   (implements domain contract)
├── domain/
│   ├── repositories/     <name>_repository.dart            (abstract contract ONLY)
│   └── useCase/          <name>_use_case.dart
└── presentation/
    ├── bloc/             <name>_bloc.dart / _event / _side_effect / state/
    └── <name>_view.dart, widgets/
```

Dependency rule (unchanged from morning-plan): **UI never touches Dio/SDK
directly** → `Bloc → UseCase → AbstractRepository → RepositoryImpl → RemoteDataSource → Dio`.

`lib/core/`, `lib/di/`, `lib/route/`, `lib/theme/`, `lib/gen/`, `lib/l10n/`
stay where they are (shared infra — morning-plan keeps these at `core/`/`config/` too).

---

## 3. Feature ↔ module mapping

ZenShield has more `features/` than `presentation/modules/` and they do not map
1:1. Three cases:

### Case A — feature has both a data/domain part AND a UI module → merge
| New slice `lib/feature/<x>/` | from `features/<x>/` | from `presentation/modules/<x>/` |
|---|---|---|
| `auth` | auth_repository, auth_user_use_case, oauth, models | auth_bloc/event/side_effect/view/state |
| `servers` | servers_repository, server_grouping, models | servers_bloc/... |

### Case B — data/domain feature with NO matching UI module → data+domain only
`agreements`, `android_updater`, `app_version`, `connection`, `deep_links`,
`desktop_updater`, `launch`, `network_monitor`, `rating`, `region_checker`,
`singbox`, `timer`, `tracking`, `user_feedback`, `user_info`, `vpn_config`,
`vpn_connection`
→ become `lib/feature/<x>/{data,domain}` (no `presentation/`).

### Case C — UI module with NO matching data feature → presentation only
`about`, `app`, `app_update`, `check_inbox`, `home`, `logs`, `new_password`,
`onboarding_progress`, `protocols`, `reset_password`, `settings`, `splash`
→ become `lib/feature/<x>/presentation` (these consume other features' use cases).

> Note: `app_update` (module) pairs conceptually with `app_version` +
> `desktop_updater`/`android_updater` (features). Keep them as separate slices;
> the `app_update` presentation slice just imports those use cases. No merge.

---

## 4. Per-feature separation rules (the "repository/dataSource/useCase" split)

For every Case A/B slice, apply the morning-plan 3-way split:

1. **Split the repository file.** Today `servers_repository.dart` holds BOTH
   `abstract AbstractServersRepository` and `class ServersRepository`.
   - `abstract` → `domain/repositories/servers_repository.dart`
   - `class ...Repository` → `data/repoImplementation/servers_repository_impl.dart`
2. **Extract a RemoteDataSource.** Pull the raw `Dio`/SDK/HTTP calls out of the
   impl into `data/dataSources/<x>_remote_data_source.dart` (abstract + impl).
   The repository impl then depends on the data source, not on `Dio` directly.
   - *If a feature has no network I/O (e.g. `timer`, `launch`), skip the data
     source — keep repo/use_case only. Do not invent a data source.*
3. **Keep the use case** as-is, just move to `domain/useCase/`.
4. **Move models** wholesale (`.dart` + `.freezed.dart` + `.g.dart` together)
   into `data/model/`. `part` directives stay valid because siblings move together.

Abstract-repository naming already matches morning-plan (`AbstractXRepository`),
so no rename needed — only relocation.

---

## 5. Code-generation — MUST regenerate, do not hand-edit

Moving files changes import paths inside generated files:

- **injectable** → `lib/di/injection_container.config.dart` references every
  injectable class by import path. After moving files, run:
  ```
  dart run build_runner build --delete-conflicting-outputs
  ```
- **freezed / json_serializable** → `*.freezed.dart` / `*.g.dart` regenerate
  from the same command.

`injection_container.config.dart` is generated — **never edit by hand**; let
build_runner rewrite it after each batch of moves.

---

## 6. Execution order (incremental, verify after each)

Do NOT move all 272 files at once — the build must stay green between steps.

1. **Pilot (1 feature):** migrate `region_checker` (Case B, small: use_case +
   model + region API). Prove the shape, run `build_runner`, `flutter analyze`.
2. **Case A merges:** `auth`, `servers` (highest value, exercises full stack).
3. **Case B batch:** the data/domain-only features, a few at a time.
4. **Case C batch:** the presentation-only modules.
5. **Cleanup:** delete now-empty `lib/features/` and `lib/presentation/modules/`
   trees; update barrel/imports; final `build_runner` + `flutter analyze`.

After every step: `dart run build_runner build --delete-conflicting-outputs`
then `flutter analyze` (or `dart analyze`) — zero new errors before continuing.

---

## 7. Explicitly OUT of scope (do not touch)

- ❌ `freezed` → hand-written `fromJson/toJson` (keep freezed).
- ❌ `injectable` → manual get_it registration (keep injectable).
- ❌ `SideEffectBloc` → plain `Bloc` (keep side effects — UI depends on them).
- ❌ `Either<Failure,T>` / `fpdart` wrapping (keep typed exceptions + try/catch).
- ❌ Any widget/UI change, string change, or behavior change.
- ❌ Renaming classes (only files/folders move; class names unchanged).

---

## 8. Risk register

| Risk | Mitigation |
|---|---|
| Broken imports after move | IDE/refactor move + `build_runner` + `analyze` per step |
| Stale generated config | Regenerate `injection_container.config.dart` every batch |
| `part` directive breakage | Move source + its generated siblings together |
| Case A merge collisions (e.g. two `auth_state`) | Keep module/state filenames; only relocate |
| Native/FFI singbox coupling | Treat `singbox` as data-only; do not force HTTP shape |
| Large blast radius | Incremental order in §6; branch is local-only (not pushed) |

---

## 9. Definition of done

- All slices under `lib/feature/<x>/{data,domain,presentation}`.
- `lib/features/` and `lib/presentation/modules/` removed.
- `flutter analyze` clean; app builds; **no behavioral/UI diff**.
- No conversion of freezed/injectable/side_effect/exceptions.
</content>
</invoke>
