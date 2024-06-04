// ignore_for_file: file_names, non_constant_identifier_names, unused_element, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LessonController.dart';
import 'package:edige/controllers/TeacherController.dart';
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
    final lessonController = Get.find<LessonController>();

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
      appBar: newHomeworkPageAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
              sinifSecmeDropDown(lessonController),
              const SizedBox(height: 16.0),
              dersAdiSecmeDropdown(lessonController, courseNameController),
              const SizedBox(height: 16.0),
              konuSecmeDropDown(lessonController, subjectNameController),
              const SizedBox(height: 16.0),
              konuAltBaslikSecmeDropDown(
                  lessonController, subjectNameController),
              const SizedBox(height: 16.0),
              buildTextFormField(courseNameController, 'Ders Adı'),
              const SizedBox(height: 16.0),
              buildTextFormField(subjectNameController, 'Konu Adı'),
              const SizedBox(height: 16.0),
              buildTextFormField(deadlineController, 'Ödev Teslim Tarihi',
                  onTap: () => _selectDateAndTime(context)),
              const SizedBox(height: 16.0),
              buildTextFormField(
                homeworkDescriptionController,
                'Ödev Açıklaması',
                isMultiline: true,
              ),
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
      ),
    );
  }

  Obx konuAltBaslikSecmeDropDown(LessonController lessonController,
      TextEditingController subjectNameController) {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Alt Ders Detayı',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
          ),
          value: null,
          items: lessonController.filteredSublessonNameDetails
              .map((String detail) {
            return DropdownMenuItem<String>(
              value: detail,
              child: Text(detail.length > 40
                  ? '${detail.substring(0, 40)}...'
                  : detail),
            );
          }).toList(),
          onChanged: lessonController.isSublessonDetailDropdownEnabled.value
              ? (String? newValue) {
                  if (newValue != null) {
                    lessonController.selectedTextSublessonDetailName.value =
                        newValue;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      subjectNameController.text =
                          "${lessonController.selectedTextSubLessonName} - $newValue";
                    });
                    lessonController.disableAllDropdowns();
                  }
                }
              : null,
          hint: const Text("Lütfen bir alt ders detayı seçin"),
        ));
  }

  Obx konuSecmeDropDown(LessonController lessonController,
      TextEditingController subjectNameController) {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Alt Ders Adı',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
          ),
          value: null,
          items: lessonController.filteredSublessonNames.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child:
                  Text(name.length > 40 ? '${name.substring(0, 40)}...' : name),
            );
          }).toList(),
          onChanged: lessonController.isSublessonNameDropdownEnabled.value
              ? (String? newValue) {
                  if (newValue != null) {
                    lessonController.selectedTextSubLessonName.value = newValue;
                    subjectNameController.text =
                        "${lessonController.selectedTextSubLessonName.value} - ${lessonController.selectedTextSublessonDetailName.value}";
                    lessonController.filterSublessonNameDetails(
                        lessonController.selectedGrade.value,
                        lessonController.selectedLessonName.value,
                        newValue);
                    lessonController.enableSublessonDetailDropdown();
                  }
                }
              : null,
          hint: const Text("Lütfen bir alt ders adı seçin"),
        ));
  }

  Obx dersAdiSecmeDropdown(LessonController lessonController,
      TextEditingController courseNameController) {
    return Obx(
      () => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Ders Adı',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
        ),
        value: null,
        items: lessonController.filteredLessonNames.map((String name) {
          lessonController.selectedTextLessonName.value = name;
          return DropdownMenuItem<String>(
            value: name,
            child:
                Text(name.length > 40 ? '${name.substring(0, 40)}...' : name),
          );
        }).toList(),
        onChanged: lessonController.isLessonNameDropdownEnabled.value
            ? (String? newValue) {
                if (newValue != null) {
                  lessonController.filterSublessonsByGradeAndLessonName(
                      lessonController.selectedGrade.value, newValue);
                  lessonController.enableSublessonNameDropdown();
                  courseNameController.text = newValue;
                }
              }
            : null,
        hint: const Text("Lütfen bir ders adı seçin"),
      ),
    );
  }

  Obx sinifSecmeDropDown(LessonController lessonController) {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Sınıf Seçiniz',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
          ),
          value: null,
          items: lessonController.isGradeDropdownEnabled.value
              ? lessonController.grades.map((String grade) {
                  lessonController.selectedTextGrade.value = grade;
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade.length > 40
                        ? '${grade.substring(0, 40)}...'
                        : grade),
                  );
                }).toList()
              : [],
          onChanged: lessonController.isGradeDropdownEnabled.value
              ? (String? newValue) {
                  if (newValue != null) {
                    lessonController.filterLessonsByGrade(newValue);
                    lessonController.enableLessonNameDropdown();
                  }
                }
              : null,
          hint: lessonController.isGradeDropdownEnabled.value
              ? const Text("Lütfen bir sınıf seçin")
              : const Text("Sınıf Seçildi"),
        ));
  }

  AppBar newHomeworkPageAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Ödev Ekle",
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Get.find<LessonController>().enableVariables();
          Navigator.pop(context);
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.blue, Colors.green],
          ),
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
