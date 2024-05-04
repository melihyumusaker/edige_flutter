// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LessonController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/NewHomeworkPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeworksPage extends StatelessWidget {
  final int studentId;
  const StudentHomeworksPage({Key? key, required this.studentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lessonController = Get.find<LessonController>();
    final teacherController = Get.find<TeacherController>();
    final courseController = Get.put<CourseController>(CourseController());

    return Scaffold(
      appBar: StudentHomeworksPageAppbar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SquareButton(
                    buttonText: 'Tüm Ödevler',
                    gradientColors: const [
                      Color.fromARGB(255, 189, 178, 81),
                      Colors.orange
                    ],
                    onTap: () async {
                      await teacherController.getAllStudentsCourses(studentId);
                    },
                  ),
                  const SizedBox(width: 32.0),
                  SquareButton(
                    buttonText: 'Yapılan Ödevler',
                    gradientColors: const [Colors.purple, Colors.pink],
                    onTap: () async {
                      await teacherController.getStudentsDoneCourse(studentId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SquareButton(
                    buttonText: 'Devam Eden Ödevler',
                    gradientColors: const [Colors.blue, Colors.lightBlue],
                    onTap: () async {
                      await teacherController
                          .getStudentsNotDoneCourses(studentId);
                    },
                  ),
                  const SizedBox(width: 32.0),
                  SquareButton(
                    buttonText: 'Yeni Ödev Gir',
                    gradientColors: const [Colors.green, Colors.teal],
                    onTap: () async {
                      await _handleNewHomeworkTap(
                          context, lessonController, studentId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleNewHomeworkTap(
    BuildContext context,
    LessonController lessonController,
    int studentId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await lessonController.fetchAllLessonsAndFetchGrades();
    Navigator.pop(context);

    Get.to(() => NewHomeworkPage(studentId: studentId),
        transition: Transition.fadeIn);
  }

  PreferredSize StudentHomeworksPageAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          title: const Text(
            'Ödev İşlemleri',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String buttonText;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const SquareButton({
    Key? key,
    required this.buttonText,
    required this.gradientColors,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
