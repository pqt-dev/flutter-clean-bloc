# CLAUDE.md

Guidance for Claude Code when working in this repository. Based on the
official [Flutter AI rules template](https://docs.flutter.dev/ai/ai-rules)
(`flutter/flutter:docs/rules/rules.md`), adapted to the conventions already
implemented in this codebase. Where a project-specific convention below
conflicts with a generic Flutter/Dart best practice, the project convention
wins — it reflects a decision already made, not a suggestion.

You are an expert in Flutter and Dart. Build maintainable, performant code
that follows the Clean Architecture layering already in place here — do not
introduce a different architecture, state-management library, or DI
mechanism without being asked.

## Toolchain

- `flutter`/`dart` are **not** on PATH in this environment. The SDK is pinned
  via FVM (version in `.fvmrc`, symlinked at `.fvm/flutter_sdk`). Run:
  ```bash
  export PATH="$PWD/.fvm/flutter_sdk/bin:$PATH"
  flutter analyze
  flutter test
  dart run build_runner build -d   # regenerate freezed / injectable / json_serializable / mockito
  ```
- Prefer the `Makefile` targets over raw commands: `make pub_get`, `make l10n`,
  `make build_runner`, `make clean_cache`, `make info`. `make init`/`make rename`
  are one-shot bootstrap commands for turning this skeleton into a new app —
  never run them against this repo unless the user explicitly asks to rename
  or bootstrap a project from it (they mutate package names and can wipe git
  history).
- After changing any file with a `@JsonSerializable`, `@freezed`,
  `@injectable`/`@lazySingleton`/`@singleton`, or `@GenerateNiceMocks`
  annotation, run `build_runner build`, then `flutter analyze` and the
  relevant tests before considering the change done.

## Project structure (Clean Architecture, feature-based)

```
lib
├── core/          # config, constants, DI setup (get_it + injectable) — shared, no feature logic
├── data/          # datasource/, failures/ (exception → AppError), mappers/, models/ (DTOs), repositories/ (impl)
├── domain/        # core/ (Result, AppError, domain enums), entities/, repositories/ (contracts), use_cases/
└── presentation/  # core/ (shared widgets, bloc utils, error views), features/<name>/, router/, theme/
```

`test/` mirrors this structure 1:1 (e.g. `lib/domain/use_cases/favourite/x.dart`
→ `test/domain/use_cases/favourite/x_test.dart`). Keep new tests in the
matching path.

## Layer conventions (already decided — follow, don't relitigate)

- **Every feature goes through a UseCase**, even when it's a thin
  pass-through wrapper around a Repository method (e.g.
  `CountryUseCase.fetchAllCountries`). Blocs/Cubits inject a UseCase, **never**
  a Repository directly. This is a deliberate skeleton-consistency choice
  (see `README.md` → "Layer conventions"); don't skip the wrapper to save
  boilerplate.
- **Repository owns data-sourcing.** Cache-vs-remote decisions, model→entity
  mapping, and multi-datasource orchestration live in the repository
  implementation (`data/repositories/**`) — not in the UseCase or Bloc.
- **Errors flow through `Result<T>` / `AppError`**
  (`domain/core/result.dart`, `domain/core/app_error.dart`), not exceptions
  crossing layer boundaries. `data/failures/exception_mapper.dart` is the one
  place that converts raw exceptions (`DioException`, `FormatException`, …)
  into a sealed `AppError` subtype (`NetworkError`, `ServerError`,
  `AuthError`, `ParsingError`, `UnexpectedError`). Repositories catch at the
  boundary and return `Failure(error)`; UseCases/Blocs pattern-match on
  `Result` with `switch`, they don't catch exceptions themselves.
- **Domain stays Flutter-free.** Don't import Flutter framework types into
  `domain/`. Where a Flutter type would otherwise leak in (e.g. `ThemeMode`),
  define a domain-level equivalent (`AppThemeMode`) and convert at the widget
  boundary.

## State management (BLoC)

- Use `flutter_bloc` for all app/feature state. Prefer `Cubit` for simple
  method-driven state; use `Bloc` (event-driven) only when you need async
  event transformation, debouncing, or non-trivial event-to-state mapping.
- State classes use `freezed` and hold domain types, not framework types.
- **No async work in a Bloc/Cubit constructor.** Trigger initialization
  explicitly: `BlocProvider(create: (_) => getIt<MyCubit>()..init())`.
- For a handler that mutates persisted/shared state (e.g. toggling a
  favourite), apply `transformer: sequential()`
  (`presentation/core/bloc/event_transformers.dart`) so rapid repeated
  dispatches process one at a time and can't read stale state. The default
  transformer runs handlers concurrently — don't rely on it for
  read-then-write mutations.
- A global `AppBlocObserver`, registered in `main()` in debug builds only,
  logs every state transition and error — don't add ad-hoc `print`/logging
  inside Blocs for this purpose.

## Dependency Injection (get_it + injectable)

- Annotate, don't hand-wire: `injectable` + `get_it`, code-generated into
  `core/di/injection.config.dart`. Run `build_runner build` after changing
  annotations.
- Lifecycle rules:
  - `@lazySingleton` — global/shared app state or stateless services
    (theme, favourites, auth, `ExceptionMapper`, `AppConfig`, UseCases).
  - `@injectable` (factory) — screen-scoped state whose lifecycle is owned by
    a `BlocProvider`, not by GetIt.
  - `@singleton` — services that must initialize eagerly
    (e.g. `InternetConnectionService`).
- Group third-party registrations in `@module` abstract classes
  (e.g. `NetworkModule`, `StorageModule`) rather than registering them ad hoc.

## Routing (GoRouter)

Use `go_router` for all navigation (deep linking, web support). Use its
`redirect` to send unauthorized users to login. Reserve the built-in
`Navigator` for short-lived, non-deep-linkable UI (dialogs, transient
overlays).

```dart
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return DetailScreen(id: id);
          },
        ),
      ],
    ),
  ],
);
MaterialApp.router(routerConfig: _router);
```

## Networking & error handling

- `dio` + `pretty_dio_logger`, configured through `data/datasource/http/`
  interceptors. `AppConfig` (`core/config/app_config.dart`) is the single
  source of truth for base URL/API key — don't hard-code them elsewhere or
  read them from ad-hoc env lookups.
- Map every thrown exception to an `AppError` via `ExceptionMapper` before it
  reaches the domain/presentation layer.

## Data handling & serialization

- `json_serializable` + `json_annotation` for DTOs in `data/models/`.
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` so Dart camelCase
  fields map to snake_case JSON keys.

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;
  User({required this.firstName, required this.lastName});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## Testing

- `flutter_test` for widget/unit tests; `mockito` (with
  `@GenerateNiceMocks`) for mocks — regenerate via `build_runner` after
  adding/changing a mock annotation.
- Mirror `lib/` paths under `test/`. Follow Arrange-Act-Assert.
- Write unit tests for UseCases, repositories, mappers, and Cubit/Bloc state
  transitions; widget tests for UI. Prefer fakes/stubs over mocks when a
  dependency is simple enough to fake.

## Code quality (Dart & Flutter)

- Follow [Effective Dart](https://dart.dev/effective-dart). `PascalCase` for
  classes, `camelCase` for members/functions, `snake_case` for files.
- Keep functions short and single-purpose (aim for <20 lines). Prefer
  composition over inheritance; compose small private `Widget` classes
  instead of private helper methods that return a `Widget`.
- Sound null safety — avoid `!` unless non-null is guaranteed. Use pattern
  matching / exhaustive `switch` expressions where they simplify branching
  (this codebase already does this for `Result`/`AppError`).
- Widgets, especially `StatelessWidget`, are immutable; use `const`
  constructors wherever possible.
- Use `ListView.builder`/`SliverList` for long lists; use `compute()` for
  expensive work (e.g. JSON parsing) off the UI thread; never do network or
  heavy computation inside `build()`.
- Logging: use `dart:developer`'s `log`, not `print` (`avoid_print` is
  enforced via `flutter_lints` in `analysis_options.yaml`).
- Run `dart_fix`/`flutter analyze` after non-trivial edits; the project's
  `analysis_options.yaml` extends `flutter_lints` and excludes generated
  (`*.g.dart`, `*.freezed.dart`) files from analysis.
- Comments explain *why*, not *what* — the code should read on its own.
  Don't add comments to code you didn't change.

## Theming

- Centralize `ThemeData` (see `presentation/theme/`); support light and dark
  via `theme`/`darkTheme`, switchable through `ThemeCubit`
  (`domain/core/app_theme_mode.dart` → converted to Flutter's `ThemeMode` at
  the widget boundary, never leaked into domain/data).
- Generate palettes with `ColorScheme.fromSeed`. Use `google_fonts` for
  custom typography via a centralized `TextTheme`.

## Accessibility

- Text contrast ≥ 4.5:1 against its background.
- Verify the UI holds up under increased system font scaling.
- Use `Semantics` for descriptive labels; spot-check with TalkBack/VoiceOver
  for screens with custom interactive widgets.

## Localization

- `easy_localization`, sourced from `assets/translations/`. Regenerate via
  `make l10n` (or `dart run easy_localization:generate ...`) after adding or
  changing translation keys — don't hand-edit the generated `locale_keys.g.dart`.
