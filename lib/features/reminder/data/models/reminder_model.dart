import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/reminder/data/models/reminder_image_model.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
abstract class ReminderModel with _$ReminderModel {
  const ReminderModel._();

  const factory ReminderModel({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'reminder_date') required String reminderDate,
    @JsonKey(name: 'reminder_time') required String reminderTime,
    required List<ReminderImageModel> images,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ReminderModel;

  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);

  ReminderEntity toEntity() => ReminderEntity(
    id: id,
    title: title,
    description: description,
    reminderDate: reminderDate,
    reminderTime: reminderTime,
    images: images.map((e) => e.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
