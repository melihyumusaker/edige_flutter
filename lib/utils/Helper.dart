// ignore_for_file: file_names

import 'package:intl/intl.dart';

class Helper {
  static String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return 'Geçersiz tarih';
    }
  }
  static String formatTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse('1970-01-01T$time');
      final DateFormat formatter = DateFormat('HH:mm');
      return formatter.format(parsedTime);
    } catch (e) {
      return 'Geçersiz saat';
    }
  }
}
