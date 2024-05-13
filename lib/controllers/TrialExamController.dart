// ignore_for_file: use_build_context_synchronously, avoid_print, file_names

import 'dart:convert';

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TrialExamController extends GetxController {
  RxList<Map<String, dynamic>> studentTrialExams = <Map<String, dynamic>>[].obs;
  RxMap selectedExamDetail = {}.obs;
  var unShownTrialExamNumber = 0.obs;

  Future<void> getStudentTrialExams() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentTrialExams}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        studentTrialExams.assignAll(responseData.cast<Map<String, dynamic>>());
        print("getStudentTrialExams çalıştı");
      } else if (response.statusCode == 204) {
        studentTrialExams.assignAll(<Map<String, dynamic>>[]);
        print("getStudentTrialExams çalişti, ancak veri bulunamadi.");
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print(" getStudentTrialExams Exception: $e");
    }
  }

  Future<void> deleteTrialExamByTeacher(
      int trialExamId, BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteTrialExam}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({"trial_exam_id": trialExamId}),
      );

      if (response.statusCode == 200) {
        print("deleteTrialExam çalıştı");
        // Başarılı olduğunda alert dialog göster
        showSuccessDialog();
      } else {
        print("deleteTrialExam Error: ${response.statusCode}");
        showErrorDialog("HTTP ${response.statusCode} Hatası");
      }
    } catch (e) {
      print(" deleteTrialExam Exception: $e");
      showErrorDialog(e.toString());
    }
  }

  Future<void> updateTrialExam({
    required int trialExamId,
    required String date,
    required double turkceTrue,
    required double turkceFalse,
    required double matTrue,
    required double matFalse,
    required double fenTrue,
    required double fenFalse,
    required double sosyalTrue,
    required double sosyalFalse,
    required String examName,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateTrialExam}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({
          'trial_exam_id': trialExamId,
          'date': date,
          'turkce_true': turkceTrue,
          'turkce_false': turkceFalse,
          'mat_true': matTrue,
          'mat_false': matFalse,
          'fen_true': fenTrue,
          'fen_false': fenFalse,
          'sosyal_true': sosyalTrue,
          'sosyal_false': sosyalFalse,
          'exam_name': examName,
        }),
      );

      if (response.statusCode == 200) {
        print("updateTrialExam çalıştı");
        showSuccessDialog();
      } else {
        print("updateTrialExam Error: ${response.statusCode}");
        showErrorDialog("HTTP ${response.statusCode} Hatası");
      }
    } catch (e) {
      print(" updateTrialExam Exception: $e");
      showErrorDialog(e.toString());
    }
  }

  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Başarılı'),
        content: const Text('İşlem başarıyla gerçekleştirildi.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String errorMessage) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hata'),
        content: Text('İşlem sırasında bir hata oluştu: $errorMessage'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Future<void> updateTrialExamIsShownValue(
      {required int trialExamId, required String token}) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.updateTrialExamIsShownValue}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'trial_exam_id': trialExamId}),
      );

      if (response.statusCode == 200) {
        print("updateTrialExamIsShownValue çalıştı");
        getStudentTrialExams();
      } else {
        print("updateTrialExamIsShownValue Error: ${response.statusCode}");
      }
    } catch (e) {
      print(" updateTrialExam Exception: $e");
      showErrorDialog(e.toString());
    }
  }

  Future<void> countUnshown(
      {required int studentId, required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.countUnshown}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        unShownTrialExamNumber.value = jsonDecode(response.body);
        print(unShownTrialExamNumber.value);
        print("countUnshown çalıştı");
      } else {
        print("countUnshown Error: ${response.statusCode}");
      }
    } catch (e) {
      print("CountUnshown Exception: $e");
    }
  }
}
