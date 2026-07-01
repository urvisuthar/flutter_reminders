import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/reminder/data/models/pagination_model.dart';
import 'package:flutter_reminders/features/reminder/data/models/reminder_model.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminders_entity.dart';

part 'reminders_model.freezed.dart';
part 'reminders_model.g.dart';

@freezed
abstract class RemindersModel with _$RemindersModel {
  const RemindersModel._();

  const factory RemindersModel({
    required List<ReminderModel> reminders,
    required PaginationModel pagination,
  }) = _RemindersModel;

  factory RemindersModel.fromJson(Map<String, dynamic> json) =>
      _$RemindersModelFromJson(json);

  RemindersEntity toEntity() => RemindersEntity(
    reminders: reminders.map((e) => e.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );
}
