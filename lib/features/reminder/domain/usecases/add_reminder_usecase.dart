import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:fpdart/src/either.dart';

import '../repositories/reminder_repository.dart';

class AddReminderUsecase implements Usecase<ReminderEntity, AddReminderParams> {
  final ReminderRepository reminderRepository;

  AddReminderUsecase(this.reminderRepository);

  @override
  Future<Either<Failure, ReminderEntity>> call(AddReminderParams params) {
    return reminderRepository.addReminder(
      title: params.title,
      description: params.description,
      reminderDate: params.reminderDate,
      reminderTime: params.reminderTime,
      images: params.images,
    );
  }
}

class AddReminderParams {
  final String title;
  final String description;
  final String reminderDate;
  final String reminderTime;
  final List<File> images;

  AddReminderParams({
    required this.title,
    required this.description,
    required this.reminderDate,
    required this.reminderTime,
    required this.images,
  });
}
