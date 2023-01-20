import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String hourMinAndSeconds(String localeName) {
    return DateFormat.Hms(localeName).format(this);
  }

  String hourAndMin(String localeName) {
    return DateFormat.Hm(localeName).format(this);
  }

  String dayMonthYear(String localeName) {
    return DateFormat.yMMMMd(localeName).format(this);
  }

  String dayMonthYearHourMinute(String localeName) {
    return DateFormat.yMMMMd(localeName).format(this) +
        ', ' +
        DateFormat.Hm(localeName).format(this);
  }
}

extension DateOnlyCompare on DateTime {
  ///Compares only year, month and day components
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateUtils on DateTime {
  static int get timestamp => DateTime.now().millisecondsSinceEpoch;

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}

