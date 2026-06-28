import 'package:flutter_reminders/core/usecases/usecase.dart';

import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  const CheckAuthStatusUseCase(this.repository);

  Future<bool> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  const LogoutUseCase(this.repository);
  Future<void> call() => repository.logout();
}
