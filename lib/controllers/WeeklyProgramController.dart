import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeeklyProgramController extends GetxController {
  final lessons = <String>[].obs;
  final lessonStartHours = <String>[].obs;
  final lessonEndHours = <String>[].obs;
  final day = <String>[].obs;

  final weeklyProgram = <String, List<dynamic>>{}.obs;
/*
  Future<void> fetchWeeklyProgramByStudentId(int student_id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getWeeklyProgramByStudentId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': Get.find<StudentController>().studentId.value,
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

      final List<String> dayList =
          data.map((myDays) => myDays['day'].toString()).toList();
      day.value = dayList;
    } else {
      lessons.clear();
      print('fetchWeeklyProgramByStudentId çalışmadı');
    }
  }*/
Future<void> fetchWeeklyProgramByStudentId(int student_id) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getWeeklyProgramByStudentId}'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'student_id': Get.find<StudentController>().studentId.value,
    }),
  );

  if (response.statusCode == 200) {
    print('fetchWeeklyProgramByStudentId çalıştı 200 döndü');
    final List<dynamic> data = json.decode(response.body);

    // Günlere göre ayrı listeler oluştur
    Map<String, List<dynamic>> updatedWeeklyProgram = {};

    for (var lesson in data) {
      String day = lesson['day'];
      if (!updatedWeeklyProgram.containsKey(day)) {
        updatedWeeklyProgram[day] = [];
      }
      updatedWeeklyProgram[day]!.add(lesson);
    }

    weeklyProgram.value = updatedWeeklyProgram;
  } else {
    weeklyProgram.clear();
    print('fetchWeeklyProgramByStudentId çalışmadı');
  }
}

}
