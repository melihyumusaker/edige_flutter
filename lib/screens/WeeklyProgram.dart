// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeeklyProgramPage extends StatelessWidget {
  const WeeklyProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WeeklyProgramController());
    Get.put(StudentController());

    @override
    Future<void> _initState() async {
      await Get.find<WeeklyProgramController>().fetchWeeklyProgramByStudentId(
          Get.find<StudentController>().studentId.value);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        centerTitle: true, // Center aligns the title
        title: const Text("Ders Programı"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100], // Set your desired background color here
        ),
        child: Center(
          child: Obx(
            () => ListView.builder(
              itemCount:
                  Get.find<WeeklyProgramController>().lessonStartHours.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.058,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        Get.find<WeeklyProgramController>().lessons[index],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        '${Get.find<WeeklyProgramController>().lessonStartHours[index]} - ${Get.find<WeeklyProgramController>().lessonEndHours[index]}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      trailing: Text(
                        DateFormat('yyyy-MM-dd').format(
                            Get.find<WeeklyProgramController>().day[index]),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
