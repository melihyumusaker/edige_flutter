// ignore_for_file: non_constant_identifier_names

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final loginController = Get.put(LoginController());
  final studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5288DD), Color.fromARGB(255, 56, 211, 190)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EdigeLogo(),
                        const SizedBox(height: 50),
                        WelcomeEdigeText(),
                        const SizedBox(height: 20),
                        EmailAndPasswordForm(),
                        rememberMeCheckbox(context),
                        LoginButton(context),
                      ],
                    ),
                  ),
                ),
              ),
              backToPageIconButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget rememberMeCheckbox(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Beni Hatırla',
              style: TextStyle(color: Colors.white),
            ),
            Checkbox(
              value: Get.find<LoginController>().rememberMe.value,
              onChanged: (bool? value) {
                if (value != null) {
                  Get.find<LoginController>().toggleRememberMe(value);
                }
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
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
          onPressed: loginController.login,
          child: const Text('Giriş Yap', style: TextStyle(color: Colors.black)),
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
              controller: loginController.emailController,
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
              controller: loginController.passwordController,
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

  Text WelcomeEdigeText() {
    return const Text(
      "Edige'ye Hoşgeldiniz",
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
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
}
