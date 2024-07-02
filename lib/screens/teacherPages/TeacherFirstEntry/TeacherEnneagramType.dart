// ignore_for_file: avoid_print, file_names

import 'package:edige/screens/teacherPages/TeacherFirstEntry/TeacherAboutPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherEnneagramType extends StatefulWidget {
  const TeacherEnneagramType({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EnneagramTypeState createState() => _EnneagramTypeState();
}

class _EnneagramTypeState extends State<TeacherEnneagramType> {
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
    if (!isDialogShown) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
              String selectedType =
                  enneagramList[selectedTypeIndex]['tip']; 
              String typeNumber = selectedType
                  .split(' - ')[0]; 
              Get.to(() => TeacherAboutPage(enneagramType: typeNumber),
                  transition: Transition
                      .rightToLeft); 
            } else {
              print('Lütfen bir tip seçin.');
            }
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
