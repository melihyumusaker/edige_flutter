// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/MessageControllers/MessageController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeacherMessage/MessageBox.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/Meetings/ShowAllTeacherMeetingsPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/widgets/TeacherDrawer.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingController = Get.find<MeetingController>();
    final controller = Get.put(TeacherController());
    final buttonWidth = MediaQuery.of(context).size.width * 0.6;
    final buttonHeight = MediaQuery.of(context).size.width * 0.15;

    return Scaffold(
      appBar: TeacherHomePageAppBar(),
      drawer: const TeacherDrawer(),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            const Color.fromARGB(255, 219, 97, 158),
            const Color.fromARGB(255, 14, 76, 184)),
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              teacherInfoCard(controller),
              const SizedBox(height: 16),
              buildButton(
                width: buttonWidth,
                height: buttonHeight,
                text: "Öğrenci İşlemleri",
                onPressed: () {
                  Get.toNamed("/TeachersStudentsListPage");
                },
              ),
              buildButton(
                width: buttonWidth,
                height: buttonHeight,
                text: "Mesaj İşlemleri",
                onPressed: () {
                  Get.to(() => const MessageBox(),transition: Transition.rightToLeft, binding: BindingsBuilder(() {
                    Get.put(MessageController());
                  }));
                },
              ),
              buildButton(
                width: buttonWidth,
                height: buttonHeight,
                text: "Toplantılar",
                onPressed: () {
                  meetingController.getTeacherAllMeetings(
                    Get.find<TeacherController>().teacherId.value,
                    Get.find<TeacherController>().token.value,
                  );
                  Get.to(() => const ShowAllTeacherMeetingsPage(),transition: Transition.rightToLeft);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildButton({
    required double width,
    required double height,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          label: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ), // Custom padding
          ),
        ),
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
        style: TextStyle(color: Colors.white70),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 219, 97, 158),
    );
  }

  Widget buildText(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value ?? 'Bilinmiyor'}',
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
