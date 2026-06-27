import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/settings/settings_state.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LocalStorage _localStorage;

  SettingsCubit(this._localStorage)
      : super(SettingsState(
    themeMode: ThemeMode.values.byName(_localStorage.getTheme()),
    locale: Locale(_localStorage.getLocale()),
  ));

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _localStorage.saveTheme(next.name);
    emit(state.copyWith(themeMode: next));
  }

  void changeLocale(Locale locale) {
    _localStorage.saveLocale(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }
}