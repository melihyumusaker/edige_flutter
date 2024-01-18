// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'dart:convert';

class StudentController extends GetxController {
  // Student infos
  var studentId = 0.obs;
  var school = ''.obs;
  var enneagramResult = ''.obs;
  var section = ''.obs;
  var username = ''.obs;
  var name = ''.obs;
  var surname = ''.obs;
  var email = ''.obs;
  var city = ''.obs;
  final studentsTeacher = ''.obs;
  var birthDate = DateTime.now().obs;
  var isEnneagramTestSolved = 0.obs;


  // Recommended Teacher Profiles
  final teachersExpertises = <String>[].obs;
  final teachersNames = <String>[].obs;
  final teacherSurnames = <String>[].obs;
  final teacherIds = <int>[].obs;

  Future<void> getStudentIdByUserId(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentIdByUserId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü getStudentIdByUserId method çalıştı");
      final parsedResponse = int.tryParse(response.body);
      if (parsedResponse != null) {
        studentId.value = parsedResponse;
      } else {
        studentId.value = 0;
      }
    } else {
      print("problem");
      studentId.value = 0;
    }
  }

  Future<void> getStudentInfosByStudentId(int student_id) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStudentById}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': student_id,
      }),
    );

    if (response.statusCode == 200) {
      print("problem yok 200 döndü");

      final responseData = jsonDecode(response.body);
      school.value = responseData['school'] ?? '';
      section.value = responseData['section'] ?? '';
      enneagramResult.value = responseData['enneagram_result'] ?? '';
      isEnneagramTestSolved.value =
          responseData['is_enneagram_test_solved'] ?? 0;
      studentsTeacher.value = responseData['teacher']['user']['name'] +
              " " +
              responseData['teacher']['user']['surname'] ??
          '';

      final user = responseData['user'];
      if (user != null) {
        username.value = user['username'];
        name.value = user['name'];
        surname.value = user['surname'];
        email.value = user['email'];
        city.value = user['city'];
        String birthDateString = user['birth_date'];
        birthDate.value = DateTime.parse(birthDateString);
      }
    } else {
      print("problem");
    }
  }

  Future<void> getTeachersByStudentType(String studentType) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getTeachersByStudentType}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'studentType': studentType,
      }),
    );

    if (response.statusCode == 200) {
      print("problem yok getTeachersByStudentType 200 döndü");
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final List<String> teachersExpertisesNames = data
            .map((teacherExpertise) => teacherExpertise['expertise'].toString())
            .toList();

        if (teachersExpertisesNames.isNotEmpty) {
          teachersExpertises.value = teachersExpertisesNames;
        }

        final List<String> teachersNamesNames = data
            .map((teachersName) => teachersName['user'] != null
                ? teachersName['user']['name'].toString()
                : '')
            .toList();

        if (teachersNamesNames.isNotEmpty) {
          teachersNames.value = teachersNamesNames;
        }

        final List<String> teacherSurnamesNames = data
            .map((teacherSurname) => teacherSurname['user'] != null
                ? teacherSurname['user']['surname'].toString()
                : '')
            .toList();

        if (teacherSurnamesNames.isNotEmpty) {
          teacherSurnames.value = teacherSurnamesNames;
        }

        final List<int> teacherIdsList = data
            .map((teacherId) => teacherId['teacher_id'] != null
                ? int.parse(teacherId['teacher_id'].toString())
                : 0)
            .toList();

        if (teacherIdsList.isNotEmpty) {
          teacherIds.value = teacherIdsList;
        }
      } else {
        print("Data is null or empty");
      }
    } else {
      print("getTeachersByStudentType'de problem oldu");
    }
  }

  Future<void> setStudentsEnneagramResult(
      int student_id, int teacher_id) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.setStudentsEnneagramResult}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': student_id, 'teacher_id': teacher_id}),
      );

      if (response.statusCode == 200) {
        print("Başarıyla tamamlandı");
        // Cevap başarılıysa yapılacak işlemler
      } else {
        print("Hata: ${response.statusCode}");
        // Cevap başarısızsa yapılacak işlemler
      }
    } catch (e) {
      print("Hata: $e");
      // Hata durumunda yapılacak işlemler
    }
  }
}
