# Flutter Reminders — Setup & Integration Guide

---

## 1. flutter_bloc

**pubspec.yaml:**

    flutter_bloc: ^9.1.1

**Steps:**
- `flutter pub get`
- Extend `Cubit<State>` or `Bloc<Event, State>` for state management
- Use Freezed for state/event classes (see section 12)
- Wrap app with `MultiBlocProvider` in `main.dart`
- Use `BlocProvider`, `BlocBuilder`, `BlocListener`, `BlocConsumer` in widgets
- In listeners use `state.whenOrNull(...)`, in builders use `state.when(...)` or `state.maybeWhen(...)`

---

## 2. get_it (Service Locator)

**pubspec.yaml:**

    get_it: ^9.2.1

**Steps:**
- `flutter pub get`
- Create `lib/init_dependency.dart` with `final serviceLocator = GetIt.instance`
- Register all dependencies inside `initDependencies()`
- Call `await initDependencies()` before `runApp()` in `main.dart`
- Access anywhere via `serviceLocator<ClassName>()`

---

## 3. dio (HTTP Client)

**pubspec.yaml:**

    dio: ^5.9.2

**Steps:**
- `flutter pub get`
- Create `DioClient` class wrapping `Dio` with `BaseOptions`
- Set `baseUrl`, `connectTimeout`, `receiveTimeout`, `headers`
- Add interceptors via `dio.interceptors.add()`
- Register `DioClient` in `init_dependency.dart`

---

## 4. shared_preferences

**pubspec.yaml:**

    shared_preferences: ^2.5.5

**Steps:**
- `flutter pub get`
- Call `await SharedPreferences.getInstance()` in `initDependencies()`
- Register: `serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences)`
- Wrap in `LocalStorage` class — never use `SharedPreferences` directly in features

---

## 5. flutter_secure_storage (Token Storage)

**pubspec.yaml:**

    flutter_secure_storage: ^10.3.1

**Steps:**
- `flutter pub get`
- Create `const secureStorage = FlutterSecureStorage()`
- Register in `init_dependency.dart`
- Wrap in `TokenStorage` class for access/expiry token management
- Never store tokens in `SharedPreferences`

---

## 6. go_router (Navigation)

**pubspec.yaml:**

    go_router: ^17.3.0

**Steps:**
- `flutter pub get`
- Create `lib/core/routes/route_names.dart` with route path constants
- Create `lib/core/routes/app_router.dart` with `GoRouter` instance and all `GoRoute` entries
- Use `MaterialApp.router(routerConfig: appRouter)` in `main.dart`
- Navigate using `context.go(RouteNames.x)` in widgets

---

## 7. fpdart (Functional Programming / Either)

**pubspec.yaml:**

    fpdart: ^1.2.0

**Steps:**
- `flutter pub get`
- Use `Either<Failure, Success>` as return type in repositories and usecases
- Handle result with `.fold((failure) => ..., (success) => ...)`

---

## 8. Localization (flutter_localizations + intl)

**pubspec.yaml:**

    flutter_localizations:
      sdk: flutter
    intl: ^0.20.2

    flutter:
      generate: true

**Steps:**
- `flutter pub get`
- Create `l10n.yaml` at project root with content:

      arb-dir: lib/l10n
      template-arb-file: app_en.arb
      output-localization-file: app_localizations.dart

- Create `lib/l10n/app_en.arb` and `lib/l10n/app_hi.arb` with key-value translations
- Run `flutter gen-l10n` to generate `AppLocalizations`
- Add to `MaterialApp.router`:

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [Locale('en'), Locale('hi')],
      locale: settings.locale,

- Access in widgets via extension: `context.l10n.keyName`

---

## 9. Theme (Dark / Light)

**No package needed — Flutter built-in**

**Steps:**
- Create `lib/core/theme/app_colors.dart` with all color constants
- Create `lib/core/theme/app_theme.dart` with `AppTheme.light` and `AppTheme.dark`
- Add to `MaterialApp.router`:

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,

- Never use `AppColors` directly in widgets — always use `Theme.of(context).colorScheme`

---

## 10. SettingsCubit (Theme + Locale persistence)

**No extra package — uses SharedPreferences via LocalStorage**

**Steps:**
- Add theme/locale save/get methods to `LocalStorage`
- Create `lib/core/settings/settings_state.dart` with `ThemeMode` and `Locale`
- Create `lib/core/settings/settings_cubit.dart` with `toggleTheme()` and `changeLocale()`
- Register in `init_dependency.dart`:

      serviceLocator.registerLazySingleton(() => SettingsCubit(serviceLocator<LocalStorage>()))

- Add `BlocProvider<SettingsCubit>` in `MultiBlocProvider` in `main.dart`
- Wrap `MaterialApp.router` with `BlocBuilder<SettingsCubit, SettingsState>`

---

## 11. Environment Config (dart-define + Makefile)

**No package needed**

**Steps:**
- Install Make on Windows: `choco install make`
- Create `env/` folder with `sit.json`, `uat.json`, `prod.json` containing env variables
- Create `lib/core/config/app_config.dart` reading values via `String.fromEnvironment()`
- Create `Makefile` at project root with commands:

| Command | What it does |
|---|---|
| `make run-sit` | Run app with SIT environment |
| `make run-uat` | Run app with UAT environment |
| `make run-prod` | Run app in release with PROD environment |
| `make build-sit` | Build APK with SIT environment |
| `make build-uat` | Build APK with UAT environment |
| `make build-prod` | Build APK in release with PROD environment |
| `make bundle-prod` | Build App Bundle for Play Store |
| `make ipa-prod` | Build IPA for iOS App Store |
| `make clean` | Run `flutter clean` |
| `make get` | Run `flutter pub get` |
| `make refresh` | Run `flutter clean` then `flutter pub get` |
| `make generate` | `pub get` + `build_runner` + `dart format` |
| `make setup` | Full clean + get + generate |

---

## 12. Freezed (Immutable Classes + Code Generation)

**pubspec.yaml:**

    # dependencies
    freezed_annotation: ^3.1.0
    json_annotation: ^4.12.0

    # dev_dependencies
    freezed: ^3.2.5
    json_serializable: ^6.14.0
    build_runner: ^2.15.0

**Steps:**
- `flutter pub get`
- Add to `.gitignore` to exclude generated files:

      *.freezed.dart
      *.g.dart

- Run `make generate` to generate all Freezed files

**Usage patterns:**

| Use case | Annotation | Part directives |
|---|---|---|
| State / Event (union) | `@freezed` | `part 'x.freezed.dart'` |
| Entity / Model (data class) | `@freezed` | `part 'x.freezed.dart'` |
| Model with JSON | `@freezed` | `part 'x.freezed.dart'` + `part 'x.g.dart'` |
| Simple data carrier (params, failure) | plain class | none |

**State pattern:**
```dart
@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.success(UserEntity user) = _Success;
  const factory ProfileState.failure(Failure failure) = _Failure;
}
```

**When to use which method:**
- `state.when(...)` — inside builder, must handle all states, returns a widget
- `state.whenOrNull(...)` — inside listener, only handle specific states
- `state.maybeWhen(orElse: ...)` — need a single value with a fallback
