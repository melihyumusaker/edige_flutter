// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:edige/widgets/FirstScreenRouteButtons.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını al
    Size screenSize = MediaQuery.of(context).size;
    double buttonWidth = screenSize.width * 0.5; // Ekran genişliğinin %50'si
    double logoSize = screenSize.width * 0.5; // Ekran genişliğinin %50'si

    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: screenSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 127, 170, 194),
                Color.fromARGB(255, 29, 83, 114),
                Color.fromARGB(255, 9, 54, 80),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenSize.height * 0.2),
                edigeLogo(logoSize),
                SizedBox(height: screenSize.height * 0.02),
                ogrenciLogin(buttonWidth),
                SizedBox(height: screenSize.height * 0.01),
                ogretmenLogin(buttonWidth),
                SizedBox(height: screenSize.height * 0.01),
                veliLogin(buttonWidth),
                SizedBox(height: screenSize.height * 0.01),
                adminLogin(buttonWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FirstScreenRouteButtons adminLogin(double width) {
    return FirstScreenRouteButtons(
      width: width,
      height: 50,
      buttonName: 'Kurum Girişi',
      destinationPage: '/QRScanPage',
    );
  }

  FirstScreenRouteButtons veliLogin(double width) {
    return FirstScreenRouteButtons(
      width: width,
      height: 50,
      buttonName: 'Veli Girişi',
      destinationPage: '/parent',
    );
  }

  FirstScreenRouteButtons ogretmenLogin(double width) {
    return FirstScreenRouteButtons(
      width: width,
      height: 50,
      buttonName: 'Öğretmen Girişi',
      destinationPage: '/TeacherLogin',
    );
  }

  FirstScreenRouteButtons ogrenciLogin(double width) {
    return FirstScreenRouteButtons(
      width: width,
      height: 50,
      buttonName: 'Öğrenci Girişi',
      destinationPage: '/Login',
    );
  }

  Container edigeLogo(double size) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(bottom: 20),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
