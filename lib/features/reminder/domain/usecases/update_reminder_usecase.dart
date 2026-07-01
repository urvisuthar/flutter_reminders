import 'dart:io';

import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:fpdart/src/either.dart';

import '../repositories/reminder_repository.dart';

class UpdateReminderUsecase
    implements Usecase<ReminderEntity, UpdateReminderParams> {
  final ReminderRepository reminderRepository;

  UpdateReminderUsecase(this.reminderRepository);

  @override
  Future<Either<Failure, ReminderEntity>> call(UpdateReminderParams params) {
    return reminderRepository.updateReminder(
      id: params.id,
      title: params.title,
      description: params.description,
      reminderDate: params.reminderDate,
      reminderTime: params.reminderTime,
      images: params.images,
      deletedImageIds: params.deletedImageIds,
    );
  }
}

class UpdateReminderParams {
  final int id;
  final String title;
  final String description;
  final String reminderDate;
  final String reminderTime;
  final List<File> images;
  final List<int> deletedImageIds;

  UpdateReminderParams({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderDate,
    required this.reminderTime,
    required this.images,
    required this.deletedImageIds,
  });
}
