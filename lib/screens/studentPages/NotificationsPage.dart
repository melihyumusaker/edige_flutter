// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/controllers/NotifStudentController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/utils/CustomDecorations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotifStudentController notifController =
        Get.put(NotifStudentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bildirimler',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            notifController.isLoading.value = true; // Loading başlat
            await notifController.setAllNotifsUnshownValue1(
                Get.find<StudentController>().studentId.value);
            await notifController.getUnseenNotifNumber(
                Get.find<StudentController>().studentId.value);
            await notifController.getNotifStudentByStudentId(
                Get.find<StudentController>().studentId.value);
            notifController.isLoading.value = false; // Loading bitir
            Get.back();
          },
        ),
      ),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue, Colors.purple),
        child: Obx(() {
          if (notifController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifController.notifications.isEmpty) {
            return const Center(child: Text('Hiç bildirim yok.'));
          }
          return ListView.builder(
            itemCount: notifController.notifications.length,
            itemBuilder: (context, index) {
              var notification = notifController.notifications[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: notification['is_shown']
                      ? Colors.grey[300]
                      : Colors.blue[100],
                  child: Container(
                    decoration: BoxDecoration(
                      color: notification['is_shown']
                          ? Colors.grey[300]
                          : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: notification['is_shown']
                          ? []
                          : [
                            const   BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset:  Offset(2, 2),
                              ),
                            ],
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(notification['message']),
                          subtitle: Text(notification['create_at']),
                        ),
                        if (!notification['is_shown'])
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 194, 181, 66),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'YENİ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
