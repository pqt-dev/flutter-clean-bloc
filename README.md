# 🦅 Flutter Clean BLoC Skeleton

A lightweight, scalable Flutter **starter skeleton** implementing **Clean
Architecture** with **BLoC / Cubit** for state management. Clone it, run a
single command, and you have a clean, renamed project ready to build your app
on — with no boilerplate example code left behind.

## ✨ What you get

- **Clean Architecture** — clear `data` / `domain` / `presentation` separation
- **BLoC & Cubit** — predictable, scalable state management
- **Dependency Injection** — `get_it` + `injectable` (code-generated)
- **Routing** — declarative navigation with `go_router`
- **Networking** — typed `Dio` client with centralized error mapping
- **Localization** — multi-language via `easy_localization`
- **Theming** — built-in light / dark theme switching

## 🚀 Getting started

> [!NOTE]
> **Prerequisite:** This project uses [FVM](https://fvm.app) (Flutter Version
> Manager). Install FVM, or set `USE_FVM := false` at the top of the `Makefile`
> to use a standard Flutter install.

> [!WARNING]
> The `make` commands are tested on **macOS** and may not work as-is on Linux
> or Windows (they rely on BSD `sed`, `PlistBuddy`, etc.).

### Bootstrap a new app — one command

This is the recommended way to start a new project from this skeleton:

```bash
make init project_name=my_app package_name=com.company.myapp app_name="My App"
```

`make init` does everything in a single step:

| Step | What happens |
| ---- | ------------ |
| 🗑️  **Strip examples** | Removes the example features (`country`, `favourite`, `search`) across data/domain/presentation + their tests |
| 📝 **Install skeleton** | Drops in a minimal **Home + Setting** shell (bottom-nav, theme & language switching) |
| ✏️  **Rename** | Updates the Dart package name, all `package:` imports, Android `applicationId`/namespace + Kotlin path, iOS bundle id, and the app display name |
| ⚙️  **Regenerate** | Runs `pub get`, localization, and code generation |
| 🧹 **Clean** | Wipes caches, build artifacts, and the skeleton templates — no boilerplate traces left |
| 🔬 **Verify** | Runs `flutter analyze` to confirm the project compiles |
| 🔁 **Reset git** | Optionally wipes git history into a fresh `Initial commit` (asks for confirmation) |

**Parameters**

| Param            | Required | Description                                            |
| ---------------- | -------- | ------------------------------------------------------ |
| `project_name`   | ✅       | Dart package name in `pubspec.yaml` (snake_case)       |
| `package_name`   | ✅       | Android + iOS bundle ID (e.g. `com.company.myapp`)     |
| `app_name`       | optional | Display name shown on the device home screen           |
| `android_package`| optional | Android-only ID (overrides `package_name` for Android) |
| `ios_bundle`     | optional | iOS-only bundle ID (overrides `package_name` for iOS)  |

### Rename only (keep example features)

If you just want to rename an existing project **without** removing the
examples, use `make rename` with the same parameters:

```bash
make rename project_name=my_app package_name=com.company.myapp app_name="My App"
```

You can also rename pieces individually:

```bash
make rename project_name=my_app          # project name + Dart imports only
make rename android_package=com.a.b      # Android package only
make rename ios_bundle=com.a.b           # iOS bundle id only
```

## 🏗 Project structure

```
lib
├── core/              # Foundational code shared across the app
│   ├── config/        # App configuration (flavors, base URLs, API keys)
│   ├── constants/     # Global constants (locales, storage keys, ...)
│   └── di/            # Dependency injection setup (get_it + injectable)
│
├── data/
│   ├── datasource/    # Local & remote data sources (HTTP client, interceptors)
│   ├── failures/      # Exception mappers (Exception -> AppError)
│   ├── mappers/       # Map data models <-> domain entities
│   ├── models/        # DTOs with fromJson/toJson
│   └── repositories/  # Implementations of domain repositories
│
├── domain/
│   ├── core/          # Core domain logic (Result type, AppError)
│   ├── entities/      # Pure business objects
│   ├── repositories/  # Repository contracts (interfaces)
│   └── use_cases/     # Application business rules
│
├── presentation/
│   ├── core/          # Shared widgets, dialogs, error views, bloc utils
│   ├── features/      # Screens & blocs/cubits grouped by feature
│   ├── extensions/    # BuildContext & other extensions
│   ├── router/        # GoRouter configuration and route definitions
│   └── theme/         # Theme config (colors, styles) and ThemeCubit
│
└── main.dart          # Application entry point
```

## 📚 Core packages

| Category         | Package                                                           |
| ---------------- | ----------------------------------------------------------------- |
| State management | [flutter_bloc](https://pub.dev/packages/flutter_bloc)             |
| Navigation       | [go_router](https://pub.dev/packages/go_router)                   |
| Dependency inj.  | [get_it](https://pub.dev/packages/get_it) · [injectable](https://pub.dev/packages/injectable) |
| Network          | [dio](https://pub.dev/packages/dio) · [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) |
| Local storage    | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Localization     | [easy_localization](https://pub.dev/packages/easy_localization)   |
| Code generation  | [freezed](https://pub.dev/packages/freezed) · [json_serializable](https://pub.dev/packages/json_serializable) · [build_runner](https://pub.dev/packages/build_runner) |
| Assets           | [flutter_gen](https://pub.dev/packages/flutter_gen)               |
| UI               | [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) · [google_fonts](https://pub.dev/packages/google_fonts) |

## 🛠 Day-to-day commands

```bash
make               # check SDK, clean, pub get, generate l10n + code (full setup)
make pub_get       # flutter pub get
make l10n          # regenerate localization from assets/translations
make build_runner  # run code generation (freezed, json, injectable)
make clean_cache   # wipe caches and IDE/build artifacts
make info          # print current project name, Android package, iOS bundle id
```

### Manual setup (without `make`)

```bash
fvm flutter clean
fvm flutter pub get
fvm dart run easy_localization:generate -S assets/translations
fvm dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
fvm dart run build_runner build -d
```

## 🧪 Testing

```bash
fvm flutter test
```

Generate an HTML coverage report:

```bash
fvm flutter test --coverage && genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```
