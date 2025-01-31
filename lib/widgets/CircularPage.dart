// ignore_for_file: file_names

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/NotifStudentController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TrialExamController.dart';
import 'package:edige/screens/studentPages/EnneagramType.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularPage extends StatelessWidget {
  const CircularPage({super.key});

  Future<void> _initState() async {
    Get.put(StudentController());
    Get.put(LoginController());
    final userIdValue = int.tryParse(Get.find<LoginController>().user_id.value);

    if (userIdValue != null && userIdValue != 0) {
      await Get.find<StudentController>().getStudentIdByUserId(userIdValue);
      await Get.find<StudentController>().getStudentInfosByStudentId(
          Get.find<StudentController>().studentId.value);

      if (Get.find<StudentController>().isEnneagramTestSolved.value == 0) {
        Get.off(const EnneagramType(), transition: Transition.rightToLeft);
      } else if (Get.find<StudentController>().isEnneagramTestSolved.value ==
          1) {
        await Get.find<CourseController>()
            .unshownCourseNumber(Get.find<StudentController>().studentId.value);

        await Get.find<TrialExamController>().countUnshown(
          studentId: Get.find<StudentController>().studentId.value,
          token: Get.find<LoginController>().token.value,
        );

        await Get.find<MeetingController>().unshownMeetingumber(
            Get.find<StudentController>().studentId.value,
            Get.find<LoginController>().token.value);
        Get.offNamed('/HomePage');
      }

      await Get.find<NotifStudentController>().getNotifStudentByStudentId(
          Get.find<StudentController>().studentId.value);

      await Get.find<NotifStudentController>().getUnseenNotifNumber(Get.find<StudentController>().studentId.value);
    } else {
      // If user ID is not available, redirect to the login screen
      debugPrint('Hata: User ID boş veya geçersiz.');
      Get.offAllNamed('/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());
    Get.put(LoginController());

    // Call the _initState() function in the build() method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 135, 230, 253),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 135, 230, 253),
              Color.fromARGB(255, 131, 124, 192)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
