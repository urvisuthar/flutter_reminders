# ──────────────────────────────────────────
#  Flutter Reminders — Environment Commands
# ──────────────────────────────────────────

# RUN
run-sit:
	flutter run --dart-define-from-file=env/sit.json

run-uat:
	flutter run --dart-define-from-file=env/uat.json

run-prod:
	flutter run --dart-define-from-file=env/prod.json --release

# BUILD APK
build-sit:
	flutter build apk --dart-define-from-file=env/sit.json

build-uat:
	flutter build apk --dart-define-from-file=env/uat.json

build-prod:
	flutter build apk --dart-define-from-file=env/prod.json --release

# BUILD APP BUNDLE (Play Store)
bundle-prod:
	flutter build appbundle --dart-define-from-file=env/prod.json --release

# BUILD IPA (iOS)
ipa-prod:
	flutter build ipa --dart-define-from-file=env/prod.json --release

# COMMON
clean:
	flutter clean

get:
	flutter pub get

refresh: clean get

# run command "choco install make" to install Make on Windows, then you can use the above commands in your terminal to manage your Flutter environment configurations.