// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, file_names, unused_import

import 'package:edige/screens/QR/QRScanPage.dart';
import 'package:edige/screens/teacherPages/TeacherFirstEntry/TeacherCircularPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/AllHomeworksPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/DoneHomeworksPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/NotDoneHomeworksPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class TeacherController extends GetxController {
  final teacherEmailController = TextEditingController();
  final teacherPasswordController = TextEditingController();
  var isFetchingData = false.obs;
  var isLoading = true.obs;
  var teacherId = 0.obs;
  var token = "".obs;
  var refreshToken = "".obs;
  var user_id = "".obs;
  var teacherInfo;
  var role = "".obs;

  var studentsList = <Map<String, dynamic>>[].obs;
  var filteredStudentsList = <Map<String, dynamic>>[].obs;

  var studentsTrialExamResults = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> getAllStudentsCoursesList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> getStudentsDoneCoursesList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> getStudentsNotDoneCoursesList =
      <Map<String, dynamic>>[].obs;

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

  Future<void> clearStudentTrialExamResults() async {
    studentsTrialExamResults.clear();
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
      role.value = parsedResponse['role'];

      var tokenPayload = getTokenPayload(parsedResponse['token']);
      if (tokenPayload.length % 4 > 0) {
        tokenPayload += '=' * (4 - tokenPayload.length % 4);
      }
      final decodedPayload =
          jsonDecode(utf8.decode(base64Url.decode(tokenPayload)));

      final userId = decodedPayload['user_id'].toString();

      if (role.value == "TEACHER") {
        Get.find<TeacherController>().user_id.value = userId;
        Get.off(() => const TeacherCircularPage());
      } else if (role.value == "ADMIN") {
        Get.off(() => QRScanPage());
      } else {
        Get.dialog(loginUnsuccess());
      }
    } else {
      Get.dialog(loginUnsuccess());
    }
  }

  AlertDialog loginUnsuccess() {
    return AlertDialog(
        title: const Text("Giriş Başarısız"),
        content: const Text('Kullanıcı adı veya şifre hatalı.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back(); // Dialogu kapat
            },
            child: const Text('Tamam'),
          ),
        ]);
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

  Future<void> getStudentTrialExamsByTeacher(int studentId) async {
    final response = await http.post(
      Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.getStudentTrialExamsByTeacher}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': studentId,
      }),
    );

    if (response.statusCode == 200) {
      print("getStudentTrialExamsByTeacher çalıştı");

      final List<dynamic> trialExamResults = json.decode(response.body);
      // studentsTrialExamResults listesini güncelle
      studentsTrialExamResults.assignAll(
          trialExamResults.map((e) => e as Map<String, dynamic>).toList());
    } /*else if (response.statusCode == 204) {
      final List<dynamic> trialExamResults = json.decode(response.body);

      studentsTrialExamResults.assignAll(
          trialExamResults.map((e) => e as Map<String, dynamic>).toList());
    } */
    else {
      print(
          'Error fetching trial exam results: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> setStudentTrialExamResult({
    required int studentId,
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
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.setStudentTrialExamResult}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'student_id': studentId,
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
      print("setStudentTrialExamResult çalıştı kayıt başarılı");
      Get.snackbar(
        'Başarılı',
        'Kayıt başarılı',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 20.0),
      );
    } else {
      print('Error fetching trial exam results: ${response.statusCode}');
      Get.snackbar(
        'Hata',
        'Bir problem oluştu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 20.0),
      );
    }
  }

  Future<void> getAllStudentsCourses(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getAllStudentsCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'student_id': studentId
          //,
        }),
      );

      if (response.statusCode == 200) {
        print("getAllStudentsCourses çalıştı");

        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getAllStudentsCoursesList.assignAll(coursesList);

        Get.to(() => AllHomeworksPage(studentId: studentId),
            transition: Transition.rightToLeft);
      } else {
        print("Error: ${response.statusCode}");
        Get.snackbar(
          'Hata',
          'Bir problem oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 20.0),
        );
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getAllStudentsCourses Exception: $e");
    }
  }

  Future<void> getStudentsDoneCourse(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentsDoneCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        print("getStudentsDoneCourse çalıştı");

        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getStudentsDoneCoursesList.assignAll(coursesList);

        Get.to(() => const DoneHomeworksPage(),
            transition: Transition.rightToLeft);
      } else {
        print("Error: ${response.statusCode}");
        Get.snackbar(
          'Hata',
          'Bir problem oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 20.0),
        );
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsDoneCourse Exception: $e");
    }
  }

  Future<void> getStudentsNotDoneCourses(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentsNotDoneCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        print("getStudentsNotDoneCourses çalıştı");

        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getStudentsNotDoneCoursesList.assignAll(coursesList);

        Get.to(() => const NotDoneHomeworksPage(),
            transition: Transition.rightToLeft);
      } else {
        print("Error: ${response.statusCode}");
        Get.snackbar(
          'Hata',
          'Bir problem oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 20.0),
        );
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsNotDoneCourses Exception: $e");
    }
  }

  final lessons = <String>[].obs;
  final lessonStartHours = <String>[].obs;
  final lessonEndHours = <String>[].obs;
  final day = <String>[].obs;

  final weeklyProgram = <String, List<dynamic>>{}.obs;

  Future<void> fetchWeeklyProgramByStudentId(int studentId) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getWeeklyProgramByStudentId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': studentId,
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

    isLoading.value = false;
  }

  Future<void> getAllStudentsCoursesAfterUpdate(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getAllStudentsCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'student_id': studentId
          //,
        }),
      );

      if (response.statusCode == 200) {
        print("getAllStudentsCourses çalıştı");

        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getAllStudentsCoursesList.assignAll(coursesList);
      } else {
        print("Error: ${response.statusCode}");
        Get.snackbar(
          'Hata',
          'Bir problem oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.only(bottom: 20.0),
        );
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getAllStudentsCourses Exception: $e");
    }
  }
}
