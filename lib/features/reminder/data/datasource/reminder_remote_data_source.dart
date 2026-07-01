import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/features/reminder/data/models/reminder_model.dart';
import 'package:flutter_reminders/features/reminder/data/models/reminders_model.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminders_entity.dart';

abstract interface class ReminderRemoteDataSource {
  Future<ReminderModel> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  });

  Future<RemindersEntity> getReminders({
    int page = 1,
    int limit = 10,
    String? search,
    String? date,
  });

  Future<ReminderModel> getReminderById({required int id});

  Future<ReminderModel> updateReminder({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
    required List<int> deletedImageIds,
  });

  Future<void> deleteReminder({required int id});
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final DioClient dioClient;

  ReminderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ReminderModel> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'reminder_date': reminderDate,
        'reminder_time': reminderTime,
        if (images.isNotEmpty)
          'images[]': images
              .map((f) => MultipartFile.fromFileSync(f.path))
              .toList(),
      });
      final response = await dioClient.dio.post(
        ApiEndpoints.addReminder,
        data: formData,
      );
      return ReminderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<void> deleteReminder({required int id}) async {
    try {
      await dioClient.dio.delete('${ApiEndpoints.deleteReminder}/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<ReminderModel> getReminderById({required int id}) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiEndpoints.getReminder}/$id',
      );
      return ReminderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<RemindersEntity> getReminders({
    int page = 1,
    int limit = 10,
    String? search,
    String? date,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiEndpoints.getAllReminders,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          if (date != null && date.isNotEmpty) 'date': date,
        },
      );

      return RemindersModel.fromJson(response.data['data']).toEntity();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<ReminderModel> updateReminder({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
    required List<int> deletedImageIds,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'reminder_date': reminderDate,
        'reminder_time': reminderTime,
        if (images.isNotEmpty)
          'images[]': images
              .map((f) => MultipartFile.fromFileSync(f.path))
              .toList(),
        if (deletedImageIds.isNotEmpty) 'deleted_image_ids[]': deletedImageIds,
      });
      final response = await dioClient.dio.put(
        '${ApiEndpoints.updateReminder}/$id',
        data: formData,
      );
      return ReminderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}
