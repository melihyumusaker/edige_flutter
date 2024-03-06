// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:edige/screens/programDefaultPages/FirstScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Use Get.to instead of Get.off to correctly apply the transition
      Get.off(() =>const FirstScreen(), transition: Transition.cupertinoDialog);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset('assets/images/edige-logo.png'),
          ),
        ),
      ),
    );
  }
}
