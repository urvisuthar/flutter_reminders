import 'package:flutter_reminders/core/error/failures.dart';
import 'package:flutter_reminders/core/usecases/usecase.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminders_entity.dart';
import 'package:fpdart/src/either.dart';

import '../repositories/reminder_repository.dart';

class GetRemindersUsecase
    implements Usecase<RemindersEntity, GetRemindersParams> {
  final ReminderRepository reminderRepository;

  GetRemindersUsecase(this.reminderRepository);

  @override
  Future<Either<Failure, RemindersEntity>> call(GetRemindersParams params) {
    return reminderRepository.getReminders(
      page: params.page,
      limit: params.limit,
      search: params.search,
      date: params.date,
    );
  }
}

class GetRemindersParams {
  final int page;
  final int limit;
  final String? search;
  final String? date;

  GetRemindersParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.date,
  });
}
