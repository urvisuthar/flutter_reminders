## Flutter Reminders — Complete Roadmap

---

## Phase 1 — Core Reminders Feature

### Step 1.1 — Reminder Domain Layer
- Create `ReminderEntity` (Freezed)
- Create `ReminderRepository` (abstract)
- Create use cases:
  - `GetRemindersUseCase`
  - `GetReminderByIdUseCase`
  - `AddReminderUseCase`
  - `EditReminderUseCase`
  - `DeleteReminderUseCase`

### Step 1.2 — Reminder Data Layer
- Create `ReminderModel` (Freezed + JSON)
- Create `ReminderRemoteDataSource` (Dio calls)
- Create `ReminderRepositoryImpl`
- Register all in `init_dependency.dart`

### Step 1.3 — Reminder BLoC
- Create `ReminderEvent` (Freezed)
- Create `ReminderState` (Freezed)
- Create `ReminderBloc`
- Wire up all 5 use cases inside bloc

### Step 1.4 — Reminders List Page
- List of reminder cards
- Pull to refresh
- Swipe to delete
- Search bar (live filter)
- Filter tabs: All / Today / Upcoming / Completed

### Step 1.5 — Add / Edit Reminder Page
- Title, description fields
- Date & time picker
- Image picker (attach images)
- Submit calls Add or Edit use case

### Step 1.6 — Reminder Detail Page
- View full reminder info
- Show attached images
- Edit button → navigates to edit page
- Delete button with confirm dialog

---

## Phase 2 — Auth Completion

### Step 2.1 — Sign Up
- Create `SignUpUseCase`
- Create Sign Up page (name, email, password)
- Connect to BLoC + navigate to home on success

### Step 2.2 — Social Login (Google)
- Add `google_sign_in` + `firebase_auth` packages
- Implement Google Sign-In flow
- Send Firebase token to your backend
- Navigate to home on success

### Step 2.3 — Forgot Password
- Create `ForgotPasswordUseCase`
- Create Forgot Password page (email input)
- Call `POST /auth/forgot-password`
- Show success message

### Step 2.4 — Reset Password
- Create `ResetPasswordUseCase`
- Create Reset Password page (token + new password)
- Call `POST /auth/reset-password`
- Redirect to login on success

---

## Phase 3 — Bottom Navigation & UI Shell

### Step 3.1 — Navigation Shell
- Replace current routing with GoRouter `ShellRoute`
- Add `BottomNavigationBar` with 3 tabs
- Maintain state per tab (don't rebuild on switch)

### Step 3.2 — Tab 1: Home
- Welcome message with user name
- Summary cards (Total / Today / Upcoming / Completed count)
- Horizontal scroll of upcoming reminders
- Quick Add FAB

### Step 3.3 — Tab 2: Reminders
- Full reminders list (from Phase 1)
- Filter tabs at top
- Search bar
- FAB to add new reminder

### Step 3.4 — Tab 3: Profile
- User info (name, email, avatar)
- Dark mode toggle
- Language selector (already have l10n)
- Logout button

### Step 3.5 — UI Polish
- Add loading skeletons / shimmer on lists
- Empty state illustrations
- Error state with retry button
- Smooth page transitions

---

## Phase 4 — Firebase Setup

### Step 4.1 — Firebase Project Setup
- Create Firebase project
- Add Android app → download `google-services.json`
- Add iOS app → download `GoogleService-Info.plist`
- Run `flutterfire configure`
- Add `firebase_core` and initialize in `main.dart`

### Step 4.2 — FCM Token Fetch
- Add `firebase_messaging` package
- Request notification permission on app start
- Get FCM token
- Call `PUT /auth/fcm-token` to register with backend
- Handle token refresh and re-register

### Step 4.3 — Push Notifications
- Handle foreground notifications (show in-app banner)
- Handle background notifications
- Handle notification tap → navigate to correct reminder
- Add `flutter_local_notifications` for Android heads-up

### Step 4.4 — Firebase Analytics Events
- `login` — on successful login
- `sign_up` — on registration
- `social_login` — on Google sign in
- `reminder_created` — on add reminder
- `reminder_deleted` — on delete
- `reminder_completed` — on mark done
- Screen view tracking on all pages

---

## Phase 5 — Map Feature

### Step 5.1 — Google Maps Setup
- Add `google_maps_flutter` package
- Get Google Maps API key
- Configure for Android (`AndroidManifest.xml`) and iOS (`AppDelegate.swift`)

### Step 5.2 — Location Permission & Current Location
- Add `geolocator` + `permission_handler` packages
- Request location permission
- Get current location on map open

### Step 5.3 — Location on Reminder
- Add location picker to Add/Edit Reminder page
- Show map, let user drop a pin
- Save lat/lng with reminder

### Step 5.4 — Map Tab / View
- Add Map tab in bottom nav (4th tab) OR a map icon in Reminders tab
- Show all reminders with location as map pins
- Tap pin → show reminder info card
- Tap card → navigate to reminder detail

---

## Phase 6 — Testing

### Step 6.1 — Unit Tests
- Test all use cases (mock repository)
- Test `ReminderBloc` with `bloc_test`
- Test `AuthBloc` with `bloc_test`
- Test validators and extensions

### Step 6.2 — Widget Tests
- Login page — form validation, submit
- Reminders list — shows items, empty state
- Add reminder page — field inputs, submit
- Profile page — shows user info, logout

### Step 6.3 — Integration Tests
- Full login flow
- Add reminder end-to-end
- Edit reminder end-to-end
- Delete reminder end-to-end
- Navigation between tabs

---

## Phase 7 — CI/CD with Firebase

### Step 7.1 — GitHub Actions — Test & Build
- Trigger on every PR and push to `main`
- Steps: `flutter pub get` → `flutter analyze` → `flutter test` → `flutter build apk`

### Step 7.2 — Firebase App Distribution
- Auto-upload APK to Firebase App Distribution on merge to `main`
- Add testers / groups in Firebase console
- Testers get email with download link automatically

### Step 7.3 — Versioning
- Auto-increment build number using `BUILD_NUMBER` from GitHub Actions
- Tag release in git on successful deploy

### Step 7.4 — Fastlane (Optional — for Play Store / App Store)
- Setup `Fastfile` for Android + iOS
- Automate screenshots, metadata upload
- Deploy to Play Store internal track on `release` branch

---

## Execution Order

```
Phase 1 (Reminders)
    → Phase 2 (Auth completion)
        → Phase 3 (Bottom Nav + UI Shell)
            → Phase 4 (Firebase)
                → Phase 5 (Maps)
                    → Phase 6 (Tests)
                        → Phase 7 (CI/CD)
```

---

Ready to start **Phase 1, Step 1.1** — Reminder Domain Layer?


Yes! Here are things you can add purely as **Flutter/Dart learning** opportunities:

---

## Flutter-Specific Learning Additions

### State Management Deep Dive
- **Riverpod** — try one feature with Riverpod vs BLoC (compare both)
- **MobX** — understand reactive state vs event-driven

### Navigation
- **Deep links** — open app from a URL (`reminders://app/reminder/123`)
- **Dynamic links** — Firebase Dynamic Links for password reset email tap → opens app

### Animations
- **Hero animations** — reminder card expands into detail page
- **Lottie animations** — empty state, loading, success animations
- **AnimatedList** — animate reminder add/remove in list
- **Shimmer loading** — skeleton screens while fetching

### Local Data & Offline
- **Hive or Isar** — cache reminders locally, work offline
- **Connectivity plus** — detect offline, show banner, sync when back online
- **Optimistic UI** — update UI instantly before API confirms

### Platform Features
- **Biometric auth** — fingerprint / Face ID lock on app open
- **Local notifications** — schedule reminder alerts without FCM
- **Widgets (Home Screen)** — show upcoming reminders on Android/iOS home screen
- **Share** — share a reminder via system share sheet
- **Haptic feedback** — vibrate on swipe delete, on toggle complete

### UI & Theming
- **Material 3** — full M3 design with dynamic color (monet theming)
- **Custom painter** — draw charts on Home tab (reminders by day)
- **Slivers** — collapsible app bar on reminder list
- **Responsive layout** — tablet vs phone layout with `LayoutBuilder`

### Dart Language
- **Isolates** — heavy JSON parsing off the main thread
- **Streams** — real-time reminder updates (WebSocket or polling)
- **Extensions** — build your own useful extensions on `DateTime`, `String`
- **Generics** — make reusable `ApiResponse<T>` wrapper

### Architecture
- **Feature-first vs Layer-first** — your project is layer-first inside each feature, good to understand why
- **Multiple flavors** — `dev`, `staging`, `prod` environments with different Firebase projects
- **Code generation** — you already use Freezed/build_runner, add `injectable` for DI generation

### Testing (Learning angle)
- **Golden tests** — screenshot testing, compare UI pixel by pixel
- **Mocktail vs Mockito** — try both mock libraries
- **BDD style tests** — `given / when / then` pattern with `flutter_gherkin`

### DevTools
- **Flutter DevTools** — performance profiling, widget inspector, memory
- **Dart Observatory** — CPU profiling
- **Custom logging** — structured logs with `talker` package

---

## Top 5 I'd Recommend for Learning Value

| Priority | Feature | Why |
|----------|---------|-----|
| 1 | **Offline support (Hive + connectivity)** | Core real-world skill |
| 2 | **Hero + AnimatedList animations** | Makes Flutter feel "Flutter" |
| 3 | **App flavors (dev/staging/prod)** | Every professional project needs this |
| 4 | **Biometric auth** | Platform channel exposure |
| 5 | **Home screen widget** | Advanced platform integration |

---

Want to add any of these into the roadmap?

EXTRA:
Sharing of reminders via system share sheet is a great idea! You can add a "Share" button on the Reminder Detail Page that allows users to share the reminder's title, description, and date/time through other apps (like messaging apps, email, etc.). This can be implemented using the `share_plus` package in Flutter.
Deep and dynamic link for above
Grid view and staggered view for reminders list (optional)
how to implement api with mock api if api is not ready yet
video or youtube tutorial links for each step (optional)
calendare view things 
graphs for date vs reminders count (optional)
cancel api call if user navigates away from the page (optional)
need to store push notification in remote config or firbase stogae and nee to show as bell here in app
