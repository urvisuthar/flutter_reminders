import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_entity.freezed.dart';

@freezed
abstract class PaginationEntity with _$PaginationEntity {
  const factory PaginationEntity({
    required int total,
    required int perPage,
    required int currentPage,
    required int lastPage,
  }) = _PaginationEntity;
}
