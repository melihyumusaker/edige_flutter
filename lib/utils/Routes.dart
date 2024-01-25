import 'package:edige/screens/ChoosingTeacher.dart';
import 'package:edige/screens/FirstScreen.dart';
import 'package:edige/screens/HomePage.dart';
import 'package:edige/screens/Homework/HomeworkDetailPage.dart';
import 'package:edige/screens/Homework/Homeworks.dart';
import 'package:edige/screens/TrailExam/TrialExamDetailPage.dart';
import 'package:edige/screens/TrailExam/TrialExamPage.dart';
import 'package:edige/screens/WeeklyProgram.dart';

import 'package:edige/screens/login.dart';
import 'package:get/get.dart';

List<GetPage<dynamic>> get routes {
  return [
    GetPage(name: '/Login', page: () => Login()),
    GetPage(name: '/firstScreen', page: () => const FirstScreen()),
    GetPage(name: '/WeeklyProgram', page: () => const WeeklyProgramPage()),
    GetPage(name: '/ChoosingTeachers', page: () => const ChoosingTeacher()),
    GetPage(name: '/HomePage', page: () => const HomePage()),
    GetPage(
        name: '/HomeworkDetailPage', page: () => const HomeworkDetailPage()),
    GetPage(name: '/TrialExamPage', page: () => const TrialExamPage()),
    GetPage(name: '/Homework', page: () => const Homeworks()),
    GetPage(name: '/TrialExamDetailPage', page: () => TrailExamDetailPage()),
  ];
}
