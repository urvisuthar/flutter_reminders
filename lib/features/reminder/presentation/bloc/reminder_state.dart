part of 'reminder_bloc.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState.initial() = _Initial;
  const factory ReminderState.loading() = _Loading;
  const factory ReminderState.success(ReminderEntity reminder) = _Success;
  const factory ReminderState.failure(String message) = _Failure;
}
