import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:fpdart/src/either.dart';

import '../repositories/reminder_repository.dart';

class DeleteReminderUsecase implements Usecase<void, DeleteReminderParams> {
  final ReminderRepository reminderRepository;

  DeleteReminderUsecase(this.reminderRepository);

  @override
  Future<Either<Failure, void>> call(DeleteReminderParams params) {
    return reminderRepository.deleteReminder(id: params.id);
  }
}

class DeleteReminderParams {
  final int id;

  DeleteReminderParams({required this.id});
}
