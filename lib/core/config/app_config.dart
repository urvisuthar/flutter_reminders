class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'sit');
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://phplaravel-1022765-6487328.cloudwaysapps.com/api',
  );
  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Reminders SIT',
  );

  static bool get isSIT => env == 'sit';
  static bool get isUAT => env == 'uat';
  static bool get isProd => env == 'prod';
  static bool get isDebugLoggingEnabled => !isProd;
}
