import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edige/controllers/TeacherController.dart';

class TeachersStudentsListPage extends StatelessWidget {
  const TeachersStudentsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherController = Get.find<TeacherController>();
    return Scaffold(
      appBar: TeacherHomePageAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 155, 117, 61),
              Color.fromARGB(255, 151, 113, 223),
            ],
          ),
        ),
        child: Column(
          children: [
            studentSearchTextField(),
            studentList(teacherController),
          ],
        ),
      ),
    );
  }

  AppBar TeacherHomePageAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Öğrenci Listesi',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 155, 117, 61), // AppBar rengi
    );
  }

  Expanded studentList(TeacherController teacherController) {
    return Expanded(
      child: Obx(() {
        if (teacherController.studentsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: teacherController.filteredStudentsList.length,
          itemBuilder: (context, index) {
            var student = teacherController.filteredStudentsList[index];
            return Card(
              elevation: 10, // Gölgelendirme artırıldı
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20), // Köşeler daha yuvarlak
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade300,
                      Colors.deepOrange.shade300
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade50,
                    child: Text(
                      student['user']['name'][0]
                          .toUpperCase(), // İsimden ilk harf büyük harfe dönüştürüldü
                      style: TextStyle(color: Colors.deepPurple.shade900),
                    ),
                  ),
                  title: Text(
                    '${student['user']['name']} ${student['user']['surname']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    'Email: ${student['user']['email']}\nSection: ${student['section']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print(
                          "Ayarlar ikonu tıklandı: ${student['user']['name']}");
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

Padding studentSearchTextField() {
  final teacherController = Get.find<TeacherController>();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'İsim, soyisim veya email girin',
        hintStyle: TextStyle(color: Colors.deepPurple.shade200),
        prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.deepPurple.shade500, width: 2),
        ),
        filled: true,
        fillColor: Colors.white70,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) {
        teacherController.filterStudents(value);
      },
    ),
  );
}
}
