// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'dart:math';

class TotalNetAnalysisPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String courseName;

  const TotalNetAnalysisPage(
      {Key? key, required this.data, required this.courseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$courseName Analizi'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue.shade200,
            Colors.blueGrey.shade600,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Toplam Net Skorlar',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15), // Sağ padding eklenmiş olabilir.
                  height: 350,
                  child: LineChart(_totalNetScoreChart()),
                ),
                const SizedBox(height: 350), // Diğer içerikler
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _totalNetScoreChart() {
    int dataLength = min(data['totalNet'].length, data['exam_name'].length);

    List<FlSpot> spots = List.generate(dataLength, (index) {
      double yValue = 0;
      try {
        yValue = double.parse(data['totalNet'][index].toString());
      } catch (e) {
        print("Dönüşüm hatası: ${data['totalNet'][index]}");
      }
      return FlSpot(index.toDouble(), yValue);
    });

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              String fullName = data['exam_name'][index];
              String firstName = fullName.split(' ')[0];
              return RotatedBox(
                quarterTurns: 3,
                child: Text(
                  firstName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              );
            },
            interval: 1,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            reservedSize: 50,
            getTitlesWidget: (value, meta) => Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        drawHorizontalLine: true,
        horizontalInterval: 1,
      ),
      minX: 0,
      maxX: (data['totalNet'].length - 1).toDouble(),
      minY: 0,
      maxY: 120,
    );
  }
}
