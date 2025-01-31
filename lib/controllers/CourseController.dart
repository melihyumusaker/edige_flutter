// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, unnecessary_import, file_names, unused_local_variable, unused_import

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/studentPages/Homework/HomeworkDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  var addNewCourseCourseId = 0;

  var selectedCourseDetail = {}.obs;

  var unShownCourseNumber = 0.obs;
  var selectedCourseStatus = 'Tamamlanamadı'.obs;
  var selectedButton = 'Ödevler'.obs;
  void updateCourseStatus(String newStatus) {
    selectedCourseStatus.value = newStatus;
  }

  Future<void> getAllStudentsCourses() async {
    Get.put(StudentController());
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getAllStudentsCourses}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'student_id': Get.find<StudentController>().studentId.value}),
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
        print(response.body);
      }
    } catch (e) {
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
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsNotDoneCourses Exception: $e");
    }
  }

  Future<void> studentFinishHomework(
      int course_id, int is_homework_done, String student_comment) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.studentFinishHomework}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'course_id': course_id,
          'is_homework_done': is_homework_done,
          'student_comment': student_comment
        }),
      );

      if (response.statusCode == 200) {
        print("studentFinishHomework çalıştı");
        List<dynamic> responseData = jsonDecode(response.body);
        await getAllStudentsCourses();
        await getStudentsDoneCourse();
        await getStudentsNotDoneCourses();
        print(response.body);
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" getStudentsNotDoneCourses Exception: $e");
    }
  }

  Future<void> unshownCourseNumber(int studentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.unshownCourseNumber}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({
          'student_id': studentId,
        }),
      );

      if (response.statusCode == 200) {
        print("unshownCourseNumber çalıştı");
        unShownCourseNumber.value = jsonDecode(response.body);
        print(unShownCourseNumber.value);
      } else {
        print("unshownCourseNumber Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print(" unshownCourseNumber Exception: $e");
    }
  }

  Future<void> addNewCourse(
    String courseName,
    String subcourseName,
    String homeworkDescription,
    String homeworkDeadline,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addNewCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({
          'course_name': courseName,
          'subcourse_name': subcourseName,
          'homework_description': homeworkDescription,
          'homework_deadline': homeworkDeadline
        }),
      );

      if (response.statusCode == 200) {
        print("addNewCourse çalıştı");
        dynamic responseData = jsonDecode(response.body);
        addNewCourseCourseId = responseData;
        print(addNewCourseCourseId);
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" addNewCourse Exception: $e");
    }
  }

  Future<void> addNewStudentCourse(int course_id, int student_id) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addNewStudentCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({'course_id': course_id, 'student_id': student_id}),
      );

      if (response.statusCode == 200) {
        print("addNewStudentCourse çalıştı");
        dynamic responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      // Hata oluştuysa
      print(" addNewStudentCourse Exception: $e");
    }
  }

  Future<void> createHomeworkAndAssignToStudent(
      BuildContext context,
      String courseName,
      String subcourseName,
      String homeworkDescription,
      String homeworkDeadline,
      int studentId) async {
    try {
      await addNewCourse(
          courseName, subcourseName, homeworkDescription, homeworkDeadline);
      await addNewStudentCourse(addNewCourseCourseId, studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Başarıyla kaydedildi",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } catch (e) {
      // Hata Snackbar, arka planı kırmızı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Bir hata oluştu",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  Future<void> updateCourse(
    BuildContext context,
    int courseId,
    String courseName,
    String subcourseName,
    String homeworkDescription,
    int isHomeworkDone,
    String homeworkDeadline,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({
          'course_id': courseId,
          'course_name': courseName,
          'subcourse_name': subcourseName,
          'homework_description': homeworkDescription,
          'is_homework_done': isHomeworkDone,
          'homework_deadline': homeworkDeadline,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Başarılı'),
            content: const Text('Kurs başarıyla güncellendi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Hata'),
            content: const Text('Kurs güncellenirken bir hata oluştu.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("updateCourse Exception: $e");
    }
  }

  Future<void> deleteCourse(int courseId, int studentId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token}',
        },
        body: jsonEncode({'course_id': courseId, 'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        await Get.find<TeacherController>().getAllStudentsCourses(studentId);
        Get.snackbar(
          "Başarılı",
          "Kurs başarıyla silindi",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Hata",
          "Kurs silinirken bir hata oluştu",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Hata oluştuysa
      Get.snackbar(
        "Hata",
        "Kurs silinirken bir hata oluştu",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print("deleteCourse Exception: $e");
    }
  }

  Future<void> setCourseShown(
      BuildContext context, int courseId, int isShown) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Ödev Detay Sayfasına Geçiliyor..."),
              ],
            ),
          ),
        );
      },
    );
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({'course_id': courseId, 'is_shown': isShown}),
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print("setCourseShown Exception: $e");
    } finally {
      Navigator.of(context).pop();
    }
  }
}
