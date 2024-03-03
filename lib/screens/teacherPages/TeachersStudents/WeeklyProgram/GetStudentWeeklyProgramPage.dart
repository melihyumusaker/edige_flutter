// ignore_for_file: file_names

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/NewWeeklyProgramPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/UpdateWeeklyProgramPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';

class GetStudentWeeklyProgramPage extends StatelessWidget {
  final int studentId;
  const GetStudentWeeklyProgramPage({Key? key, required this.studentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherController = Get.find<TeacherController>();
    final WeeklyProgramController weeklyProgramController =
        Get.find<WeeklyProgramController>();

    return Scaffold(
      appBar: WeeklyProgramAppBar(),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
          Colors.blue,
          Colors.purple,
        ),
        child: Obx(() {
          Map<String, List<dynamic>> weeklyProgram =
              // ignore: invalid_use_of_protected_member
              teacherController.weeklyProgram.value;
          List<String> days = [
            'Pazartesi',
            'Sali',
            'Carsamba',
            'Persembe',
            'Cuma',
            'Cumartesi',
            'Pazar'
          ];

          return ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, index) {
              String day = days[index];
              List<dynamic>? lessons = weeklyProgram[day];

              return ExpansionTile(
                title: WeekDays(day),
                children: lessons != null
                    ? lessons.map((lesson) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15,
                            bottom: 8,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: WeekItems(
                              lesson,
                              context,
                              weeklyProgramController,
                              teacherController,
                            ),
                          ),
                        );
                      }).toList()
                    : [],
              );
            },
          );
        }),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ListTile WeekItems(
      lesson,
      BuildContext context,
      WeeklyProgramController weeklyProgramController,
      TeacherController teacherController) {
    return ListTile(
      title: Text(lesson['lesson_name'],
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
          '${lesson['lesson_start_hour']} - ${lesson['lesson_end_hour']}',
          style: const TextStyle(color: Colors.white70)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          updateIconButton(lesson),
          deleteIconButton(
            context,
            weeklyProgramController,
            lesson,
            teacherController,
          ),
        ],
      ),
    );
  }

  IconButton deleteIconButton(
      BuildContext context,
      WeeklyProgramController weeklyProgramController,
      lesson,
      TeacherController teacherController) {
    return IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onPressed: () async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Silme İşlemi'),
              content: const Text('Silmek istediğinize emin misiniz?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Hayırı seç
                  },
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true); // Eveti seç
                  },
                  child: const Text('Evet'),
                ),
              ],
            );
          },
        );

        if (confirmDelete == true) {
          // ignore: use_build_context_synchronously
          await weeklyProgramController.deleteWeeklyProgram(
              context, lesson['weekly_program_id']);

          await teacherController.fetchWeeklyProgramByStudentId(studentId);
        }
      },
    );
  }

  IconButton updateIconButton(lesson) {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.yellow),
      onPressed: () {
        Get.to(() => UpdateWeeklyProgramPage(
              studentId: studentId,
              weeklyProgramId: lesson['weekly_program_id'],
              lessonEndHour: lesson['lesson_end_hour'],
              lessonName: lesson['lesson_name'],
              lessonStartHour: lesson['lesson_start_hour'],
            ));
      },
    );
  }

  // ignore: non_constant_identifier_names
  Text WeekDays(String day) {
    return Text(
      day,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar WeeklyProgramAppBar() {
    return AppBar(
      title: const Text(
        'Haftalık Ders Programı',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
      actions: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.to(() => NewWeeklyProgramPage(
                    studentId: studentId,
                  ));
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
