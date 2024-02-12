import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherCircularPage extends StatelessWidget {
  const TeacherCircularPage({Key? key}) : super(key: key);

  Future<void> _initState() async {
    final teacherController = Get.find<TeacherController>();
    await teacherController.showStudents();
    await teacherController
        .getTeacherIdByUserId(int.parse(teacherController.user_id.value));

    Get.offNamed('/TeacherHomePage');
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TeacherController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 219, 121, 121),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 219, 121, 121),
              Color.fromARGB(255, 97, 140, 206)
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
