// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:edige/widgets/FirstScreenRouteButtons.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını al
    Size screenSize = MediaQuery.of(context).size;
    double buttonWidth = screenSize.width * 0.5; 
    double logoSize = screenSize.width * 0.5; 

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
                SizedBox(height: screenSize.height * 0.05),
                ogrenciLogin(buttonWidth),
                SizedBox(height: screenSize.height * 0.01),
                ogretmenLogin(buttonWidth),
                SizedBox(height: screenSize.height * 0.01)
              ],
            ),
          ),
        ),
      ),
    );
  }

  FirstScreenRouteButtons ogretmenLogin(double width) {
    return const FirstScreenRouteButtons(
      buttonName: 'Öğretmen Girişi',
      destinationPage: '/TeacherLogin',
    );
  }

  FirstScreenRouteButtons ogrenciLogin(double width) {
    return const FirstScreenRouteButtons(
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
