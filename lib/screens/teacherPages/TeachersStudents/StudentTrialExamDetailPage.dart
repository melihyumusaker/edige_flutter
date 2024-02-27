import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';

class StudentTrialExamDetailPage extends StatelessWidget {
  const StudentTrialExamDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Öğrencinin Deneme Sınavları',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: const Color(0xFF90CAF9),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF90CAF9),
                  Color.fromARGB(255, 104, 97, 35),
                ],
              ),
            ),
          ),
          teacherController.studentsTrialExamResults.isEmpty
              ? const Center(
                  child: Text(
                    'Öğrencinin deneme sınavı sonucu bulunamadı.',
                    textAlign: TextAlign.center, // Metni ortalama
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Kalın yazı tipi
                      letterSpacing: 1.2, // Harfler arası boşluk
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: teacherController.studentsTrialExamResults.length,
                  itemBuilder: (context, index) {
                    final examResult =
                        teacherController.studentsTrialExamResults[index];
                    return buildExamCard(examResult);
                  },
                ),
        ],
      ),
    );
  }

  Widget buildExamCard(Map<String, dynamic> examResult) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 119, 193, 253),
              Color.fromARGB(255, 137, 138, 211),
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            examResult['exam_name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText('Tarih: ${examResult['date']}',
                  fontWeight: FontWeight.bold, fontSize: 16),
              const SizedBox(height: 5), // Boşluk ekleyelim
              buildText(
                  'Türkçe: ${examResult['turkce_true']} doğru / ${examResult['turkce_false']} yanlış'),
              buildText(
                  'Matematik: ${examResult['mat_true']} doğru / ${examResult['mat_false']} yanlış'),
              buildText(
                  'Fen Bilgisi: ${examResult['fen_true']} doğru / ${examResult['fen_false']} yanlış'),
              buildText(
                  'Sosyal Bilgiler: ${examResult['sosyal_true']} doğru / ${examResult['sosyal_false']} yanlış'),
              const SizedBox(height: 5), // Boşluk ekleyelim
              buildText('Türkçe Net: ${examResult['turkce_net']}'),
              buildText('Matematik Net: ${examResult['mat_net']}'),
              buildText('Fen Bilgisi Net: ${examResult['fen_net']}'),
              buildText('Sosyal Bilgiler Net: ${examResult['sosyal_net']}'),
              buildText(
                'Toplam Net: ${examResult['turkce_net'] + examResult['mat_net'] + examResult['fen_net'] + examResult['sosyal_net']}',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText(
    String text, {
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 14,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
