// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:edige/config/api_config.dart';
import 'package:edige/controllers/LoginController.dart';

class QRController extends GetxController {
  var isLoading = false.obs;
  var realResponse = "".obs;

  Future<http.Response?> fetchQrCode() async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.generateQRCode}?data=yourData'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({
          'data': Get.find<LoginController>().user_id.value.toString(),
          'width': 300,
          'height': 300,
        }),
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("QR kodu alınırken hata oluştu: $e");
      return null;
    }
  }

  Future<http.Response?> saveStudentRecords(int userId) async {
    isLoading(true); 
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.saveStudentRecords}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<LoginController>().token}',
        },
        body: jsonEncode({'user_id': userId}),
      );
      if (response.statusCode == 200) {
         realResponse.value = "Giriş Başarili";
        return response;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        realResponse.value = "Giriş Başarısız";
        return null;
      }
    } catch (e) {
      realResponse.value = "QR kodu alınırken hata oluştu: $e";
      debugPrint("QR kodu alınırken hata oluştu: $e");
      return null;
    } finally {
      isLoading(false); 
    }
  }
}
