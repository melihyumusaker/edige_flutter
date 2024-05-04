// ignore_for_file: avoid_print, file_names, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_import

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/widgets/HomeworkButtonAndCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Homeworks extends StatelessWidget {
  const Homeworks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CourseController());

    Future<void> _initState() async {
      try {
        await Get.find<CourseController>().getAllStudentsCourses();
        await Get.find<CourseController>().getStudentsDoneCourse();
        await Get.find<CourseController>().getStudentsNotDoneCourses();
      } catch (e) {
        print(e);
      }
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initState();
    });

    return WillPopScope(
      onWillPop: () async {
        Get.find<CourseController>().selectedButton.value = 'Ödevler';
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 159, 219, 245),
        appBar: HomeworkAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: HomeworkButtons(context),
            ),
            Courses(context),
          ],
        ),
      ),
    );
  }

  Expanded Courses(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            final courseController = Get.find<CourseController>();
            if (Get.find<CourseController>().selectedButton.value ==
                'Ödevler') {
              return HomeworkList(
                  courses: courseController.getAllStudentsCoursesList,
                  context: context);
            } else if (Get.find<CourseController>().selectedButton.value ==
                'Yapılmakta') {
              return HomeworkList(
                  courses: courseController.getStudentsNotDoneCoursesList,
                  context: context);
            } else {
              return HomeworkList(
                  courses: courseController.getStudentsDoneCoursesList,
                  context: context);
            }
          },
        ),
      ),
    );
  }

  Widget HomeworkList(
      {required List<Map<String, dynamic>> courses,
      required BuildContext context}) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return HomeworkCard(course, context);
      },
    );
  }

  Row HomeworkButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HomeworkButton(
          label: 'Ödevler',
          onPressed: () {
            Get.find<CourseController>().selectedButton.value = 'Ödevler';
          },
        ),
        HomeworkButton(
          label: 'Yapılmakta',
          onPressed: () {
            Get.find<CourseController>().selectedButton.value = 'Yapılmakta';
          },
        ),
        HomeworkButton(
          label: 'Yapılanlar',
          onPressed: () {
            Get.find<CourseController>().selectedButton.value = 'Yapılanlar';
          },
        ),
      ],
    );
  }

  AppBar HomeworkAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Ödevler",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor:
          const Color.fromARGB(255, 100, 189, 228), // Adjust the app bar color
    );
  }
}
