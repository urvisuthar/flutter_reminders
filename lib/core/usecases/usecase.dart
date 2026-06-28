import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_reminders/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

part 'usecase.freezed.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

@freezed
class NoParams with _$NoParams {
  const factory NoParams() = _NoParams;
}
