import 'package:intl/intl.dart';

class DateTimeUtils {
  // Display formats (shown to user)
  static const String _displayDateFormat = 'dd-MM-yyyy';
  static const String _displayTimeFormat = 'hh:mm a';

  // API formats (sent to server)
  static const String _apiDateFormat = 'yyyy-MM-dd';
  static const String _apiTimeFormat = 'HH:mm:ss';

  static String toDisplayDate(DateTime date) =>
      DateFormat(_displayDateFormat).format(date);

  static String toDisplayTime(DateTime dateTime) =>
      DateFormat(_displayTimeFormat).format(dateTime);

  static String toApiDate(DateTime date) =>
      DateFormat(_apiDateFormat).format(date);

  static String toApiTime(int hour, int minute) {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm:00';
  }

  static String apiDateToDisplay(String apiDate) =>
      toDisplayDate(DateFormat(_apiDateFormat).parse(apiDate));

  static String apiTimeToDisplay(String apiTime) =>
      toDisplayTime(DateFormat(_apiTimeFormat).parse(apiTime));
}
