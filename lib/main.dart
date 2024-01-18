import 'package:edige/screens/ChoosingTeacher.dart';
import 'package:edige/screens/FirstScreen.dart';
import 'package:edige/screens/HomePage.dart';
import 'package:edige/screens/Homework/Homeworks.dart';
import 'package:edige/screens/SplashScreen.dart';
import 'package:edige/screens/TrailExam/TrialExamDetailPage.dart';
import 'package:edige/screens/TrailExam/TrialExamPage.dart';
import 'package:edige/screens/WeeklyProgram.dart';
import 'package:edige/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/Login': (context) => Login(),
        // other routes...
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/Login', page: () => Login()),
        GetPage(name: '/firstScreen', page: () => const FirstScreen()),
        GetPage(name: '/WeeklyProgram', page: () => const WeeklyProgramPage()),
        GetPage(name: '/ChoosingTeachers', page: () => const ChoosingTeacher()),
        GetPage(name: '/HomePage', page: () => const HomePage()),
        GetPage(name: '/TrialExamPage', page: () => const TrialExamPage()),
                GetPage(name: '/Homework', page: () => const Homeworks()),
        GetPage(
            name: '/TrialExamDetailPage', page: () => TrailExamDetailPage()),
      ],
    );
  }
}
