import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/controllers/TrialExamController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateTrialExam extends StatefulWidget {
  final int studentId;
  final int trialExamId;
  Map<String, dynamic> examResult;
  UpdateTrialExam({
    Key? key,
    required this.trialExamId,
    required this.examResult,
    required this.studentId,
  }) : super(key: key);

  @override
  State<UpdateTrialExam> createState() => _UpdateTrialExamState();
}

class _UpdateTrialExamState extends State<UpdateTrialExam> {
  @override
  void initState() {
    super.initState();
    dateController.text = widget.examResult['date'];
    turkceTrueController.text = widget.examResult['turkce_true'].toString();
    turkceFalseController.text = widget.examResult['turkce_false'].toString();
    matTrueController.text = widget.examResult['mat_true'].toString();
    matFalseController.text = widget.examResult['mat_false'].toString();
    fenTrueController.text = widget.examResult['fen_true'].toString();
    fenFalseController.text = widget.examResult['fen_false'].toString();
    sosyalTrueController.text = widget.examResult['sosyal_true'].toString();
    sosyalFalseController.text = widget.examResult['sosyal_false'].toString();
    examNameController.text = widget.examResult['exam_name'].toString();
  }

  final TextEditingController turkceTrueController = TextEditingController();
  final TextEditingController turkceFalseController = TextEditingController();
  final TextEditingController matTrueController = TextEditingController();
  final TextEditingController matFalseController = TextEditingController();
  final TextEditingController fenTrueController = TextEditingController();
  final TextEditingController fenFalseController = TextEditingController();
  final TextEditingController sosyalTrueController = TextEditingController();
  final TextEditingController sosyalFalseController = TextEditingController();
  final TextEditingController examNameController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sınav Soncunu Güncelle',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 166, 154),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 235, 166, 154),
              Color.fromARGB(255, 81, 163, 201)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                trialExamDateTimePicker(context, selectedDate, dateController),
                const SizedBox(height: 12.0),
                buildTextField('Türkçe Doğru', turkceTrueController),
                const SizedBox(height: 12.0),
                buildTextField('Türkçe Yanlış', turkceFalseController),
                const SizedBox(height: 12.0),
                buildTextField('Matematik Doğru', matTrueController),
                const SizedBox(height: 12.0),
                buildTextField('Matematik Yanlış', matFalseController),
                const SizedBox(height: 12.0),
                buildTextField('Fen Bilimleri Doğru', fenTrueController),
                const SizedBox(height: 12.0),
                buildTextField('Fen Bilimleri Yanlış', fenFalseController),
                const SizedBox(height: 12.0),
                buildTextField('Sosyal Bilimler Doğru', sosyalTrueController),
                const SizedBox(height: 12.0),
                buildTextField('Sosyal Bilimler Yanlış', sosyalFalseController),
                const SizedBox(height: 12.0),
                trialExamNameTextField(examNameController),
                const SizedBox(height: 24.0),
                trialExamSaveButton(
                  turkceTrueController,
                  turkceFalseController,
                  matTrueController,
                  matFalseController,
                  fenTrueController,
                  fenFalseController,
                  sosyalTrueController,
                  sosyalFalseController,
                  examNameController,
                  dateController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell trialExamDateTimePicker(BuildContext context, DateTime selectedDate,
      TextEditingController dateController) {
    return InkWell(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        ).then((pickedDate) {
          if (pickedDate != null) {
            selectedDate = pickedDate;
            dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
          }
        });
      },
      child: IgnorePointer(
        child: TextField(
          controller: dateController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Tarih',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return SizedBox(
      height: 65.0,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9]'),
          ),
          LengthLimitingTextInputFormatter(2),
        ],
      ),
    );
  }

  TextField trialExamNameTextField(TextEditingController examNameController) {
    return TextField(
      controller: examNameController,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Sınav Adı',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget trialExamSaveButton(
    TextEditingController turkceTrueController,
    TextEditingController turkceFalseController,
    TextEditingController matTrueController,
    TextEditingController matFalseController,
    TextEditingController fenTrueController,
    TextEditingController fenFalseController,
    TextEditingController sosyalTrueController,
    TextEditingController sosyalFalseController,
    TextEditingController examNameController,
    TextEditingController dateController,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 214, 191, 243),
            Color.fromARGB(255, 61, 120, 134)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (turkceTrueController.text.isEmpty ||
              turkceFalseController.text.isEmpty ||
              matTrueController.text.isEmpty ||
              matFalseController.text.isEmpty ||
              fenTrueController.text.isEmpty ||
              fenFalseController.text.isEmpty ||
              sosyalTrueController.text.isEmpty ||
              sosyalFalseController.text.isEmpty ||
              examNameController.text.isEmpty ||
              dateController.text.isEmpty) {
            Get.snackbar(
              'Uyarı',
              'Lütfen tüm alanları doldurunuz.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              margin: const EdgeInsets.only(bottom: 20.0),
            );
          } else {
            await Get.find<TrialExamController>().updateTrialExam(
              trialExamId: widget.trialExamId,
              date: dateController.text,
              turkceTrue: double.tryParse(turkceTrueController.text) ?? 0.0,
              turkceFalse: double.tryParse(turkceFalseController.text) ?? 0.0,
              matTrue: double.tryParse(matTrueController.text) ?? 0.0,
              matFalse: double.tryParse(matFalseController.text) ?? 0.0,
              fenTrue: double.tryParse(fenTrueController.text) ?? 0.0,
              fenFalse: double.tryParse(fenFalseController.text) ?? 0.0,
              sosyalTrue: double.tryParse(sosyalTrueController.text) ?? 0.0,
              sosyalFalse: double.tryParse(sosyalFalseController.text) ?? 0.0,
              examName: examNameController.text,
            );
          }

          Get.find<TeacherController>()
              .getStudentTrialExamsByTeacher(widget.studentId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onSurface: Colors.white,
        ),
        child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
