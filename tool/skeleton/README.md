# App

A Flutter application built on Clean Architecture with BLoC/Cubit, dependency
injection (`get_it` + `injectable`), routing (`go_router`), and localization
(`easy_localization`).

## Architecture

```
lib/
├── core/            # Config, constants, dependency injection
├── data/            # Data sources, models, repository implementations
├── domain/          # Entities, repository contracts, use cases
└── presentation/    # UI: features, routing, theme, shared widgets
```

The starter ships with a working skeleton: a bottom-navigation shell with a
**Home** tab and a **Setting** tab (theme + language switching), a typed
networking layer (`Dio` + `ApiClient`), centralized error handling, and
light/dark theming. Build your features under `lib/presentation/features` and
wire dependencies with `injectable` annotations.

## Getting started

```bash
make all          # check SDK, clean, pub get, generate l10n + code
flutter run
```

## Useful commands

| Command             | Description                                      |
| ------------------- | ------------------------------------------------ |
| `make pub_get`      | `flutter pub get`                                |
| `make l10n`         | Regenerate localization from `assets/translations` |
| `make build_runner` | Run code generation (freezed, json, injectable)  |
| `make all`          | Run the full setup pipeline                      |

## Localization

Add keys to `assets/translations/*.json`, then run `make l10n` to regenerate
`LocaleKeys` and the codegen loader.

## Code generation

After editing any `freezed` / `json_serializable` / `injectable` annotated
file, run `make build_runner`.
