import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseController extends GetxController {
  RxList<Map<String, dynamic>> getStudentsDoneCoursesList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> getAllStudentsCoursesList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> getStudentsNotDoneCoursesList =
      <Map<String, dynamic>>[].obs;

  var selectedButton = 'Ödevler'.obs;
  Future<void> getAllStudentsCourses() async {
    Get.put(StudentController());
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getAllStudentsCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'student_id': Get.find<StudentController>().studentId.value
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
        // Sunucudan hata döndüyse
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getAllStudentsCourses Exception: $e");
    }
  }

  Future<void> getStudentsDoneCourse() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentsDoneCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'student_id': Get.find<StudentController>().studentId.value}),
      );

      if (response.statusCode == 200) {
        print("getStudentsDoneCourse çalıştı");
        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getStudentsDoneCoursesList.assignAll(coursesList);
      } else {
        // Sunucudan hata döndüyse
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsDoneCourse Exception: $e");
    }
  }

  Future<void> getStudentsNotDoneCourses() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentsNotDoneCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'student_id': Get.find<StudentController>().studentId.value}),
      );

      if (response.statusCode == 200) {
        print("getStudentsNotDoneCourses çalıştı");
        List<dynamic> responseData = jsonDecode(response.body);

        List<Map<String, dynamic>> coursesList = responseData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        getStudentsNotDoneCoursesList.assignAll(coursesList);
      } else {
        // Sunucudan hata döndüyse
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsNotDoneCourses Exception: $e");
    }
  }
}
