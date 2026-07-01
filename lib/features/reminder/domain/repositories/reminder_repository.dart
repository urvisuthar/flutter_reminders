import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminders_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ReminderRepository {
  Future<Either<Failure, ReminderEntity>> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  });

  Future<Either<Failure, RemindersEntity>> getReminders({
    required int page,
    required int limit,
    String? search,
    String? date,
  });

  Future<Either<Failure, ReminderEntity>> getReminderById({required int id});

  Future<Either<Failure, ReminderEntity>> updateReminder({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
    required List<int> deletedImageIds,
  });

  Future<Either<Failure, void>> deleteReminder({required int id});
}
