// ignore_for_file: file_names, use_build_context_synchronously, duplicate_ignore, avoid_print, non_constant_identifier_names

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeeklyProgramController extends GetxController {
  final lessons = <String>[].obs;
  final lessonStartHours = <String>[].obs;
  final lessonEndHours = <String>[].obs;
  final day = <String>[].obs;

  final weeklyProgram = <String, List<dynamic>>{}.obs;

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
      print('fetchWeeklyProgramByStudentId çalışmadı   ${response.statusCode}');
    }
  }

  Future<void> createWeeklyProgram(
      BuildContext context,
      int studentId,
      String lessonName,
      String day,
      String lessonStartHour,
      String lessonEndHour) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createWeeklyProgram}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "student_id": studentId,
        "lesson_name": lessonName,
        "day": day,
        "lesson_start_hour": lessonStartHour,
        "lesson_end_hour": lessonEndHour
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Ders programı başarıyla oluşturuldu.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
      print('createWeeklyProgram çalıştı 200 döndü');
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Hata'),
            content: Text(
                'Ders programı oluşturulurken bir hata oluştu. Hata kodu: ${response.statusCode}'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
      print('createWeeklyProgram çalışmadı   ${response.statusCode}');
    }
  }

  Future<void> updateWeeklyProgram(
    BuildContext context,
    int weeklyProgramId,
    String lessonName,
    String lessonStartHour,
    String lessonEndHour,
    String day
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateWeeklyProgram}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "weekly_program_id": weeklyProgramId,
        "lesson_end_hour": lessonEndHour,
        "lesson_start_hour": lessonStartHour,
        "lesson_name": lessonName,
        "day" : day
      }),
    );

    if (response.statusCode == 200) {
      print('updateWeeklyProgram çalıştı 200 döndü');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Başarılı'),
          content: const Text('Ders programı başarıyla güncellendi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      print('updateWeeklyProgram çalışmadı   ${response.statusCode}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hata'),
          content: const Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> deleteWeeklyProgram(
      BuildContext context, weeklyProgramId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteWeeklyProgram}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
      },
      body: jsonEncode({"weekly_program_id": weeklyProgramId}),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Program başarıyla silindi.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
      print('deleteWeeklyProgram çalıştı 200 döndü');
    } else {
      print('deleteWeeklyProgram çalışmadı   ${response.statusCode}');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Hata'),
            content:
                Text('Program silinemedi. Hata kodu: ${response.statusCode}'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }
}
