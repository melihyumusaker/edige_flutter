// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StudentMessageController extends GetxController {
  var messageLists = [].obs;
  var isLoading = true.obs;

  final StreamController<List<dynamic>> _messageStreamController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get messageStream => _messageStreamController.stream;

  var getMessageStreamWhileCondition = true.obs;

  final LoginController studentController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    messageList(
      int.parse(studentController.user_id.value),
      studentController.token.value,
    );
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
}
