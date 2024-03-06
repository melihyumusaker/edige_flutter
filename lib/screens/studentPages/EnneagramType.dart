// ignore_for_file: file_names, avoid_print

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnneagramType extends StatefulWidget {
 const EnneagramType({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnneagramTypeState createState() => _EnneagramTypeState();
}

class _EnneagramTypeState extends State<EnneagramType> {
  int selectedTypeIndex = -1; // Seçilen tipin indeksi, -1: hiçbiri seçilmedi

  // Enneagram tipleri ve ikonlarını içeren liste
  final List<Map<String, dynamic>> enneagramList = [
    {'tip': 'Tip 1 - Mükemmeliyetçi', 'ikon': Icons.done},
    {'tip': 'Tip 2 - Yardımsever', 'ikon': Icons.favorite},
    {'tip': 'Tip 3 - Başarı Odaklı', 'ikon': Icons.star},
    {'tip': 'Tip 4 - Sanatçı', 'ikon': Icons.palette},
    {'tip': 'Tip 5 - Gözlemci', 'ikon': Icons.search},
    {'tip': 'Tip 6 - Güvenliği Arayan', 'ikon': Icons.security},
    {'tip': 'Tip 7 - Maceraperest', 'ikon': Icons.explore},
    {'tip': 'Tip 8 - Lider', 'ikon': Icons.leaderboard},
    {'tip': 'Tip 9 - Uyumlu', 'ikon': Icons.balance},
  ];
  bool isDialogShown = false;
  Future<void> _initState() async {
    final userIdValue = int.tryParse(Get.find<LoginController>().user_id.value);

    if (userIdValue != null && userIdValue != 0) {
      await Get.find<StudentController>().getStudentIdByUserId(userIdValue);
      await Get.find<StudentController>().getStudentInfosByStudentId(
          Get.find<StudentController>().studentId.value);

      if (Get.find<StudentController>().isEnneagramTestSolved.value == 0 &&
          !isDialogShown) {
        // Show dialog box with informative message
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context),
            );
          },
        );

        isDialogShown = true;
      }  else if (Get.find<StudentController>().isEnneagramTestSolved.value == 1){
        Get.toNamed('/HomePage');
      }
    } else {
      // If user ID is not available, redirect to the login screen
      debugPrint('Hata: User ID boş veya geçersiz.');
      Get.offAllNamed('/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());
    Get.put(LoginController());

    // Call the _initState() function in the build() method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });

    return Scaffold(
      backgroundColor: Colors.grey[200], // Arka plan rengi
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerText(),
          enneagramTypes(),
          enneagramTypeSendButton(),
        ],
      ),
    );
  }

  Container headerText() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      color: Colors.lightGreen, // Başlık arkaplan rengi
      child: const Center(
        child: Text(
          'Enneagram Tipinizi Seçiniz',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Başlık yazı rengi
          ),
        ),
      ),
    );
  }

  Expanded enneagramTypes() {
    return Expanded(
      child: ListView.builder(
        itemCount: enneagramList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2, // Gölgelendirme
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightGreen, // Ikon çerçeve rengi
                child: Icon(
                  enneagramList[index]['ikon'],
                  color: Colors.white, // Ikon rengi
                ),
              ),
              title: Text(
                enneagramList[index]['tip'],
                style: const TextStyle(fontSize: 16.0),
              ),
              trailing: Container(
                width: 40.0, // Yuvarlağın genişliği
                height: 40.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen, // Yuvarlağın rengi
                ),
                child: Center(
                  child: Radio<int>(
                    activeColor: Colors.white,
                    value: index,
                    groupValue: selectedTypeIndex,
                    onChanged: (int? value) {
                      setState(() {
                        selectedTypeIndex = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container enneagramTypeSendButton() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (selectedTypeIndex != -1) {
              await Get.find<StudentController>().getTeachersByStudentType(
                  enneagramList[selectedTypeIndex]['tip'].split('-')[0].trim());

              var expertises = Get.find<StudentController>().teachersExpertises;

              if (expertises.isNotEmpty) {
                String expertise = expertises[0];
                print('Seçilen tip: $expertise');
              } else {
                // Handle the case when the list is empty
                print('Önerilen öğretmen bulunamadı.');
              }
            } else {
              print('Lütfen bir tip seçin.');
            }

            Get.toNamed('ChoosingTeachers');
            debugPrint(Get.find<LoginController>().user_id.value);
          },
          child: const Text(
            'Devam Et',
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}

Widget contentBox(context) {
  return Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Bilgilendirme',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Edigeye Hoş Geldiniz\n\nÖncelikle koç eşleşmenizi yapabilmek için daha önce çözmüş olduğunuz Enneagram Testinde çıkan sonucu işaretleyiniz.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Tamam',
                  style: TextStyle(fontSize: 18.0, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
