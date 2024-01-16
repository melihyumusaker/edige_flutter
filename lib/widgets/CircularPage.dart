import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/screens/EnneagramType.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularPage extends StatelessWidget {
  const CircularPage({super.key});

  Future<void> _initState() async {
    final userIdValue = int.tryParse(Get.find<LoginController>().user_id.value);

    if (userIdValue != null && userIdValue != 0) {
      await Get.find<StudentController>().getStudentIdByUserId(userIdValue);
      await Get.find<StudentController>().getStudentInfosByStudentId(
          Get.find<StudentController>().studentId.value);

      if (Get.find<StudentController>().isEnneagramTestSolved.value == 0) {
        Get.off(const EnneagramType());
      } else if (Get.find<StudentController>().isEnneagramTestSolved.value ==
          1) {
        Get.offNamed('/HomePage');
      }
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
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 112, 139, 180),
      ),
      body: Container(
        width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 139, 180),
                Color.fromARGB(255, 88, 71, 185)
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
