import 'dart:io';

import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/reminder/data/datasource/reminder_remote_data_source.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/repositories/reminder_repository.dart';
import 'package:fpdart/src/either.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource reminderRemoteDataSource;

  ReminderRepositoryImpl(this.reminderRemoteDataSource);

  @override
  Future<Either<Failure, ReminderEntity>> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  }) async {
    try {
      final reminderModel = await reminderRemoteDataSource.addReminder(
        title: title,
        description: description,
        reminderDate: reminderDate,
        reminderTime: reminderTime,
        images: images,
      );
      return Right(reminderModel.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
