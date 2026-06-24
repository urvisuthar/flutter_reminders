import 'package:equatable/equatable.dart';
import 'package:flutter_reminders/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccessType, Params>{
  Future<Either<Failure,SuccessType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}