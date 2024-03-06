// ignore_for_file: non_constant_identifier_names, file_names

import 'package:edige/controllers/TrialExamController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/SetStudentTrialExamPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/UpdateTrialExam.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';

class StudentTrialExamDetailPage extends StatelessWidget {
  final int student_id;
  const StudentTrialExamDetailPage({Key? key, required this.student_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    final trialExamController =
        Get.put<TrialExamController>(TrialExamController());

    return Scaffold(
      appBar: trialExamPageAppBar(),
      body: Stack(
        children: [
          linearGradientWidget(),
          Obx(() {
            if (teacherController.studentsTrialExamResults.isEmpty) {
              return ListEmptyTextWidget();
            } else {
              return trialExamResults(teacherController, trialExamController);
            }
          }),
        ],
      ),
    );
  }

  AppBar trialExamPageAppBar() {
    return AppBar(
      title: const Text(
        'Öğrencinin Deneme Sınavları',
        style: TextStyle(color: Colors.white70),
      ),
      backgroundColor: const Color(0xFF90CAF9),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 112, 22, 214),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                Get.to(() => SetStudentTrialExamPage(studentId: student_id));
              },
            ),
          ),
        )
      ],
    );
  }

  ListView trialExamResults(TeacherController teacherController,
      TrialExamController trialExamController) {
    return ListView.builder(
      itemCount: teacherController.studentsTrialExamResults.length,
      itemBuilder: (context, index) {
        final examResult = teacherController.studentsTrialExamResults[index];
        return buildExamCard(examResult, trialExamController, context);
      },
    );
  }

  Center ListEmptyTextWidget() {
    return const Center(
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
    );
  }

  Container linearGradientWidget() {
    return Container(
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
    );
  }

  Widget buildExamCard(
    Map<String, dynamic> examResult,
    TrialExamController trialExamController,
    BuildContext context,
  ) {
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
                'Toplam Net: ${examResult['net']}',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  roundedIconButton(
                    Icons.edit,
                    () {
                      Get.to(
                        () => UpdateTrialExam(
                          studentId: student_id,
                          trialExamId: examResult['trial_exam_id'],
                          examResult: examResult,
                        ),
                      );
                    },
                    'Güncelle',
                    Colors.white,
                    Colors.blueAccent,
                  ),
                  roundedIconButton(
                    Icons.delete,
                    () async {
                      await trialExamController.deleteTrialExamByTeacher(
                          examResult['trial_exam_id'], context);
                      await Get.find<TeacherController>()
                          .getStudentTrialExamsByTeacher(student_id);
                    },
                    'Sil',
                    Colors.white,
                    Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundedIconButton(IconData iconData, VoidCallback onPressed,
      String tooltip, Color color, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onPressed,
        color: color,
        iconSize: 30,
        splashRadius: 25,
        padding: const EdgeInsets.all(10),
        splashColor: Colors.transparent,
        tooltip: tooltip,
        constraints: const BoxConstraints(),
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
