import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/screens/teacherPages/TeacherSettings/ForgetMyPasswordPage.dart';

class SettingsPage extends StatelessWidget {
  var token;
   SettingsPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayalar')),
      body: Column(children: [
        ElevatedButton(
            onPressed: () {
              Get.to(() => ForgetMyPasswordPage(token: token));
            },
            child: Text('Şifre Değiştir'))
      ]),
    );
  }
}
