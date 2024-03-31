// ignore_for_file: file_names, unused_import

import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphicAnalysisDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String courseName;

  const GraphicAnalysisDetailPage(
      {Key? key, required this.data, required this.courseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('$courseName Analizi'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade200),
      body: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue.shade200, Colors.blueGrey.shade600),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Doğru ve Yanlış Cevaplar',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  height: 350,
                  child: LineChart(
                    _trueFalseChart(data['true'], data['false']),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Net Skorlar',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  height: 350,
                  child: LineChart(
                    _netScoreChart(data['net']),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _trueFalseChart(
      List<double> trueAnswers, List<double> falseAnswers) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: trueAnswers
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: Colors.green,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: falseAnswers
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: Colors.red,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 2),
      ),
      titlesData: _titlesData,
      gridData: _gridData,
      minY: 0,
      maxY: 40,
    );
  }

  LineChartData _netScoreChart(List<double> netScores) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: netScores
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: Colors.blue,
          barWidth: 4,
        ),
      ],
      borderData: FlBorderData(
        show: true,
        border:
            Border.all(color: const Color.fromARGB(255, 3, 26, 44), width: 2),
      ),
      titlesData: _titlesData,
      gridData: _gridData,
      minY: 0,
      maxY: 40,
      minX: 0,
      maxX: (netScores.length - 1).toDouble(),
    );
  }

  FlTitlesData get _titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              if (index >= 0 && index < data['exam_name'].length) {
                String fullName = data['exam_name'][index];
                String firstName = fullName.split(' ')[0];
                return RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    firstName,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              } else {
                return const Text('');
              }
            },
            interval: 1,
          ),
        ),
        // Diğer eksenlerin tanımlamaları aynı kalacak.
      );
}

FlGridData get _gridData => FlGridData(
      show: true,
      drawHorizontalLine: true,
      horizontalInterval: 5, // Yatay çizgilerin aralığı
      drawVerticalLine: true,
      verticalInterval: 1, // Dikey çizgilerin aralığı
    );
