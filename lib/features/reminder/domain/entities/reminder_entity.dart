import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_image_entity.dart';

part 'reminder_entity.freezed.dart';

@freezed
abstract class ReminderEntity with _$ReminderEntity {
  const factory ReminderEntity({
    required int id,
    required String title,
    required String description,
    required String reminderDate,
    required String reminderTime,
    required List<ReminderImageEntity> images,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReminderEntity;
}
