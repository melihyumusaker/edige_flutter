// ignore_for_file: non_constant_identifier_names, file_names

import 'package:edige/controllers/TeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherLogin extends StatelessWidget {
  TeacherLogin({super.key});

  final teacherLoginController = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 219, 121, 121),
                Color.fromARGB(255, 97, 140, 206)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EdigeLogo(),
                    const SizedBox(height: 50),
                    WelcomeEdigeText(),
                    const SizedBox(height: 20),
                    EmailAndPasswordForm(),
                    LoginButton(context),
                  ],
                ),
              ),
              backToPageIconButton(context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox EdigeLogo() {
    return SizedBox(
      width: 200,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Padding WelcomeEdigeText() {
    return const Padding(
      padding:  EdgeInsets.only(right: 10.0, left: 10.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Sayın Öğretmenimiz Edige'ye Hoşgeldiniz",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Form EmailAndPasswordForm() {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: teacherLoginController.teacherEmailController,
              decoration: InputDecoration(
                filled: true, // Remove default border
                fillColor: Colors.white
                    .withOpacity(0.8), // Semi-transparent white background
                hintText: "E-posta",

                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Add rounded corners
                  borderSide: const BorderSide(
                      color: Colors.white, width: 2), // Thicker white border
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: teacherLoginController.teacherPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true, // Remove default border
                fillColor: Colors.white
                    .withOpacity(0.8), // Semi-transparent white background
                hintText: "Şifre",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Add rounded corners
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ), // Thicker white border
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned backToPageIconButton(BuildContext context) {
    return Positioned(
      top: 20,
      left: 15,
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.1),
        radius: 25,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white70,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  SizedBox LoginButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.32,
      height: 40,
      child: Center(
        child: ElevatedButton(
          onPressed: teacherLoginController.teacherLogin,
          child: const Text(
            'Giriş Yap',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
