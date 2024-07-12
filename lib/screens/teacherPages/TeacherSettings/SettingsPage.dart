// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, file_names

import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/screens/teacherPages/TeacherSettings/ForgetMyPasswordPage.dart';

class SettingsPage extends StatelessWidget {
  var token;
  var email;
  SettingsPage({Key? key, required this.token, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Ayarlar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue, Colors.purple),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => ForgetMyPasswordPage(token: token, email: email),
                  transition: Transition.rightToLeft);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Colors.pink, // Arka plan rengi
              foregroundColor: Colors.white, // Metin rengi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: Colors.black,
              elevation: 10,
            ),
            child: const Text(
              'Şifre Değiştir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
