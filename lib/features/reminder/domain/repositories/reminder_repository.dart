import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ReminderRepository {
  Future<Either<Failure, ReminderEntity>> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  });
}
