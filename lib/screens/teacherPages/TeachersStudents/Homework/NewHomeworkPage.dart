// ignore_for_file: file_names

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/widgets/TeacherStudentsHomeworksAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewHomeworkPage extends StatelessWidget {
  final int studentId;
  const NewHomeworkPage({Key? key, required this.studentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put<CourseController>(CourseController());
    final teacherController = Get.find<TeacherController>();

    TextEditingController courseNameController = TextEditingController();
    TextEditingController subjectNameController = TextEditingController();
    TextEditingController homeworkDescriptionController =
        TextEditingController();
    TextEditingController deadlineController = TextEditingController();

    Future<void> _selectDateAndTime(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          deadlineController.text = combinedDateTime.toString();
        }
      }
    }

    String formatDate(DateTime dateTime) {
      String formattedDate =
          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
      String formattedTime =
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      return "$formattedDate $formattedTime";
    }

    Widget buildTextFormField(
        TextEditingController controller, String labelText,
        {bool isMultiline = false, Function()? onTap}) {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          contentPadding: const EdgeInsets.all(12.0),
        ),
        maxLines: isMultiline ? 5 : 1,
        onTap: onTap,
      );
    }

    return Scaffold(
      appBar: TeacherStudentsHomeworksAppBar(titleText: "Ödev Ekle"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildTextFormField(courseNameController, 'Ders Adı'),
            const SizedBox(height: 16.0),
            buildTextFormField(subjectNameController, 'Konu Adı'),
            const SizedBox(height: 16.0),
            buildTextFormField(deadlineController, 'Ödev Teslim Tarihi',
                onTap: () => _selectDateAndTime(context)),
            const SizedBox(height: 16.0),
            buildTextFormField(homeworkDescriptionController, 'Ödev Açıklaması',
                isMultiline: true),
            const SizedBox(height: 16.0),
            SaveCourseButton(
                context,
                deadlineController,
                courseController,
                courseNameController,
                subjectNameController,
                homeworkDescriptionController),
          ],
        ),
      ),
    );
  }

  ElevatedButton SaveCourseButton(
      BuildContext context,
      TextEditingController deadlineController,
      CourseController courseController,
      TextEditingController courseNameController,
      TextEditingController subjectNameController,
      TextEditingController homeworkDescriptionController) {
    return ElevatedButton(
      onPressed: () async {
        DateTime selectedDateTime = DateTime.parse(deadlineController.text);
        String formattedDeadline =
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDateTime);

        await courseController.createHomeworkAndAssignToStudent(
            context,
            courseNameController.text,
            subjectNameController.text,
            homeworkDescriptionController.text,
            formattedDeadline,
            studentId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        disabledForegroundColor: Colors.white.withOpacity(0.38),
        disabledBackgroundColor: Colors.white.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
    );
  }
}
