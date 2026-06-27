import 'package:flutter/cupertino.dart';
import 'package:flutter_reminders/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}