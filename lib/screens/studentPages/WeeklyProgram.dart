import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyProgramPage extends StatefulWidget {
  const WeeklyProgramPage({Key? key});

  @override
  _WeeklyProgramPageState createState() => _WeeklyProgramPageState();
}

class _WeeklyProgramPageState extends State<WeeklyProgramPage> {
  late WeeklyProgramController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WeeklyProgramController());
  }

  @override
  Widget build(BuildContext context) {
    // Haftanın günlerini sıralı bir şekilde tanımla
    final List<String> weekDays = [
      'Pazartesi',
      'Sali',
      'Carsamba',
      'Persembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];

    return Scaffold(
      appBar: weeklyProgramAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: FutureBuilder(
            future: controller.fetchWeeklyProgramByStudentId(7),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GetBuilder<WeeklyProgramController>(
                  builder: (controller) {
                    return ListView.builder(
                      itemCount: weekDays.length,
                      itemBuilder: (BuildContext context, int index) {
                        String day = weekDays[index];

                        List<Widget> dayLessons = [];

                        for (var lesson
                            in controller.weeklyProgram[day] ?? []) {
                          dayLessons.add(
                            weeklyProgramItems(lesson),
                          );
                        }

                        return Card(
                          color: Colors.blue[200],
                          elevation: 5.0,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: ExpansionTile(
                            title: Text(
                              day,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            children: dayLessons,
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Padding weeklyProgramItems(lesson) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        color: const Color.fromARGB(255, 78, 150, 201),
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              lesson['lesson_name'].toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              '${lesson['lesson_start_hour']} - ${lesson['lesson_end_hour']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar weeklyProgramAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[100],
      centerTitle: true,
      title: const Text(
        "Ders Programı",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
