import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherController());
    return Scaffold(
      appBar: TeacherHomePageAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              teacherInfoCard(controller),
              const SizedBox(height: 16),
              studentInfosButton(),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton studentInfosButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Get.toNamed("/TeachersStudentsListPage");
      },
      label: const Text(
        "Öğrenci İşleri",
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      backgroundColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Card teacherInfoCard(TeacherController controller) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText('İsim', controller.teacherInfo['user']['name']),
            buildText('Soy İsim', controller.teacherInfo['user']['surname']),
            buildText('Uzmanlık', controller.teacherInfo['expertise']),
            buildText(
                'Enneagram Sonucu', controller.teacherInfo['enneagram_result']),
            buildText('Email', controller.teacherInfo['user']['email']),
          ],
        ),
      ),
    );
  }

  AppBar TeacherHomePageAppBar() {
    return AppBar(
      title: const Text(
        'Öğretmen Ana Sayfa',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.lightBlueAccent,
    );
  }

  Widget buildText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
