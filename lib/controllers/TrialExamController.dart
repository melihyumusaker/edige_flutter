import 'dart:convert';

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TrialExamController extends GetxController {

  RxList<Map<String, dynamic>> studentTrialExams = <Map<String, dynamic>>[].obs;
   RxMap selectedExamDetail = {}.obs;

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
        // Başarılı bir şekilde veri çekildiyse
        List<dynamic> responseData = jsonDecode(response.body);
        studentTrialExams.assignAll(responseData.cast<Map<String, dynamic>>());
        print("getStudentTrialExams çalıştı");
      } else {
        // Sunucudan hata döndüyse
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentTrialExams Exception: $e");
    }
  }
}
