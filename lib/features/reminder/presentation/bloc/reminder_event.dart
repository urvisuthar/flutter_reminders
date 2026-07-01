part of 'reminder_bloc.dart';

@freezed
class ReminderEvent with _$ReminderEvent {
  const factory ReminderEvent.started() = _Started;
  const factory ReminderEvent.addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  }) = _AddReminder;
  const factory ReminderEvent.getReminders({
    @Default(1) int page,
    @Default(10) int limit,
    String? search,
    String? date,
  }) = _GetReminders;

  const factory ReminderEvent.getReminderById({required int id}) =
      _GetReminderById;

  const factory ReminderEvent.updateReminder({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
    required List<int> deletedImageIds,
  }) = _UpdateReminder;

  const factory ReminderEvent.deleteReminder({required int id}) =
      _DeleteReminder;
}
