// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/widgets/CircularPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var token = "".obs; // Observable variable to hold the token
  var refreshToken = "".obs; // Observable variable to hold the refresh token
  var user_id = "".obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRememberMe();
  }

  // Remember Me Module
  void toggleRememberMe(bool value) {
    rememberMe.value = value;
    _saveRememberMe(value);
  }

  Future<void> _saveRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  Future<void> _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rememberMe.value = prefs.getBool('rememberMe') ?? false;
  }

  // Login module
  Future<void> login() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signInEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final parsedResponse = jsonDecode(response.body);

      token.value = parsedResponse['token'];
      refreshToken.value = parsedResponse['refreshToken'];

      var tokenPayload = getTokenPayload(parsedResponse['token']);
      if (tokenPayload.length % 4 > 0) {
        tokenPayload += '=' * (4 - tokenPayload.length % 4);
      }
      final decodedPayload =
          jsonDecode(utf8.decode(base64Url.decode(tokenPayload)));

      final userId = decodedPayload['user_id'].toString();
      print('User ID: $userId'); // Eklenen satır
      Get.find<LoginController>().user_id.value = userId;

      await Get.find<StudentController>()
          .getStudentIdByUserId(int.parse(user_id.value));

      Get.off(() => const CircularPage());
    } else {
      Get.dialog(
        AlertDialog(
            title: const Text("Giriş Başarısız"),
            content: const Text('Kullanıcı adı veya şifre hatalı.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back(); // Dialogu kapat
                },
                child: const Text('Tamam'),
              ),
            ]),
      );
    }
  }

  String getTokenPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    return payload;
  }
}
