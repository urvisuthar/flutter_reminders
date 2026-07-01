import 'package:flutter_reminders/features/reminder/domain/entities/pagination_entity.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminders_entity.freezed.dart';

@freezed
abstract class RemindersEntity with _$RemindersEntity {
  const factory RemindersEntity({
    required List<ReminderEntity> reminders,
    required PaginationEntity pagination,
  }) = _RemindersEntity;
}
