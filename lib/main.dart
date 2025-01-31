import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LessonController.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/NotifStudentController.dart';
import 'package:edige/controllers/QRController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TeacherController.dart';
import 'package:edige/controllers/TrialExamController.dart';
import 'package:edige/controllers/WeeklyProgramController.dart';
import 'package:edige/screens/programDefaultPages/SplashScreen.dart';
import 'package:edige/screens/studentPages/login.dart';
import 'package:edige/utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  Get.put(TeacherController(), permanent: true);
  Get.put(TrialExamController(), permanent: true);
  Get.put(StudentController(), permanent: true);
  Get.put(CourseController(), permanent: true);
  Get.put(WeeklyProgramController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(QRController(), permanent: true);
  Get.put(LessonController(), permanent: true);
  Get.put(MeetingController(), permanent: true);
  Get.put(NotifStudentController(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/Login': (context) => Login(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Nunito",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      getPages: routes,
    );
  }
}
