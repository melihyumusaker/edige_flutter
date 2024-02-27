import 'package:edige/screens/teacherPages/TeacherCircularPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class TeacherController extends GetxController {
  final teacherEmailController = TextEditingController();
  final teacherPasswordController = TextEditingController();
  var teacherId = 0.obs;
  var token = "".obs;
  var refreshToken = "".obs;
  var user_id = "".obs;
  var teacherInfo;

  var studentsList = <Map<String, dynamic>>[].obs;
  var filteredStudentsList = <Map<String, dynamic>>[].obs;

  // Arama işlevselliği için bir fonksiyon
  void filterStudents(String query) {
    if (query.isEmpty) {
      filteredStudentsList.assignAll(studentsList);
    } else {
      var filtered = studentsList.where((student) {
        var name = student['user']['name'].toLowerCase();
        var surname = student['user']['surname'].toLowerCase();
        var email = student['user']['email'].toLowerCase();
        return name.contains(query.toLowerCase()) ||
            surname.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
      filteredStudentsList.assignAll(filtered);
    }
  }

  // Login module
  Future<void> teacherLogin() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signInEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': teacherEmailController.text,
        'password': teacherPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('TeacherLogin method çalıştı');
      final parsedResponse = jsonDecode(response.body);

      token.value = parsedResponse['token'];
      refreshToken.value = parsedResponse['refreshToken'];

      var tokenPayload = getTokenPayload(parsedResponse['token']);
      if (tokenPayload.length % 4 > 0) {
        tokenPayload += '=' * (4 - tokenPayload.length % 4);
      }
      final decodedPayload =
          jsonDecode(utf8.decode(base64Url.decode(tokenPayload)));

      final userId = decodedPayload['user_id'].toString();

      Get.find<TeacherController>().user_id.value = userId;
      print('Teacherin User ID: $user_id');
      print('Teacherin token : $token');
      Get.off(() => const TeacherCircularPage());
    } else {
      print('Login method çalışamadı');
      Get.dialog(
        AlertDialog(
            title: const Text("Giriş Başarısız"),
            content: const Text('Kullanıcı adı veya şifre hatalı.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back(); // Dialogu kapat
                },
                child: const Text('Tamam'),
              ),
            ]),
      );
    }
  }

  String getTokenPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    return payload;
  }

  Future<void> getTeacherIdByUserId(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getTeacherIdByUserId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü getStudentIdByUserId method çalıştı");
      final parsedResponse = int.tryParse(response.body);
      if (parsedResponse != null) {
        teacherId.value = parsedResponse;
      } else {
        teacherId.value = 0;
      }
    } else {
      print("getTeacherIdByUserId'de problem oldu");
      teacherId.value = 0;
    }
    print(teacherId.value);
  }

  Future<void> showStudents() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.showStudents}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("showStudents çalıştı");
      final List<dynamic> fetchedStudentsList = json.decode(response.body);
      studentsList.assignAll(
          fetchedStudentsList.map((e) => e as Map<String, dynamic>).toList());
      filteredStudentsList.assignAll(studentsList);
    } else {
      print('Error fetching students: ${response.statusCode}');
    }
  }

  // Teacher info endpoint
  Future<void> getTeacherInfo() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getTeacherInfo}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("getTeacherInfo çalıştı");
      teacherInfo = json.decode(response.body);
    } else {
      print('Error fetching teacher info: ${response.statusCode}');
    }
  }

  //Teacher's about and enneagram_result update endpointi
  Future<void> updateTeacherEnneagramTypeAndAbout(
      String about, String enneagramResult) async {
    final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.updateTeacherEnneagramTypeAndAbout}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'about': about,
          'enneagram_result': enneagramResult,
          'is_enneagram_test_solved': 1,
        }));

    if (response.statusCode == 200) {
      print("updateTeacherEnneagramTypeAndAbout çalıştı");
    } else {
      print('Error fetching teacher info: ${response.statusCode}');
    }
  }
}
