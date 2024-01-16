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
            child: MyBarGraph(weeklySummary: dersDogruYanlis),
          ),
          SizedBox(height: 55),
          ShowStudentNet(),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 172, 154, 154),
        centerTitle: true, // Center aligns the title
        title: Text(
          selectedExam['exam_name'] ?? '',
          style: TextStyle(color: Colors.white70, fontSize: 30),
        ),
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
  final double turkce_true;
  final double turkce_false;
  final double mat_true;
  final double mat_false;
  final double sosyal_true;
  final double sosyal_false;
  final double fen_true;
  final double fen_false;

  BarData(
      {required this.turkce_true,
      required this.turkce_false,
      required this.mat_true,
      required this.mat_false,
      required this.sosyal_true,
      required this.sosyal_false,
      required this.fen_true,
      required this.fen_false});

  List<IndividualBar> barData = [];

  void initalizeBarData() {
    barData = [
      IndividualBar(x: 0, y: turkce_true),
      IndividualBar(x: 1, y: turkce_false),
      IndividualBar(x: 2, y: mat_true),
      IndividualBar(x: 3, y: mat_false),
      IndividualBar(x: 4, y: sosyal_true),
      IndividualBar(x: 5, y: sosyal_false),
      IndividualBar(x: 6, y: fen_true),
      IndividualBar(x: 7, y: fen_false)
    ];
  }
}

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        turkce_true: weeklySummary[0],
        turkce_false: weeklySummary[1],
        mat_true: weeklySummary[2],
        mat_false: weeklySummary[3],
        sosyal_true: weeklySummary[4],
        sosyal_false: weeklySummary[5],
        fen_true: weeklySummary[6],
        fen_false: weeklySummary[7]);

    myBarData.initalizeBarData();

    return BarChart(
      BarChartData(
        maxY: 40,
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
                      toY: 40,
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
      text = const Text('TD', style: style);
      break;
    case 1:
      text = const Text('TY', style: style);
      break;
    case 2:
      text = const Text('MD', style: style);
      break;
    case 3:
      text = const Text('MY', style: style);
      break;
    case 4:
      text = const Text('SD', style: style);
      break;
    case 5:
      text = const Text('SY', style: style);
      break;
    case 6:
      text = const Text('FD', style: style);
      break;
    case 7:
      text = const Text('FY', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
