// ignore_for_file: file_names, non_constant_identifier_names, library_private_types_in_public_api

import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpdateWeeklyProgramPage extends StatefulWidget {
  final int studentId;
  final int weeklyProgramId;
  final String lessonName;
  final String lessonStartHour, lessonEndHour;

  const UpdateWeeklyProgramPage({
    Key? key,
    required this.weeklyProgramId,
    required this.lessonName,
    required this.lessonStartHour,
    required this.lessonEndHour,
    required this.studentId,
  }) : super(key: key);

  @override
  _UpdateWeeklyProgramPageState createState() =>
      _UpdateWeeklyProgramPageState();
}

class _UpdateWeeklyProgramPageState extends State<UpdateWeeklyProgramPage> {
  final taskNameController = TextEditingController();
  final lessonStartHourController = TextEditingController();
  final lessonEndHourController = TextEditingController();

  final weeklyProgramController =
      Get.put<WeeklyProgramController>(WeeklyProgramController());

  final teacherController = Get.put<TeacherController>(TeacherController());

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.lessonName;
    lessonStartHourController.text = widget.lessonStartHour;
    lessonEndHourController.text = widget.lessonEndHour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewWeeklyProgramAppBar(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomDecorations.buildGradientBoxDecoration(
              Colors.blue,
              Colors.purple,
            ).gradient,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              TaskNameTextField(),
              const SizedBox(height: 20.0),
              LessonStartHourTextField(),
              const SizedBox(height: 20.0),
              LessonEndHourTextField(),
              const SizedBox(height: 20.0),
              LessonSaveButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3)
            ],
          ),
        ),
      ),
    );
  }

  AppBar NewWeeklyProgramAppBar() {
    return AppBar(
      title: const Text(
        'Ders Programını Güncelle',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: CustomDecorations.buildGradientBoxDecoration(
          Colors.blue,
          Colors.purple,
        ),
      ),
    );
  }

  TextField TaskNameTextField() {
    return TextField(
      controller: taskNameController,
      decoration: InputDecoration(
        labelText: 'Görev Giriniz',
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  TextField LessonStartHourTextField() {
    return TextField(
      controller: lessonStartHourController,
      decoration: InputDecoration(
        labelText: 'Ders Başlama Saati',
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (text.length <= 2) {
            return TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          } else {
            return TextEditingValue(
              text: '${text.substring(0, 2)}:${text.substring(2)}',
              selection: TextSelection.collapsed(offset: text.length + 1),
            );
          }
        }),
      ],
      style: const TextStyle(color: Colors.white),
    );
  }

  TextField LessonEndHourTextField() {
    return TextField(
      controller: lessonEndHourController,
      decoration: InputDecoration(
        labelText: 'Ders Bitiş Saati',
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (text.length <= 2) {
            return TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          } else if (text.length <= 5) {
            return TextEditingValue(
              text: '${text.substring(0, 2)}:${text.substring(2)}',
              selection: TextSelection.collapsed(offset: text.length + 1),
            );
          } else {
            return TextEditingValue(
              text: text.substring(0, 5),
              selection: const TextSelection.collapsed(offset: 5),
            );
          }
        }),
      ],
      style: const TextStyle(color: Colors.white),
    );
  }

  Center LessonSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          String lessonName = taskNameController.text;
          String lessonStartHour = lessonStartHourController.text;
          String lessonEndHour = lessonEndHourController.text;

          await weeklyProgramController.updateWeeklyProgram(
            context,
            widget.weeklyProgramId,
            lessonName,
            lessonStartHour,
            lessonEndHour,
          );

          await teacherController
              .fetchWeeklyProgramByStudentId(widget.studentId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Text(
            'Kaydet',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
