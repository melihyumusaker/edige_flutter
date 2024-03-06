// ignore_for_file: non_constant_identifier_names, file_names, unused_import, unused_local_variable

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/SetStudentTrialExamPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/StudentHomeworksPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/StudentTrialExamDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/GetStudentWeeklyProgramPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailPage extends StatelessWidget {
  final int student_id;

  const StudentDetailPage({Key? key, required this.student_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    final weeklyProgramController =
        Get.put<WeeklyProgramController>(WeeklyProgramController());
    return Scaffold(
      appBar: studentDetailAppBar(teacherController),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await teacherController
                    .getStudentTrialExamsByTeacher(student_id);

                Get.to(
                    () => StudentTrialExamDetailPage(student_id: student_id));
              },
              child: const Text('Öğrencinin Deneme Sınavı Sonuçlarını Gör'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Get.to(() => StudentHomeworksPage(studentId: student_id));
              },
              child: const Text('Öğrenci Ödev İşlemleri'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await teacherController
                    .fetchWeeklyProgramByStudentId(student_id);
                Get.to(
                    () => GetStudentWeeklyProgramPage(studentId: student_id));
              },
              child: const Text('Öğrenci Ders Programı İşlemleri'),
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
