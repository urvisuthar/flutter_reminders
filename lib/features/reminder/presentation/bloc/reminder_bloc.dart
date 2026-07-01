import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/add_reminder_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/delete_reminder_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/get_reminder_by_id_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/get_reminders_usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/usecases/update_reminder_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/reminders_entity.dart';

part 'reminder_event.dart';

part 'reminder_state.dart';

part 'reminder_bloc.freezed.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final AddReminderUsecase _addReminderUsecase;
  final GetRemindersUsecase _getRemindersUsecase;
  final GetReminderByIdUsecase _getReminderByIdUsecase;
  final UpdateReminderUsecase _updateReminderUsecase;
  final DeleteReminderUsecase _deleteReminderUsecase;

  ReminderBloc({
    required AddReminderUsecase addReminderUsecase,
    required GetRemindersUsecase getRemindersUsecase,
    required GetReminderByIdUsecase getReminderByIdUsecase,
    required UpdateReminderUsecase updateReminderUsecase,
    required DeleteReminderUsecase deleteReminderUsecase,
  }) : _addReminderUsecase = addReminderUsecase,
       _getRemindersUsecase = getRemindersUsecase,
       _getReminderByIdUsecase = getReminderByIdUsecase,
       _updateReminderUsecase = updateReminderUsecase,
       _deleteReminderUsecase = deleteReminderUsecase,
       super(const ReminderState.initial()) {
    on<_AddReminder>(_onAddReminder);
    on<_GetReminders>(_onGetReminders);
    on<_GetReminderById>(_onGetReminderById);
    on<_UpdateReminder>(_onUpdateReminder);
    on<_DeleteReminder>(_onDeleteReminder);
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
      (reminder) => emit(ReminderState.addSuccess(reminder)),
    );
  }

  Future<void> _onGetReminders(
    _GetReminders event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderState.loading());
    final result = await _getRemindersUsecase(
      GetRemindersParams(
        page: event.page,
        limit: event.limit,
        search: event.search,
        date: event.date,
      ),
    );
    result.fold(
      (failure) => emit(ReminderState.failure(failure.message)),
      (reminders) => emit(ReminderState.remindersLoaded(reminders)),
    );
  }

  Future<void> _onGetReminderById(
    _GetReminderById event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderState.loading());
    final result = await _getReminderByIdUsecase(
      GetReminderByIdParams(id: event.id),
    );
    result.fold(
      (failure) => emit(ReminderState.failure(failure.message)),
      (reminder) => emit(ReminderState.reminderLoaded(reminder)),
    );
  }

  Future<void> _onUpdateReminder(
    _UpdateReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderState.loading());
    final result = await _updateReminderUsecase(
      UpdateReminderParams(
        id: event.id,
        title: event.title,
        description: event.description,
        reminderDate: event.reminderDate,
        reminderTime: event.reminderTime,
        images: event.images,
        deletedImageIds: event.deletedImageIds,
      ),
    );
    result.fold(
      (failure) => emit(ReminderState.failure(failure.message)),
      (reminder) => emit(ReminderState.updateSuccess(reminder)),
    );
  }

  Future<void> _onDeleteReminder(
    _DeleteReminder event,
    Emitter<ReminderState> emit,
  ) async {
    emit(const ReminderState.loading());
    final result = await _deleteReminderUsecase(
      DeleteReminderParams(id: event.id),
    );
    result.fold(
      (failure) => emit(ReminderState.failure(failure.message)),
      (_) => emit(const ReminderState.deleteSuccess()),
    );
  }
}
