// ignore_for_file: file_names

import 'package:edige/widgets/TeacherStudentsHomeworksAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';

class NotDoneHomeworksPage extends StatelessWidget {
  const NotDoneHomeworksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();

    return Scaffold(
      appBar: TeacherStudentsHomeworksAppBar(titleText: "Devam Eden Ödevler"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Obx(() {
          final coursesList = teacherController.getStudentsNotDoneCoursesList;

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
                  child: ListTile(
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
                        // İkon butonlar
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Ödev Açıklaması'),
                                content:
                                    Text(course['homework_description'] ?? ''),
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
                        ),
                        IconButton(
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
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
