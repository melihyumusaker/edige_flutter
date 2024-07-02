// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/NotifStudentController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/screens/studentPages/NotificationsPage.dart';
import 'package:edige/screens/teacherPages/TeacherSettings/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              accountName: Obx(() => Text(
                    "${Get.find<StudentController>().name} ${Get.find<StudentController>().surname}",
                  )),
              accountEmail: Obx(() =>
                  Text(Get.find<StudentController>().username.toString())),
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
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Danışman Koç',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Get.find<StudentController>()
                            .studentsTeacher
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(),
            ListTile(
              title: const Text(
                'Bildirimler',
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
              trailing: Obx(() => Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      Get.find<NotifStudentController>()
                          .unseenNotifNumber
                          .value
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              onTap: () {
                Get.to(() => const NotificationsPage());
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Ayarlar',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 230, 226, 226),
                ),
              ),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {
                Get.to(
                    () => SettingsPage(
                          token: Get.find<LoginController>().token.value,
                          email: Get.find<StudentController>().email,
                        ),
                    transition: Transition.rightToLeft);
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
