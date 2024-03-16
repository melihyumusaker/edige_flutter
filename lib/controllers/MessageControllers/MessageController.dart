// ignore_for_file: avoid_print, file_names

import 'dart:async';
import 'dart:convert';
import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edige/config/api_config.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  var messageLists = [].obs;
  var isLoading = true.obs;

  final StreamController<List<dynamic>> _messageStreamController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get messageStream => _messageStreamController.stream;

  final TeacherController teacherController = Get.find<TeacherController>();

  var getMessageStreamWhileCondition = true.obs;

  @override
  void onInit() {
    super.onInit();
    messageList(
      int.parse(teacherController.user_id.value),
      teacherController.token.value,
    );
    teacherController.showStudents();
  }

  @override
  void onClose() {
    _messageStreamController.close();
    super.onClose();
  }

  Future<void> getMessageStream(String token, int senderId, int receiverId,
      StreamController<List<dynamic>> messageStreamController) async {
    while (true) {
      if (getMessageStreamWhileCondition.value == false) {
        break;
      }
      await Future.delayed(const Duration(seconds: 2));
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.messageHistory}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'senderId': senderId,
          'receiverId': receiverId,
          'page': 0,
          'size': 30,
        }),
      );

      if (response.statusCode == 200) {
        print(
            'bir sıkıntı yok getMessageStream çalışıyor${response.statusCode}');
        List<dynamic> messages = jsonDecode(response.body);
        messageStreamController.sink.add(messages);
      } else {
        print('bir sıkıntı oldu ${response.statusCode}');
      }
    }
  }

  Future<void> messageList(int userId, String token) async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.messageList}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü messageList method çalıştı");
      messageLists.value = jsonDecode(response.body);
      update();
    } else {
      print("problem messageList ${response.body}");
    }

    isLoading.value = false;
  }

  Future<void> createMessage(
    int senderId,
    int receiverId,
    String messageContent,
    String token,
  ) async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createMessage}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageContent': messageContent
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü createMessage method çalıştı");
      showSuccessDialog();
      update();
    } else {
      print("problem createMessage ${response.body}");
      showErrorDialog();
    }

    isLoading.value = false;
  }

   Future<void> sendMessage(
    int senderId,
    int receiverId,
    String messageContent,
    String token,
  ) async {

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createMessage}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageContent': messageContent
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü createMessage method çalıştı");
      update();
    } else {
      print("problem createMessage ${response.body}");
    }

  }

  Future<void> deleteAllMessages(
    int senderId,
    int receiverId,
    String token,
  ) async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteAllMessages}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'sender_id': senderId,
        'receiver_id': receiverId,
      }),
    );

    if (response.statusCode == 200) {
      print("200 döndü deleteAllMessages method çalıştı");
      update();
    } else {
      print("problem deleteAllMessages ${response.body}");
    }

    isLoading.value = false;
  }

  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Başarılı'),
        content: const Text('İşlem başarıyla gerçekleştirildi.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hata'),
        content: const Text('İşlem sırasında bir hata oluştu'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

}