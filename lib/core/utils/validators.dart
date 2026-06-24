class Validators {
  //Email
  static final RegExp _emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  // Password
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}