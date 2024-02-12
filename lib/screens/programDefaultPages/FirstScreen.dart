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
              edigeLogo(),
              const SizedBox(height: 20),
              ogrenciLogin(),
              const SizedBox(height: 10),
              ogretmenLogin(),
              const SizedBox(height: 10),
              veliLogin(),
            ],
          ),
        ),
      ),
    );
  }

  FirstScreenRouteButtons veliLogin() {
    return const FirstScreenRouteButtons(
              width: 200,
              height: 50,
              buttonName: 'Veli Girişi',
              destinationPage: '/parent',
            );
  }

  FirstScreenRouteButtons ogretmenLogin() {
    return const FirstScreenRouteButtons(
              width: 200,
              height: 50,
              buttonName: 'Öğretmen Girişi',
              destinationPage: '/TeacherLogin',
            );
  }

  FirstScreenRouteButtons ogrenciLogin() {
    return const FirstScreenRouteButtons(
              width: 200,
              height: 50,
              buttonName: 'Öğrenci Girişi',
              destinationPage: '/Login',
            );
  }

  Container edigeLogo() {
    return Container(
              width: 200,
              height: 200,
              margin:const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            );
  }
}
