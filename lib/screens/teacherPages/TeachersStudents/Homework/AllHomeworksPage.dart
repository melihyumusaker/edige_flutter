// ignore_for_file: file_names, non_constant_identifier_names

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/UpdateHomeworkPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/widgets/TeacherStudentsHomeworksAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';

class AllHomeworksPage extends StatelessWidget {
  final int studentId;
  const AllHomeworksPage({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    final courseController = Get.put<CourseController>(CourseController());

    return Scaffold(
      appBar: TeacherStudentsHomeworksAppBar(titleText: "Tüm Ödevler"),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue, Colors.green),
        child: Obx(() {
          final coursesList = teacherController.getAllStudentsCoursesList;

          if (coursesList.isEmpty) {
            return const Center(child: Text('Ödev Bulunamadı'));
          }

          return ListView.builder(
            itemCount: coursesList.length,
            itemBuilder: (context, index) {
              final course = coursesList[index];

              DateTime deadline =
                  DateTime.parse(course['homework_deadline'] ?? '');

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 206, 128, 54),
                        Colors.lightGreenAccent
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(course['course_name'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course['subcourse_name'] ?? ''),
                            Text(
                                'Son Teslim Tarihi: ${deadline.day.toString().padLeft(2, '0')}-${deadline.month.toString().padLeft(2, '0')}-${deadline.year} ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            course['is_homework_done'] == 1
                                ? const Icon(Icons.check, color: Colors.green)
                                : const Icon(Icons.close, color: Colors.red),
                            const SizedBox(width: 16),
                            HomeworkDescription(context, course),
                            StudentComment(context, course),
                          ],
                        ),
                      ),
                      updateAndDeleteCourseButtons(
                        context,
                        course,
                        courseController,
                        teacherController,
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Row updateAndDeleteCourseButtons(
    BuildContext context,
    Map<String, dynamic> course,
    CourseController courseController,
    TeacherController teacherController,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CourseUpdateMethod(context, course),
        CourseDeleteMethod(context, course['course_id'], studentId,
            courseController, teacherController),
      ],
    );
  }

  ElevatedButton CourseDeleteMethod(
    BuildContext context,
    int courseId,
    int studentId,
    CourseController courseController,
    TeacherController teacherController,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        // AlertDialog oluştur
        bool deleteConfirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Silmek istediğinize emin misiniz?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // 'Hayır'ı seç
                  },
                  child: const Text("Hayır"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // 'Evet'i seç
                  },
                  child: const Text("Evet"),
                ),
              ],
            );
          },
        );

        // Eğer kullanıcı 'Evet'i seçerse, dersi sil
        if (deleteConfirmed == true) {
          await courseController.deleteCourse(courseId, studentId);
        }
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      label: const Text("Sil"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  ElevatedButton CourseUpdateMethod(
      BuildContext context, Map<String, dynamic> course) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.to(() => UpdateHomeworkPage(
              studentId: studentId,
              courseId: course['course_id'],
              courseName: course['course_name'],
              subcourseName: course['subcourse_name'],
              homeworkDescription: course['homework_description'],
              isHomeworkDone: course['is_homework_done'],
              homeworkDeadline: course['homework_deadline'],
            ),
                  transition: Transition
                      .rightToLeft);
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow,
        ),
        child: const Icon(Icons.sync_outlined, color: Colors.black),
      ),
      label: const Text("Güncelle"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  IconButton StudentComment(BuildContext context, Map<String, dynamic> course) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Öğrenci Yorumu'),
            content: Text(course['student_comment'] ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.comment),
    );
  }

  IconButton HomeworkDescription(
      BuildContext context, Map<String, dynamic> course) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Ödev Açıklaması'),
            content: Text(course['homework_description'] ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.description),
    );
  }
}
