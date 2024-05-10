// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeacherSettings/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherDrawer extends StatelessWidget {
  const TeacherDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.find<TeacherController>();
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 92, 147, 230),
              Color.fromARGB(255, 136, 127, 184)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Arka plan rengi
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "${Get.find<TeacherController>().teacherInfo['user']['name']} ${Get.find<TeacherController>().teacherInfo['user']['surname']}",
              ),
              accountEmail: Text(
                  Get.find<TeacherController>().teacherInfo['user']['email']),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 76, 140, 224), // Header rengi
              ),
            ),
            ListTile(
              title: const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 230, 226, 226),
                ),
              ),
              leading: const Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              onTap: () {
                // Profil sayfasına git
              },
            ),
            const Divider(),
            ListTile(
              title: InkWell(
                onTap: () {
                  Get.to(() => SettingsPage(
                      token: Get.find<TeacherController>().token.value));
                },
                child: const Text(
                  'Ayarlar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 230, 226, 226),
                  ),
                ),
              ),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {
                // Ayarlar sayfasına git
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 168, 27, 17),
                ),
              ),
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 168, 27, 17),
              ),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  showCloseIcon: true,
                  title: "Dikkat",
                  desc: "Çıkış yapmak istediğinizden emin misiniz?",
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    Get.offNamed("/firstScreen");
                  },
                  btnCancelText: "Hayır",
                  btnOkText: "Evet",
                ).show();
              },
            ),
          ],
        ),
      ),
    );
  }
}
