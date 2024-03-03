import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/NewWeeklyProgramPage.dart';
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
                title: Text(day,
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
                children: lessons != null
                    ? lessons.map((lesson) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text(lesson['lesson_name'],
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  '${lesson['lesson_start_hour']} - ${lesson['lesson_end_hour']}',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.yellow),
                                    onPressed: () {},
                                  ),
                                  IconButton(
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
                                            content: const Text(
                                                'Silmek istediğinize emin misiniz?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false); // Hayırı seç
                                                },
                                                child: const Text('Hayır'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context)
                                                      .pop(true); // Eveti seç
                                                },
                                                child: const Text('Evet'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        await weeklyProgramController
                                            .deleteWeeklyProgram(context,
                                                lesson['weekly_program_id']);

                                        await teacherController
                                            .fetchWeeklyProgramByStudentId(
                                                studentId);
                                      }
                                    },
                                  ),
                                ],
                              ),
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
