import 'package:edige/widgets/FirstScreenRouteButtons.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                margin:const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const FirstScreenRouteButtons(
                width: 200,
                height: 50,
                buttonName: 'Öğrenci Girişi',
                destinationPage: '/Login',
              ),
              const SizedBox(height: 10),
              const FirstScreenRouteButtons(
                width: 200,
                height: 50,
                buttonName: 'Öğretmen Girişi',
                destinationPage: '/teacher',
              ),
              const SizedBox(height: 10),
              const FirstScreenRouteButtons(
                width: 200,
                height: 50,
                buttonName: 'Veli Girişi',
                destinationPage: '/parent',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
