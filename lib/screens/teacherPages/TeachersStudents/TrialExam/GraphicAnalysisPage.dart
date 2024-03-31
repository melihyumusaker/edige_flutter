// ignore_for_file: file_names, avoid_print

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/GraphicAnalysisDetailPage.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TrialExam/TotalNetAnalysisPage.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GraphicAnalysisPage extends StatelessWidget {
  const GraphicAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: graphicAnalysisPageAppBar(),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
          Colors.blue.shade200,
          Colors.blueGrey.shade600,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnalysisButton(
                  context, "Fen Bilgileri Analiz", "Fen Bilimleri"),
              const SizedBox(height: 20),
              _buildAnalysisButton(context, "Matematik Analiz", "Matematik"),
              const SizedBox(height: 20),
              _buildAnalysisButton(
                  context, "Sosyal Bilgileri Analiz", "Sosyal Bilimleri"),
              const SizedBox(height: 20),
              _buildAnalysisButton(context, "Türkçe Analiz", "Türkçe"),
              const SizedBox(height: 20),
              _buildAnalysisButton(context, "Toplam Net Analiz", "Toplam Net"),
            ],
          ),
        ),
      ),
    );
  }

  AppBar graphicAnalysisPageAppBar() {
    return AppBar(
      title: const Text(
        'Analiz',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue.shade200,
    );
  }

  Widget _buildAnalysisButton(
      BuildContext context, String title, String courseName) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.lightBlue.shade400,
            Colors.lightBlue.shade700,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final analysisData = _extractAnalysisData(title);
          if (title == "Toplam Net Analiz") {
            Get.to(
                () => TotalNetAnalysisPage(
                      data: analysisData,
                      courseName: courseName,
                    ),
                transition: Transition.rightToLeft);
          } else {
            Get.to(
              () => GraphicAnalysisDetailPage(
                data: analysisData,
                courseName: courseName,
              ),
              transition: Transition.rightToLeft,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Map<String, dynamic> _extractAnalysisData(String analysisType) {
  List<Map<String, dynamic>> studentsTrialExamResults =
      Get.find<TeacherController>().studentsTrialExamResults;

  List<double> trueAnswers = [];
  List<double> falseAnswers = [];
  List<double> netScores = [];
  List<String> examNames = [];
  List<double> totalNetScores = [];

  for (var exam in studentsTrialExamResults) {
    switch (analysisType) {
      case "Fen Bilgileri Analiz":
        trueAnswers.add(exam['fen_true']);
        falseAnswers.add(exam['fen_false']);
        netScores.add(exam['fen_net']);
        examNames.add(exam['exam_name']);
        break;
      case "Matematik Analiz":
        trueAnswers.add(exam['mat_true']);
        falseAnswers.add(exam['mat_false']);
        netScores.add(exam['mat_net']);
        examNames.add(exam['exam_name']);
        break;
      case "Sosyal Bilgileri Analiz":
        trueAnswers.add(exam['sosyal_true']);
        falseAnswers.add(exam['sosyal_false']);
        netScores.add(exam['sosyal_net']);
        examNames.add(exam['exam_name']);
        break;
      case "Türkçe Analiz":
        trueAnswers.add(exam['turkce_true']);
        falseAnswers.add(exam['turkce_false']);
        netScores.add(exam['turkce_net']);
        examNames.add(exam['exam_name']);
        break;
      case "Toplam Net Analiz":
        totalNetScores.add(exam['net']);
        examNames.add(exam['exam_name']);
        break;
    }
  }

  if (analysisType == "Toplam Net Analiz") {
    print(studentsTrialExamResults[0]['net']);
    return {
      "exam_name": examNames,
      "totalNet": totalNetScores,
    };
  } else {
    return {
      "true": trueAnswers,
      "false": falseAnswers,
      "net": netScores,
      "exam_name": examNames
    };
  }
}
