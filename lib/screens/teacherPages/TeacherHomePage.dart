import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/TeachersStudentsListPage");
              },
              child: Text("Öğrenci İşleri"))
        ],
      ),
    );
  }
}
