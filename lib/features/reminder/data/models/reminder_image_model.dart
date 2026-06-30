import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_image_entity.dart';

part 'reminder_image_model.freezed.dart';
part 'reminder_image_model.g.dart';

@freezed
abstract class ReminderImageModel with _$ReminderImageModel {
  const ReminderImageModel._();

  const factory ReminderImageModel({
    required int id,
    @JsonKey(name: 'image_url') required String imageUrl,
  }) = _ReminderImageModel;

  factory ReminderImageModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderImageModelFromJson(json);

  ReminderImageEntity toEntity() =>
      ReminderImageEntity(id: id, imageUrl: imageUrl);
}
