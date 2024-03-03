// ignore_for_file: file_names

import 'package:edige/screens/studentPages/ChoosingTeacher.dart';
import 'package:edige/screens/programDefaultPages/FirstScreen.dart';
import 'package:edige/screens/studentPages/HomePage.dart';
import 'package:edige/screens/studentPages/Homework/HomeworkDetailPage.dart';
import 'package:edige/screens/studentPages/Homework/Homeworks.dart';
import 'package:edige/screens/studentPages/TrailExam/TrialExamDetailPage.dart';
import 'package:edige/screens/studentPages/TrailExam/TrialExamPage.dart';
import 'package:edige/screens/studentPages/WeeklyProgram.dart';
import 'package:edige/screens/studentPages/login.dart';
import 'package:edige/screens/teacherPages/TeacherFirstEntry/TeacherEnneagramType.dart';
import 'package:edige/screens/teacherPages/TeacherHomePage.dart';
import 'package:edige/screens/teacherPages/TeacherLogin.dart';
import 'package:edige/screens/teacherPages/TeachersStudents/TeachersStudentsListPage.dart';
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
    GetPage(
        name: '/TrialExamDetailPage', page: () => const TrailExamDetailPage()),
    GetPage(name: '/TeacherLogin', page: () => TeacherLogin()),
    GetPage(name: '/TeacherHomePage', page: () =>  const TeacherHomePage()),
    GetPage(
        name: '/TeachersStudentsListPage',
        page: () => const TeachersStudentsListPage()),
    GetPage(
        name: '/TeacherEnneagramType',
        page: () => const TeacherEnneagramType()),
            GetPage(
        name: '/StudentTrialExamPage',
        page: () => const TeachersStudentsListPage()),
  ];
}
