// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MeetingController extends GetxController {
  RxList<Map<String, dynamic>> studentAndTeacherSpecialMeetings =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> teacherAllMeetings =
      <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

var unShownMeetingNumber = 0.obs;

  Future<void> getStudentAndTeacherSpecialMeetings(
      int studentId, int teacherId, String token) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.getStudentAndTeacherSpecialMeetings}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'student_id': studentId, 'teacher_id': teacherId}),
      );

      if (response.statusCode == 200) {
        print("getStudentAndTeacherSpecialMeetings çalıştı");
        List<dynamic> responseData = jsonDecode(response.body);
        studentAndTeacherSpecialMeetings
            .assignAll(responseData.cast<Map<String, dynamic>>());
      } else if (response.statusCode == 204) {
        studentAndTeacherSpecialMeetings.assignAll(<Map<String, dynamic>>[]);
        print("getStudentTrialExams çalişti, ancak veri bulunamadi.");
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print(" getStudentAndTeacherSpecialMeetings Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTeacherAllMeetings(int teacherId, String token) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getTeacherAllMeetings}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'teacher_id': teacherId}),
      );

      if (response.statusCode == 200) {
        print("getTeacherAllMeetings çalıştı");
        List<dynamic> responseData = jsonDecode(response.body);
        teacherAllMeetings.assignAll(responseData.cast<Map<String, dynamic>>());
      } else if (response.statusCode == 204) {
        studentAndTeacherSpecialMeetings.assignAll(<Map<String, dynamic>>[]);
        print("getTeacherAllMeetings çalişti, ancak veri bulunamadi.");
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print(" getTeacherAllMeetings Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMeeting(int meetingId, String token) async {
    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteMeeting}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'meeting_id': meetingId}),
      );
      if (response.statusCode == 200) {
        print("deleteMeeting çalıştı");
        update();
      }
    } catch (e) {
      print("deleteMeeting Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMeeting(
      int studentId,
      int teacherId,
      String title,
      String description,
      String startDay,
      String startHour,
      String location) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createMeeting}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<TeacherController>().token.value}'
        },
        body: jsonEncode({
          'student_id': studentId,
          'teacher_id': teacherId,
          'title': title,
          'description': description,
          'start_day': startDay,
          'start_hour': startHour,
          'location': location
        }),
      );

      if (response.statusCode == 200) {
        print("createMeeting çalıştı");
        update();
      } else {
        print('Bir sıkıntı oldu create meetingde');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print("createMeeting Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateMeeting({
  required int meetingId,
  int? isStudentJoin,
  int? isParentJoin,
  String? title,
  String? description,
  String? startDay,
  String? startHour,
  String? location,
  String? teacherComment,
}) async {
  try {
    isLoading.value = true;

    // Sadece null olmayan değerleri ekliyoruz
    final Map<String, dynamic> requestBody = {
      'meeting_id': meetingId,
    };

    if (isStudentJoin != null) requestBody['is_student_join'] = isStudentJoin;
    if (isParentJoin != null) requestBody['is_parent_join'] = isParentJoin;
    if (title != null) requestBody['title'] = title;
    if (description != null) requestBody['description'] = description;
    if (startDay != null) requestBody['start_day'] = startDay;
    if (startHour != null) requestBody['start_hour'] = startHour;
    if (location != null) requestBody['location'] = location;
    if (teacherComment != null) requestBody['teacher_comment'] = teacherComment;

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateMeeting}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Get.find<TeacherController>().token.value}'
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("updateMeeting çalıştı");
      update();
      return true; // İşlem başarılı
    } else {
      print('Bir sıkıntı oldu updateMeeting');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      return false; // İşlem başarısız
    }
  } catch (e) {
    print("updateMeeting Exception: $e");
    return false; // İşlem başarısız
  } finally {
    isLoading.value = false;
  }
}

Future<void> unshownMeetingumber(int studentId , String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.countUnshownMeetings}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'student_id': studentId,
        }),
      );

      if (response.statusCode == 200) {
        print("unshownMeetingumber çalıştı");
        unShownMeetingNumber.value = jsonDecode(response.body);
        print(unShownMeetingNumber.value);
      } else {
        print("unshownMeetingumber Error: ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print(" unshownMeetingumber Exception: $e");
    }
  }

}
