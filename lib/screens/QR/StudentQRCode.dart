// ignore_for_file: file_names

import 'package:edige/utils/CustomDecorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:edige/controllers/QRController.dart';

class StudentQRCode extends StatelessWidget {
  StudentQRCode({super.key});

  final QRController qrController = Get.put(QRController());

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: qrCodeAppBarTheme(),
      ),
      child: Scaffold(
        appBar: qrCodeAppBar(),
        body: qrCodeBody(),
      ),
    );
  }

  Container qrCodeBody() {
    return Container(
      decoration: CustomDecorations.buildGradientBoxDecoration(
        Colors.deepPurple.shade300,
        Colors.deepOrange.shade300,
      ),
      child: buildQrCode(),
    );
  }

  AppBar qrCodeAppBar() {
    return AppBar(
      title: const Text(
        'QR Kod',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  AppBarTheme qrCodeAppBarTheme() {
    return AppBarTheme(
      centerTitle: true, // AppBar başlığını ortala
      backgroundColor: Colors.deepPurple, // AppBar rengi
      titleTextStyle: TextStyle(
        color: Colors.deepPurple.shade300,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Center buildQrCode() {
    return Center(
      child: FutureBuilder<http.Response?>(
        future: qrController.fetchQrCode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data?.bodyBytes != null) {
            return Image.memory(snapshot.data!.bodyBytes);
          } else {
            return const Text(
              "QR kodu alınamadı veya bir hata meydana geldi.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            );
          }
        },
      ),
    );
  }
}
