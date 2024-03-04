// ignore_for_file: non_constant_identifier_names

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/widgets/TeacherStudentsHomeworksAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateHomeworkPage extends StatefulWidget {
  final int studentId;
  final int courseId;
  final String courseName;
  final String subcourseName;
  final String homeworkDescription;
  final int isHomeworkDone;
  final String homeworkDeadline;

  const UpdateHomeworkPage({
    Key? key,
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.subcourseName,
    required this.homeworkDescription,
    required this.isHomeworkDone,
    required this.homeworkDeadline,
  }) : super(key: key);

  @override
  State<UpdateHomeworkPage> createState() => _UpdateHomeworkPageState();
}

class _UpdateHomeworkPageState extends State<UpdateHomeworkPage> {
  late int isHomeworkDone;
  TextEditingController courseNameController = TextEditingController();
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController homeworkDescriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isHomeworkDone = widget.isHomeworkDone;
    courseNameController.text = widget.courseName;
    subjectNameController.text = widget.subcourseName;
    homeworkDescriptionController.text = widget.homeworkDescription;
    deadlineController.text = widget.homeworkDeadline;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDateAndTime(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (pickedDate != null) {
        // ignore: use_build_context_synchronously
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
      appBar: TeacherStudentsHomeworksAppBar(
        titleText: "Ödev Güncelle",
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: CustomDecorations.buildGradientBoxDecoration(
              Colors.blue, Colors.green),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              buildTextFormField(courseNameController, 'Ders Adı'),
              const SizedBox(height: 16.0),
              buildTextFormField(subjectNameController, 'Konu Adı'),
              const SizedBox(height: 16.0),
              isHomeWorkDoneRadio(),
              const SizedBox(height: 16.0),
              buildTextFormField(deadlineController, 'Ödev Teslim Tarihi',
                  onTap: () => _selectDateAndTime(context)),
              const SizedBox(height: 16.0),
              buildTextFormField(
                  homeworkDescriptionController, 'Ödev Açıklaması',
                  isMultiline: true),
              UpdateCourseButton(widget.courseId),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3)

              //   SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton UpdateCourseButton(int courseId) {
    return ElevatedButton(
      onPressed: () async {
        final String courseName = courseNameController.text;
        final String subcourseName = subjectNameController.text;
        final String homeworkDescription = homeworkDescriptionController.text;
        final String homeworkDeadline = deadlineController.text;
        final int isHomeworkDoneValue = isHomeworkDone == 1 ? 1 : 0;

        DateTime selectedDateTime = DateTime.parse(deadlineController.text);
        String formattedDeadline =
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDateTime);

        await Get.find<CourseController>().updateCourse(
          context,
          courseId,
          courseName,
          subcourseName,
          homeworkDescription,
          isHomeworkDone,
          formattedDeadline,
        );

        await Get.find<TeacherController>()
            .getAllStudentsCoursesAfterUpdate(widget.studentId);
      },
      child: const Text('Güncelle'),
    );
  }

  Row isHomeWorkDoneRadio() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Ödev Yapıldı Mı?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16.0),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isHomeworkDone = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHomeworkDone == 1
                      ? const Color.fromARGB(255, 0, 85, 155)
                      : Colors.transparent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Text('Evet', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 16.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  isHomeworkDone = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHomeworkDone == 0
                      ? const Color.fromARGB(255, 0, 85, 155)
                      : Colors.transparent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            const Text('Hayır', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
