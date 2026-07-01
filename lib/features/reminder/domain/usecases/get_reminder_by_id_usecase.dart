import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:fpdart/src/either.dart';

import '../repositories/reminder_repository.dart';

class GetReminderByIdUsecase
    implements Usecase<ReminderEntity, GetReminderByIdParams> {
  final ReminderRepository reminderRepository;

  GetReminderByIdUsecase(this.reminderRepository);

  @override
  Future<Either<Failure, ReminderEntity>> call(
    GetReminderByIdParams params,
  ) {
    return reminderRepository.getReminderById(id: params.id);
  }
}

class GetReminderByIdParams {
  final int id;

  GetReminderByIdParams({required this.id});
}
