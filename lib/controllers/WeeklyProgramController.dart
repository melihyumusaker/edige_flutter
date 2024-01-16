import 'package:edige/config/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeeklyProgramController extends GetxController {
  final lessons = <String>[].obs;
  final lessonStartHours = <String>[].obs;
  final lessonEndHours = <String>[].obs;
  final day = <DateTime>[].obs;

  DateTime convertToDate(String date) {
    return DateTime.parse(date);
  }

  Future<void> fetchWeeklyProgramByStudentId(int student_id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getWeeklyProgramByStudentId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': 7,
      }),
    );

    if (response.statusCode == 200) {
      print('fetchWeeklyProgramByStudentId çalıştı 200 döndü');
      final List<dynamic> data = json.decode(response.body);

      final List<String> lessonNames =
          data.map((lesson) => lesson['lesson_name'].toString()).toList();
      lessons.value = lessonNames;

      final List<String> lessonStartHoursNames = data
          .map((lessonStartHour) =>
              lessonStartHour['lesson_start_hour'].toString())
          .toList();
      lessonStartHours.value = lessonStartHoursNames;

      final List<String> lessonEndHoursNames = data
          .map((lessonEndHour) => lessonEndHour['lesson_end_hour'].toString())
          .toList();
      lessonEndHours.value = lessonEndHoursNames;

      final List<DateTime> dayList = data
          .map((myDays) => convertToDate(myDays['day'].toString()))
          .toList();
      day.value = dayList;
    } else {
      lessons.clear();
      print('fetchWeeklyProgramByStudentId çalışmadı');
    }
  }
}
