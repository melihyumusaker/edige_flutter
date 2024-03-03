import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class NewWeeklyProgramPage extends StatefulWidget {
  final int studentId;
  const NewWeeklyProgramPage({Key? key, required this.studentId})
      : super(key: key);

  @override
  _NewWeeklyProgramPageState createState() => _NewWeeklyProgramPageState();
}

class _NewWeeklyProgramPageState extends State<NewWeeklyProgramPage> {
  final weeklyProgramController =
      Get.put<WeeklyProgramController>(WeeklyProgramController());
  final teacherController = Get.find<TeacherController>();
  String? dropdownValue;

  final taskNameController = TextEditingController();
  final lessonStartHourController = TextEditingController();
  final lessonEndHourController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    lessonStartHourController.dispose();
    lessonEndHourController.dispose();
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskNameTextField(),
              const SizedBox(height: 20.0),
              DayDropDown(context),
              const SizedBox(height: 20.0),
              LessonStartHourTextField(),
              const SizedBox(height: 20.0),
              LessonEndHourTextField(),
              const SizedBox(height: 20.0),
              LessonSaveButton(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.4)
            ],
          ),
        ),
      ),
    );
  }

  Center LessonSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          String lessonName = taskNameController.text;
          String day = dropdownValue ?? ""; // Dropdown value null kontrolü
          String lessonStartHour = lessonStartHourController.text;
          String lessonEndHour = lessonEndHourController.text;

          if (lessonName.isEmpty ||
              day.isEmpty ||
              lessonStartHour.isEmpty ||
              lessonEndHour.isEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Hata'),
                  content: Text('Tüm alanları doldurunuz.'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          } else {
            await weeklyProgramController.createWeeklyProgram(
                context,
                widget.studentId,
                lessonName,
                day,
                lessonStartHour,
                lessonEndHour);
            await teacherController
                .fetchWeeklyProgramByStudentId(widget.studentId);
          }
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
            // Boş değerleri kabul et
            return newValue;
          }

          // İlk iki sayıyı al ve ":" ekleyerek formatla
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
            // Maksimum 5 karakteri aşarsa son 3 karakteri al
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
            // Boş değerleri kabul et
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

  Container DayDropDown(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          padding: const EdgeInsets.all(5),
          borderRadius: BorderRadius.circular(15),
          border: const BorderSide(
            color: Colors.white70,
            width: 5,
          ),
          dropdownButtonColor: Colors.transparent,
          value: dropdownValue,
          hint: const Text(
            "Gün Seçiniz",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.arrow_drop_down_circle_sharp,
              color: Colors.white70),
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue.toString();
            });
          },
          items: [
            'Pazartesi',
            'Sali',
            'Carsamba',
            'Persembe',
            'Cuma',
            'Cumartesi',
            'Pazar'
          ].map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
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

  AppBar NewWeeklyProgramAppBar() {
    return AppBar(
      title: const Text(
        'Ders Programı Ekle',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
    );
  }
}
