// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names, avoid_print

import 'package:edige/controllers/CourseController.dart';
import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/MeetingController.dart';
import 'package:edige/controllers/MessageControllers/StudentMessageController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:edige/controllers/TrialExamController.dart';
import 'package:edige/screens/studentPages/Meetings/StudentMeetingsPage.dart';
import 'package:edige/screens/studentPages/Messages/StudentMessagesBox.dart';
import 'package:edige/screens/QR/StudentQRCode.dart';
import 'package:edige/utils/CustomDecorations.dart';
import 'package:edige/widgets/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());
    Get.put(CourseController());

    final isLoading = RxBool(true);

    Future<void> _initState() async {
      final userIdValue =
          int.tryParse(Get.find<LoginController>().user_id.value);

      if (userIdValue != null) {
        await Get.find<StudentController>()
            .getStudentIdByUserId(userIdValue); // student ID set ediliyor
        await Get.find<StudentController>().getStudentInfosByStudentId(
            Get.find<StudentController>().studentId.value);

        if (Get.find<StudentController>().surname.value.isNotEmpty) {
          isLoading.value = false;
        }
      } else {
        debugPrint('Hata: User ID dönüştürülemedi.');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });

    final birthDate = Get.find<StudentController>().birthDate.value;
    final formattedDate = DateFormat('yyyy-MM-dd').format(birthDate);

    return Scaffold(
      appBar: homePageAppBar(),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: CustomDecorations.buildGradientBoxDecoration(
              const Color.fromARGB(255, 135, 230, 253),
              const Color.fromARGB(255, 131, 124, 192)),
          child: FutureBuilder(
              future: Future.delayed(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      topEmptySizedBox(context),
                      UserInfo(formattedDate: formattedDate),
                      const WeeklyProgramAndTrialExamButtons(),
                      homeworksAndMessages(context),
                      qrAndMeetings(context),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }

  Row qrAndMeetings(BuildContext context) {
    double sizeFactor = MediaQuery.of(context).size.width / 360;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Get.to(() => StudentQRCode(), transition: Transition.rightToLeft);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 40,
            height: MediaQuery.of(context).size.height / 5,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: const Color.fromARGB(255, 172, 223, 191),
              child: const Center(
                child: Text(
                  'QR',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.find<MeetingController>().getStudentAndTeacherSpecialMeetings(
                Get.find<StudentController>().studentId.value,
                Get.find<StudentController>().studentTeacherId.value,
                Get.find<LoginController>().token.value);
            Get.to(() => const StudentMeetingsPage(),
                transition: Transition.rightToLeft);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 40,
            height: MediaQuery.of(context).size.height / 5,
            child: Stack(children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: const Color.fromARGB(255, 172, 223, 191),
                child: const Center(
                  child: Text(
                    'Toplantılar',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 4 * sizeFactor,
                right: 4 * sizeFactor,
                child: Container(
                  width: 24 * sizeFactor,
                  height: 24 * sizeFactor,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8 * sizeFactor),
                  ),
                  child: Center(
                    child: Obx(() => Text(
                          Get.find<MeetingController>()
                              .unShownMeetingNumber
                              .value
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12 * sizeFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Row homeworksAndMessages(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        homeworks(context),
        InkWell(
          onTap: () async {
            Get.to(() => const StudentMessagesBox(),
                transition: Transition.rightToLeft,
                binding: BindingsBuilder(() {
              Get.put(StudentMessageController());
            }));
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 40,
            height: MediaQuery.of(context).size.height / 5,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: const Color.fromARGB(255, 172, 223, 191),
              child: const Center(
                child: Text(
                  'Mesajlar',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar homePageAppBar() {
    return AppBar(
      title: const Text(
        "Edige Öğrenci Sayfası",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 135, 230, 253),
    );
  }

  InkWell homeworks(BuildContext context) {
    double sizeFactor = MediaQuery.of(context).size.width / 360;

    return InkWell(
      onTap: () async {
        Get.toNamed("/Homework");
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 40,
        height: MediaQuery.of(context).size.height / 5,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0 * sizeFactor),
              ),
              color: const Color.fromARGB(255, 172, 223, 191),
              child: const Center(
                child: Text(
                  'Ödevler',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: 4 * sizeFactor,
              right: 4 * sizeFactor,
              child: Container(
                width: 24 * sizeFactor,
                height: 24 * sizeFactor,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8 * sizeFactor),
                ),
                child: Center(
                  child: Obx(() => Text(
                        Get.find<CourseController>()
                            .unShownCourseNumber
                            .value
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12 * sizeFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox topEmptySizedBox(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.005);
  }
}

class WeeklyProgramAndTrialExamButtons extends StatelessWidget {
  const WeeklyProgramAndTrialExamButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double sizeFactor = MediaQuery.of(context).size.width / 360;
    Get.put(TrialExamController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Get.toNamed("/WeeklyProgram");
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 40,
            height: MediaQuery.of(context).size.height / 5,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: const Color.fromARGB(255, 172, 223, 191),
              child: const Center(
                child: Text(
                  'Ders Programı',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            await Get.find<TrialExamController>().getStudentTrialExams();
            Get.toNamed("/TrialExamPage");
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 40,
            height: MediaQuery.of(context).size.height / 5,
            child: Stack(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: const Color.fromARGB(255, 172, 223, 191),
                  child: const Center(
                    child: Text(
                      'Deneme Sınavı Sonuçları', // Burada sınav sonuçlarını gösterebilirsin
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 4 * sizeFactor,
                  right: 4 * sizeFactor,
                  child: Container(
                    width: 24 * sizeFactor,
                    height: 24 * sizeFactor,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8 * sizeFactor),
                    ),
                    child: Center(
                      child: Obx(() => Text(
                            Get.find<TrialExamController>()
                                .unShownTrialExamNumber
                                .value
                                .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * sizeFactor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.formattedDate,
  });

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height / 3,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: const Color.fromARGB(255, 172, 223, 191),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${Get.find<StudentController>().name.value} ${Get.find<StudentController>().surname.value}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Okul : ${Get.find<StudentController>().school.value}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Bölüm : ${Get.find<StudentController>().section.value}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Doğum Yeri : ${Get.find<StudentController>().city.value}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Doğum Tarihi: $formattedDate',
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Email : ${Get.find<StudentController>().email.value}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
