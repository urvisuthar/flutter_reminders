import 'dart:io';

import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/features/reminder/data/datasource/reminder_remote_data_source.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminders_entity.dart';
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

  @override
  Future<Either<Failure, void>> deleteReminder({required int id}) async {
    try {
      await reminderRemoteDataSource.deleteReminder(id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReminderEntity>> getReminderById({
    required int id,
  }) async {
    try {
      final reminderModel = await reminderRemoteDataSource.getReminderById(
        id: id,
      );
      return Right(reminderModel.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RemindersEntity>> getReminders({
    required int page,
    required int limit,
    String? search,
    String? date,
  }) async {
    try {
      final remindersEntity = await reminderRemoteDataSource.getReminders(
        page: page,
        limit: limit,
        search: search,
        date: date,
      );
      return Right(remindersEntity);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReminderEntity>> updateReminder({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
    required List<int> deletedImageIds,
  }) async {
    try {
      final reminderModel = await reminderRemoteDataSource.updateReminder(
        id: id,
        title: title,
        description: description,
        reminderDate: reminderDate,
        reminderTime: reminderTime,
        images: images,
        deletedImageIds: deletedImageIds,
      );
      return Right(reminderModel.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
