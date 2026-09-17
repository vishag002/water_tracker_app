import 'package:intl/intl.dart';

class GeneralService {
  static String formatWater(int ml) {
    if (ml >= 1000) {
      return "${(ml / 1000).toStringAsFixed(1)} L";
    }
    return "$ml ml";
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String formatGoal(double liters) {
    return '${liters.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '')} L';
  }
}
