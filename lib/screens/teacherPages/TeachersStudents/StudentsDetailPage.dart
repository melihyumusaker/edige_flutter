// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/StudentTrialExamDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/StudentHomeworksPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/GetStudentWeeklyProgramPage.dart';

class StudentDetailPage extends StatelessWidget {
  final int student_id;

  const StudentDetailPage({Key? key, required this.student_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    return Scaffold(
      appBar: studentDetailAppBar(teacherController),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customElevatedButton(
                  context, 'Öğrencinin Deneme Sınavı Sonuçlarını Gör',
                  () async {
                await teacherController
                    .getStudentTrialExamsByTeacher(student_id);
                Get.to(
                    () => StudentTrialExamDetailPage(student_id: student_id));
              }),
              const SizedBox(height: 20),
              customElevatedButton(context, 'Öğrenci Ödev İşlemleri', () {
                Get.to(() => StudentHomeworksPage(studentId: student_id));
              }),
              const SizedBox(height: 20),
              customElevatedButton(context, 'Öğrenci Ders Programı İşlemleri',
                  () async {
                await teacherController
                    .fetchWeeklyProgramByStudentId(student_id);
                Get.to(
                    () => GetStudentWeeklyProgramPage(studentId: student_id));
              }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar studentDetailAppBar(TeacherController teacherController) {
    return AppBar(
      title: const Text(
        'Öğrenci Detayları',
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue.shade700,
    );
  }

  Widget customElevatedButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        onPressed: onPressed,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
