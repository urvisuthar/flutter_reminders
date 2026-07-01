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
- Navigate using `context.go(RouteNames.x)` to replace history, or `context.push(RouteNames.x)` to stack a new route

**Passing data without a network round-trip (`extra`):**
- For routes with a dynamic path param (e.g. `editReminder = '/reminders/:id/edit'`), the `:id` segment is mostly for a readable/deep-link-able URL — the actual object is passed via `context.push(url, extra: entity)` and read back in the route's `builder` as `state.extra as MyEntity?`
- Avoids an extra `getById` API call when the caller already has the full entity in hand (e.g. from a list screen)
- Tradeoff: `extra` only survives in-app navigation. A cold start from an external deep link (OS link, push notification) has `extra == null`, so the builder should be able to fall back to fetching by the path param `id` if you need real deep-linking support

**Auth guard (top-level `redirect`):**
- Add a `redirect: (context, state) async { ... }` callback on the `GoRouter` constructor — it runs before every navigation (`go`/`push`/deep link) and can return a new path to redirect to, or `null` to proceed
- Pattern used here: maintain a `_publicRoutes` set (splash, login, signup); check `TokenStorage.isLoggedIn()` (via `serviceLocator`) and `state.matchedLocation` against it
  - Not logged in + not a public route → redirect to `login`
  - Logged in + on `login`/`signup` → redirect to `home`
  - Otherwise → return `null` (proceed as normal)
- Deliberately leave `splash` unredirected either way, so its own animation + `AuthBloc.checkAuthStatus()` flow still runs on cold start
- Limitation: `redirect` only fires on navigation events — it won't auto-kick a user off a protected screen if their token expires while they're already sitting on it (would need `refreshListenable` wired to an auth `ChangeNotifier` for that)

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

---

## 13. image_picker (Gallery / Camera Image Selection)

**pubspec.yaml:**

    image_picker: ^1.2.2

**Steps:**
- `flutter pub get`
- Use `ImagePicker().pickImage(source: ImageSource.gallery)` for a single image (e.g. profile picture)
- Use `ImagePicker().pickMultiImage()` for multiple images (e.g. reminder attachments)
- Convert the returned `XFile` to `File` via `File(pickedFile.path)` before sending as multipart form data
- Preview picked images locally with `Image.file(...)`; keep them in local `State` (e.g. `List<File> _selectedImages`), not in the bloc state

---

## 14. pretty_dio_logger (Request/Response Logging)

**pubspec.yaml:**

    pretty_dio_logger: ^1.4.0

**Steps:**
- `flutter pub get`
- Add `PrettyDioLogger` to `dio.interceptors` in `DioClient`, guarded by `AppConfig.isDebugLoggingEnabled` (never log in prod)
- Configure `requestHeader`, `requestBody`, `responseBody` flags as needed

**Known limitation:** `PrettyDioLogger` prints `FormData` fields by collapsing them into a `Map`, which silently drops repeated keys (e.g. multiple `deleted_image_ids[]` entries — only the last value survives in the log, even though all values are still sent correctly on the wire). Work around this with a custom `InterceptorsWrapper.onRequest` placed before `PrettyDioLogger` that prints `FormData.fields`/`.files` directly (a `List<MapEntry>`, so duplicates are preserved), and set `requestBody: false` on `PrettyDioLogger` to avoid double-printing the body.

---

## 15. Firebase Core (firebase_core + FlutterFire CLI)

**pubspec.yaml:**

    firebase_core: ^4.11.0

**One-time machine setup:**
- Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
- **PATH gotcha (Windows):** this installs `flutterfire.bat` into `%LOCALAPPDATA%\Pub\Cache\bin`, which is *not* on PATH by default and won't be added automatically. If `flutterfire` isn't recognized after activating, add `%LOCALAPPDATA%\Pub\Cache\bin` to your User `Path` env var (Windows Settings → Environment Variables), then close/reopen the terminal
- `firebase login` (uses the base Firebase CLI, separate install from `npm install -g firebase-tools`)

**Steps:**
- Create the project in the [Firebase Console](https://console.firebase.google.com/)
- Run `flutterfire configure --project=<project-id>` from the repo root — generates `lib/firebase_options.dart` and drops `android/app/google-services.json` + `ios/Runner/GoogleService-Info.plist`
- Only select the platforms you actually ship (`android`,`ios`) — selecting `web`/`macos`/`windows` too can fail with a `FirebaseCommandException` trying to auto-register a web app, and pulls in config you don't need
- **Interactive prompts are unreliable in some Windows terminals** (arrow-key/checkbox input can render as garbled repeated text and silently fail to toggle selections). If that happens, bypass the interactive UI entirely with flags:

      flutterfire configure --project=<project-id> --platforms=android,ios --android-package-name=<applicationId> --ios-bundle-id=<bundleId> --yes

- Confirm the Gradle plugin got wired: `com.google.gms.google-services` should appear in both `android/settings.gradle.kts` (`plugins {}`, with version) and `android/app/build.gradle.kts` (`plugins {}`, no version)
- In `main.dart`, before `runApp()` (and before `initDependencies()`):

      import 'package:firebase_core/firebase_core.dart';
      import 'firebase_options.dart';
      ...
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

**Multi-environment caveat:** if your Android `applicationId` varies per environment via `--dart-define` (as in section 11) rather than real Gradle product flavors, `google-services.json` can only match **one** of those package names at a time — Firebase validates package name at runtime and will flag a mismatch for the other environments. Proper per-environment isolation needs actual Gradle flavors (matching `applicationId` per flavor + `google-services.json` placed under `android/app/src/<flavor>/`), which is a separate, bigger change — not required just to get Firebase working for one environment.

**iOS bundle ID note:** unlike Android's dart-define-driven `applicationId`, the iOS bundle ID is a single static value in `ios/Runner.xcodeproj/project.pbxproj` — there's no per-environment iOS equivalent unless you add Xcode build configurations/schemes per environment (out of scope unless you specifically need it).

**`GoogleService-Info.plist` is optional for Core alone:** `firebase_options.dart` embeds full iOS `FirebaseOptions` (apiKey, appId, iosBundleId, etc.), which is what `Firebase.initializeApp(options: ...)` actually reads — the native plist file isn't required just for `firebase_core` to work. It becomes relevant if you add a product whose native iOS SDK reads config directly outside Dart (e.g. some Crashlytics build-phase scripts).
