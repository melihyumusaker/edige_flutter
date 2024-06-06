import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LessonController.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewHomeworkPage extends StatefulWidget {
  final int studentId;
  const NewHomeworkPage({Key? key, required this.studentId}) : super(key: key);

  @override
  State<NewHomeworkPage> createState() => _NewHomeworkPageState();
}

class _NewHomeworkPageState extends State<NewHomeworkPage> {
  late TextEditingController courseNameController;
  late TextEditingController subjectNameController;
  late TextEditingController homeworkDescriptionController;
  late TextEditingController deadlineController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
    subjectNameController = TextEditingController();
    homeworkDescriptionController = TextEditingController();
    deadlineController = TextEditingController();
  }

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

        setState(() {
          deadlineController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
        });
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

  Widget buildTextFormField(TextEditingController controller, String labelText,
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

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put<CourseController>(CourseController());
    final lessonController = Get.find<LessonController>();

    return Scaffold(
      appBar: newHomeworkPageAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.3,
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
    return Obx(() => DropdownButtonHideUnderline(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
                isEmpty:
                    lessonController.selectedTextSublessonDetailName.value ==
                        '',
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: lessonController
                          .selectedTextSublessonDetailName.value.isEmpty
                      ? null
                      : lessonController.selectedTextSublessonDetailName.value,
                  onChanged: lessonController
                          .isSublessonDetailDropdownEnabled.value
                      ? (String? newValue) {
                          if (newValue != null) {
                            lessonController.selectedTextSublessonDetailName
                                .value = newValue;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              subjectNameController.text =
                                  "${lessonController.selectedTextSubLessonName} - $newValue";
                            });
                            lessonController.disableAllDropdowns();
                          }
                        }
                      : null,
                  items: lessonController.filteredSublessonNameDetails
                      .map<DropdownMenuItem<String>>((String detail) {
                    return DropdownMenuItem<String>(
                      value: detail,
                      child: Text(
                        detail,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  hint: const Text("Lütfen bir alt ders detayı seçin"),
                ),
              ),
            ],
          ),
        ));
  }

  Obx konuSecmeDropDown(LessonController lessonController,
      TextEditingController subjectNameController) {
    return Obx(() => DropdownButtonHideUnderline(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                ),
                isEmpty: lessonController.selectedTextSubLessonName.value == '',
                child: DropdownButton<String>(
                  isExpanded: true,
                  value:
                      lessonController.selectedTextSubLessonName.value.isEmpty
                          ? null
                          : lessonController.selectedTextSubLessonName.value,
                  onChanged: lessonController
                          .isSublessonNameDropdownEnabled.value
                      ? (String? newValue) {
                          if (newValue != null) {
                            lessonController.selectedTextSubLessonName.value =
                                newValue;
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
                  items: lessonController.filteredSublessonNames
                      .map<DropdownMenuItem<String>>((String name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  hint: const Text("Lütfen bir alt ders adı seçin"),
                ),
              ),
            ],
          ),
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
        decoration: CustomDecorations.buildGradientBoxDecoration(
            Colors.blue, Colors.green),
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
            widget.studentId);
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
