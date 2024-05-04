// ignore_for_file: avoid_print, file_names

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LessonController extends GetxController {
  final RxList<String> grades = RxList<String>();

  RxList<String> filteredLessonNames = <String>[].obs;
  RxList<String> filteredSublessonNames = <String>[].obs;
  RxList<String> filteredSublessonNameDetails = <String>[].obs;

  RxString selectedGrade = ''.obs;
  RxString selectedLessonName = ''.obs;
  RxString selectedSublessonName = ''.obs;

  RxList<Map<String, dynamic>> allLessons = <Map<String, dynamic>>[].obs;

  RxString selectedTextGrade = ''.obs;
  RxString selectedTextLessonName = ''.obs;
  RxString selectedTextSubLessonName = ''.obs;
  RxString selectedTextSublessonDetailName = ''.obs;

  var isLoading = false.obs;

  Future<void> fetchAllLessons() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getAllLessons}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<TeacherController>().token.value}',
      },
    );

    if (response.statusCode == 200) {
      print('fetchAllLessons çalıştı 200 döndü');
      List<dynamic> responseData = jsonDecode(response.body);
      allLessons.assignAll(responseData.cast<Map<String, dynamic>>());

      print(allLessons);
    } else {
      print('fetchAllLessons çalışmadi');
    }
  }

  Future<void> fetchGrades() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.grades}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<TeacherController>().token.value}',
      },
    );

    if (response.statusCode == 200) {
      print('fetchGrades çalıştı 200 döndü');
      grades.value = List<String>.from(json.decode(response.body));
      print(grades);
    } else {
      print('fetchGrades çalışmadi');
    }
  }

  Future<void> fetchAllLessonsAndFetchGrades() async {
    isLoading.value = true;
    await fetchAllLessons();
    await fetchGrades();
    isLoading.value = false;
  }

  void filterLessonsByGrade(String grade) {
    selectedGrade.value = grade;
    var filteredLessons =
        allLessons.where((lesson) => lesson['grade'] == grade).toList();
    filteredLessonNames.value = filteredLessons
        .map((lesson) => lesson['lesson_name'].toString())
        .toSet()
        .toList();
  }

  void filterSublessonsByGradeAndLessonName(String grade, String lessonName) {
    selectedLessonName.value = lessonName;
    var filteredSublessons = allLessons
        .where((lesson) =>
            lesson['grade'] == grade && lesson['lesson_name'] == lessonName)
        .toList();
    filteredSublessonNames.value = filteredSublessons
        .map((lesson) => lesson['sublesson_name'].toString())
        .toSet()
        .toList();
  }

  void filterSublessonNameDetails(
      String grade, String lessonName, String sublessonName) {
    var filteredDetails = allLessons
        .where((lesson) =>
            lesson['grade'] == grade &&
            lesson['lesson_name'] == lessonName &&
            lesson['sublesson_name'] == sublessonName)
        .toList();
    filteredSublessonNameDetails.value = filteredDetails
        .map((lesson) => lesson['sublesson_name_detail'].toString())
        .toSet()
        .toList();
  }

  RxBool isGradeDropdownEnabled = true.obs;
  RxBool isLessonNameDropdownEnabled = false.obs;
  RxBool isSublessonNameDropdownEnabled = false.obs;
  RxBool isSublessonDetailDropdownEnabled = false.obs;

  void enableLessonNameDropdown() {
    isGradeDropdownEnabled.value = false;
    isLessonNameDropdownEnabled.value = true;
  }

  void enableSublessonNameDropdown() {
    isLessonNameDropdownEnabled.value = false;
    isSublessonNameDropdownEnabled.value = true;
  }

  void enableSublessonDetailDropdown() {
    isSublessonNameDropdownEnabled.value = false;
    isSublessonDetailDropdownEnabled.value = true;
  }

  void disableAllDropdowns() {
    isSublessonDetailDropdownEnabled.value = false;
  }

  void enableVariables() {
    isGradeDropdownEnabled = true.obs;
    isLessonNameDropdownEnabled = false.obs;
    isSublessonNameDropdownEnabled = false.obs;
    isSublessonDetailDropdownEnabled = false.obs;

    selectedTextGrade = ''.obs;
    selectedTextLessonName = ''.obs;
    selectedTextSubLessonName = ''.obs;
    selectedTextSublessonDetailName = ''.obs;
  }
}
