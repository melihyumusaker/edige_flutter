// ignore_for_file: non_constant_identifier_names, file_names

import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherAboutPage extends StatelessWidget {
  final String enneagramType;
  final TextEditingController aboutController = TextEditingController();

  TeacherAboutPage({Key? key, required this.enneagramType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: teacheAboutPageAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoText(),
            const SizedBox(height: 16.0),
            textFormWidget(),
            const SizedBox(height: 16.0),
            sendButton(enneagramType, context),
          ],
        ),
      ),
    );
  }

  ElevatedButton sendButton(String enneagramType, BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String aboutText = aboutController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş Başarılı'),
            duration: Duration(seconds: 2),
          ),
        );
        await Get.find<TeacherController>()
            .updateTeacherEnneagramTypeAndAbout(aboutText, enneagramType);

        Get.toNamed("/TeacherHomePage");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
      ),
      child: const Text('Gönder', style: TextStyle(color: Colors.white)),
    );
  }

  Expanded textFormWidget() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            controller: aboutController,
            maxLines: 10,
            style: const TextStyle(color: Colors.lightBlue),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Kendiniz hakkında bir şeyler yazın...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Text InfoText() {
    return const Text(
      'Lütfen kendinizi tanıtınız',
      style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue), 
    );
  }

  AppBar teacheAboutPageAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text('Öğretmen Hakkında',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.lightBlue, // AppBar rengi
    );
  }
}
