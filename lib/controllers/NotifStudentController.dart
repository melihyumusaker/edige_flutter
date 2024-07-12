// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotifStudentController extends GetxController {
  var notifications = <dynamic>[].obs;
  var unseenNotifNumber = 0.obs;
  var isLoading = false.obs;

  Future<void> getNotifStudentByStudentId(int studentId) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.getNotifStudentByStudentId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        notifications.value = responseData; // Gelen yanıt listeye atanıyor
        print("getNotifStudentByStudentId çalıştı");
      } else {
        print("Response status code: ${response.statusCode}");
      }
    } catch (e) {
      print("getNotifStudentByStudentId Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUnseenNotifNumber(int studentId) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getUnseenNotifNumber}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        unseenNotifNumber.value =
            jsonDecode(response.body); // Gelen yanıt doğrudan atanıyor
      } else {
        print(
            "getUnseenNotifNumber Response status code: ${response.statusCode}");
      }
    } catch (e) {
      print("getUnseenNotifNumber Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setAllNotifsUnshownValue1(int studentId) async {
    isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.setAllNotifsUnshownValue1}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({'student_id': studentId}),
      );

      if (response.statusCode == 200) {
        print("setAllNotifsUnshownValue1 başarılı");
      } else {
        print(
            "setAllNotifsUnshownValue1 Response status code: ${response.statusCode}");
      }
    } catch (e) {
      print("setAllNotifsUnshownValue1 Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
