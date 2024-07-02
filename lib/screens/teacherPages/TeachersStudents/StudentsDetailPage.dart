// ignore: file_names
// ignore_for_file: non_constant_identifier_names

import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/QRController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/ShowMeetingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/StudentTrialExamDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Homework/StudentHomeworksPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/WeeklyProgram/GetStudentWeeklyProgramPage.dart';

class StudentDetailPage extends StatelessWidget {
  final int student_id;
  final String section;
  final String school;
  final String name;
  final String surName;
  final String birthDate;
  final String email;
  final String phone;
  final String city;

  const StudentDetailPage(
      {Key? key,
      required this.student_id,
      required this.section,
      required this.school,
      required this.name,
      required this.surName,
      required this.birthDate,
      required this.email,
      required this.phone,
      required this.city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    final meetingController = Get.put(MeetingController());
    final qrController = Get.put(QRController());

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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  customElevatedButton(
                      context, 'Öğrencinin Deneme Sınavı Sonuçlarını Gör',
                      () async {
                    await teacherController
                        .getStudentTrialExamsByTeacher(student_id);
                    Get.to(
                        () =>
                            StudentTrialExamDetailPage(student_id: student_id),
                        transition: Transition.rightToLeft);
                  }),
                  const SizedBox(height: 20),
                  customElevatedButton(context, 'Öğrenci Ödev İşlemleri', () {
                    Get.to(() => StudentHomeworksPage(studentId: student_id),
                        transition: Transition.rightToLeft);
                  }),
                  const SizedBox(height: 20),
                  customElevatedButton(
                    context,
                    'Öğrenci Ders Programı İşlemleri',
                    () async {
                      await teacherController
                          .fetchWeeklyProgramByStudentId(student_id);
                      Get.to(
                          () => GetStudentWeeklyProgramPage(
                              studentId: student_id),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  const SizedBox(height: 20),
                  customElevatedButton(context, "Toplantıları Gör", () async {
                    await Get.find<MeetingController>()
                        .getStudentAndTeacherSpecialMeetings(
                            student_id,
                            Get.find<TeacherController>().teacherId.value,
                            Get.find<TeacherController>().token.value);

                    Get.to(() => ShowMeetingsPage(studentId: student_id),
                        transition: Transition.rightToLeft);
                  }),
                  Obx(() {
                    if (meetingController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox.shrink(); // Boş alan
                    }
                  }),
                  const SizedBox(height: 20),
                  customElevatedButton(
                    context,
                    "Öğrenci Bilgileri",
                    () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Öğrenci Bilgileri",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            content: SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: const Text("Öğrenci İsmi"),
                                    subtitle: Text("$name $surName"),
                                  ),
                                  ListTile(
                                    title: const Text("Bölüm"),
                                    subtitle: Text(section),
                                  ),
                                  ListTile(
                                    title: const Text("Okul"),
                                    subtitle: Text(school),
                                  ),
                                  ListTile(
                                    title: const Text("Doğum Tarihi"),
                                    subtitle: Text(birthDate),
                                  ),
                                  ListTile(
                                    title: const Text("Email"),
                                    subtitle: Text(email),
                                  ),
                                  ListTile(
                                    title: const Text("Telefon"),
                                    subtitle: Text(phone),
                                  ),
                                  ListTile(
                                    title: const Text("Şehir"),
                                    subtitle: Text(city),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              devamsizlikWidget(context, qrController),
            ],
          ),
        ),
      ),
    );
  }

  Positioned devamsizlikWidget(
      BuildContext context, QRController qrController) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.width * 0.00004,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Obx(() => Text(
              "Toplam Devamsızlık: ${qrController.totalStudentRecord.value}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )),
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
