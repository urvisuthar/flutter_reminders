import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_image_entity.freezed.dart';

@freezed
abstract class ReminderImageEntity with _$ReminderImageEntity {
  const factory ReminderImageEntity({
    required int id,
    required String imageUrl,
  }) = _ReminderImageEntity;
}
