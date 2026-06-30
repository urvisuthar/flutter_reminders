import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_reminders/core/error/exceptions.dart';
import 'package:flutter_reminders/core/network/api_endpoints.dart';
import 'package:flutter_reminders/core/network/dio_client.dart';
import 'package:flutter_reminders/features/reminder/data/models/reminder_model.dart';

abstract interface class ReminderRemoteDataSource {
  Future<ReminderModel> addReminder({
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<File> images,
  });
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
}
