// ignore_for_file: file_names

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
      int student_id,
      String lesson_name,
      String day,
      String lesson_start_hour,
      String lesson_end_hour) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createWeeklyProgram}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "student_id": student_id,
        "lesson_name": lesson_name,
        "day": day,
        "lesson_start_hour": lesson_start_hour,
        "lesson_end_hour": lesson_end_hour
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
      int student_id,
      String lesson_name,
      String day,
      String lesson_start_hour,
      String lesson_end_hour) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateWeeklyProgram}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "student_id": student_id,
        "lesson_name": lesson_name,
        "day": day,
        "lesson_start_hour": lesson_start_hour,
        "lesson_end_hour": lesson_end_hour
      }),
    );

    if (response.statusCode == 200) {
      print('updateWeeklyProgram çalıştı 200 döndü');
    } else {
      print('updateWeeklyProgram çalışmadı   ${response.statusCode}');
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
      // ignore: use_build_context_synchronously
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
                child: Text('Tamam'),
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
            title: Text('Hata'),
            content: Text(
                'Program silinemedi. Hata kodu: ${response.statusCode}'),
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
