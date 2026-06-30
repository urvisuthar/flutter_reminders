import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/add_reminder_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_event.dart';

part 'reminder_state.dart';

part 'reminder_bloc.freezed.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  AddReminderUsecase _addReminderUsecase;

  ReminderBloc({required AddReminderUsecase addReminderUsecase})
    : _addReminderUsecase = addReminderUsecase,
      super(const ReminderState.initial()) {
    on<_AddReminder>(_onAddReminder);
  }

  Future<void> _onAddReminder(
    _AddReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderState.loading());
    final result = await _addReminderUsecase(
      AddReminderParams(
        title: event.title,
        description: event.description,
        reminderDate: event.reminderDate,
        reminderTime: event.reminderTime,
        images: event.images,
      ),
    );
    result.fold(
      (failure) => emit(ReminderState.failure(failure.message)),
      (reminder) => emit(ReminderState.success(reminder)),
    );
  }
}
