import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:get/get.dart';

class TrailExamDetailPage extends StatefulWidget {
  TrailExamDetailPage({Key? key}) : super(key: key);

  @override
  State<TrailExamDetailPage> createState() => _TrailExamDetailPageState();
}

class _TrailExamDetailPageState extends State<TrailExamDetailPage> {
  List<double> weeklySummary = [4.40, 2.50, 42.42, 10.50, 100.20, 88.99, 99.10];

  late Map<String, dynamic> selectedExam;

  @override
  void initState() {
    super.initState();
    selectedExam = jsonDecode(Get.arguments.toString());
  }

  @override
  Widget build(BuildContext context) {
    List<double> dersDogruYanlis = [
      selectedExam['turkce_true'],
      selectedExam['turkce_false'],
      selectedExam['mat_true'],
      selectedExam['mat_false'],
      selectedExam['fen_true'],
      selectedExam['fen_false'],
      selectedExam['sosyal_true'],
      selectedExam['sosyal_false'],
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 172, 154, 154),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: MyBarGraph(weeklySummary: weeklySummary),
          ),
          ShowStudentNet(),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 172, 154, 154),
        centerTitle: true, // Center aligns the title
        title: Text(selectedExam['exam_name'] ?? ''),
      ),
    );
  }

  Card ShowStudentNet() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Net Değerler',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Kart başlığı rengi
              ),
            ),
            const SizedBox(height: 8.0),
            _buildNetDetail('Turkce Net', selectedExam['turkce_net']),
            _buildNetDetail('Matematik Net', selectedExam['mat_net']),
            _buildNetDetail('Fen Net', selectedExam['fen_net']),
            _buildNetDetail('Sosyal Net', selectedExam['sosyal_net']),
            const Divider(),
            _buildNetDetail('Toplam Net', _calculateTotalNet()),
          ],
        ),
      ),
    );
  }

  Widget _buildNetDetail(String subject, double? netValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$subject',
          style: TextStyle(
            fontSize: 16.0, // Yazı boyutunu ayarla
            fontWeight: FontWeight.normal, // Kalınlık
            color: Colors.black, // Yazı rengi
          ),
        ),
        Text(
          netValue?.toString() ?? '-',
          style: TextStyle(
            fontSize: 16.0, // Yazı boyutunu ayarla
            color: Colors.blueAccent, // Yazı rengi
          ),
        ),
      ],
    );
  }

  double _calculateTotalNet() {
    double turkceNet = selectedExam['turkce_net'] ?? 0.0;
    double matNet = selectedExam['mat_net'] ?? 0.0;
    double fenNet = selectedExam['fen_net'] ?? 0.0;
    double sosyalNet = selectedExam['sosyal_net'] ?? 0.0;

    return turkceNet + matNet + fenNet + sosyalNet;
  }
}

class IndividualBar {
  final int x;
  final double y;

  IndividualBar({required this.x, required this.y});
}

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  BarData(
      {required this.satAmount,
      required this.monAmount,
      required this.thurAmount,
      required this.friAmount,
      required this.sunAmount,
      required this.tueAmount,
      required this.wedAmount});

  List<IndividualBar> barData = [];

  void initalizeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tueAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thurAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount)
    ];
  }
}

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        monAmount: weeklySummary[0],
        tueAmount: weeklySummary[1],
        wedAmount: weeklySummary[2],
        thurAmount: weeklySummary[3],
        friAmount: weeklySummary[4],
        satAmount: weeklySummary[5],
        sunAmount: weeklySummary[6]);
    myBarData.initalizeBarData();

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
                getTitlesWidget: getBottomTitles),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Colors.grey[200],
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

  Widget text;

  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('T', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
