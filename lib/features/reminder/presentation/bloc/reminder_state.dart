part of 'reminder_bloc.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState.initial() = _Initial;
  const factory ReminderState.loading() = _Loading;
  const factory ReminderState.addSuccess(ReminderEntity reminder) = _AddSuccess;
  const factory ReminderState.failure(String message) = _Failure;
  const factory ReminderState.remindersLoaded(RemindersEntity reminders) =
      _RemindersLoaded;
  const factory ReminderState.reminderLoaded(ReminderEntity reminder) =
      _ReminderLoaded;
  const factory ReminderState.updateSuccess(ReminderEntity reminder) =
      _UpdateSuccess;
  const factory ReminderState.deleteSuccess() = _DeleteSuccess;
}
