import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/SetStudentTrialExamPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/StudentTrialExamDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailPage extends StatelessWidget {
  final int student_id;

  const StudentDetailPage({Key? key, required this.student_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    return Scaffold(
      appBar: studentDetailAppBar(teacherController),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await teacherController
                    .getStudentTrialExamsByTeacher(student_id);

                Get.to(() => const StudentTrialExamDetailPage());
              },
              child: const Text('Öğrencinin Deneme Sınavı Sonuçlarını Gör'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Get.to(() => SetStudentTrialExamPage(studentId: student_id));
              },
              child: const Text('Öğrencinin Deneme Sınavı Sonucunu Gir'),
            ),
          ),
        ],
      ),
    );
  }

  AppBar studentDetailAppBar(TeacherController teacherController) {
    return AppBar(
      title: const Text('Öğrenci Deneme Sınavı Sonuçları'),
      // Geri tuşuna basıldığında clearStudentTrialExamResults fonksiyonunu çağır
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          teacherController.clearStudentTrialExamResults();
          Get.back();
        },
      ),
    );
  }
}
