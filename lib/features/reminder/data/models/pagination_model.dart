import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/pagination_entity.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
abstract class PaginationModel with _$PaginationModel {
  const PaginationModel._();

  const factory PaginationModel({
    required int total,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  PaginationEntity toEntity() => PaginationEntity(
    total: total,
    perPage: perPage,
    currentPage: currentPage,
    lastPage: lastPage,
  );
}
