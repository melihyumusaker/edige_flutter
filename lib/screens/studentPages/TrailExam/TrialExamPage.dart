// ignore_for_file: non_constant_identifier_names, file_names, invalid_use_of_protected_member

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TrialExamController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class TrialExamPage extends StatelessWidget {
  const TrialExamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TrialExamController());
    Get.put(StudentController());

    return Scaffold(
      appBar: TrialExamPageAppBar(),
      backgroundColor: const Color.fromARGB(255, 161, 217, 240),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () {
            var controller = Get.find<TrialExamController>();

            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var reversedExam = Get.find<TrialExamController>()
                .studentTrialExams
                .value
                .reversed
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reversedExam.length,
                    itemBuilder: (context, index) {
                      var exam = reversedExam[index];
                      return InkWell(
                        onTap: () async {
                          // Seçilen sınavın bilgilerini bir String'e dönüştür
                          String examDetails = jsonEncode(exam);

                          Get.find<TrialExamController>()
                              .selectedExamDetail
                              .value = exam;

                          await Get.find<TrialExamController>()
                              .updateTrialExamIsShownValue(
                            trialExamId: exam['trial_exam_id'],
                            token: Get.find<LoginController>().token.value,
                          );

                          await Get.find<TrialExamController>().countUnshown(
                            studentId:
                                Get.find<StudentController>().studentId.value,
                            token: Get.find<LoginController>().token.value,
                          );

                          Get.toNamed('/TrialExamDetailPage',
                              arguments: examDetails);
                        },
                        child: trialExamInfoCard(exam),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar TrialExamPageAppBar() {
    return AppBar(
      title: const Text(
        'Deneme Sınavları',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 161, 217, 240), // AppBar rengi
    );
  }

  Card trialExamInfoCard(Map<String, dynamic> exam) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color.fromARGB(255, 44, 87, 107), // Card rengi
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sınav Adı: ${exam["exam_name"]}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60 // Başlık rengi
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Tarih: ${exam["date"]}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          if (exam["is_shown"] == 0)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'YENİ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
