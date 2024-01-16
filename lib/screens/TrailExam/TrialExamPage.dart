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
      appBar: AppBar(
        title: const Text('Deneme Sınavları'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 248, 200, 167), // AppBar rengi
      ),
      backgroundColor: Color.fromARGB(255, 248, 200, 167), // Arka plan rengi
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var exam in Get.find<TrialExamController>().studentTrialExams)
              InkWell(
                onTap: () {
                  // Seçilen sınavın bilgilerini bir String'e dönüştür
                  String examDetails = jsonEncode(exam);
                  Get.find<TrialExamController>().selectedExamDetail.value =
                      exam;

                  // Diğer sayfaya yönlendirme işlemi
                  Get.toNamed('/TrialExamDetailPage', arguments: examDetails);
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  color: Colors.white, // Card rengi
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sınav Adı: ${exam["exam_name"]}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Başlık rengi
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Tarih: ${exam["date"]}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
