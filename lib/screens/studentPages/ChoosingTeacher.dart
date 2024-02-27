import 'package:edige/controllers/LoginController.dart';
import 'package:edige/controllers/StudentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChoosingTeacher extends StatelessWidget {
  const ChoosingTeacher({Key? key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());
    Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'En İyi Öğretmen Eşleşmeleri',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            const Color.fromARGB(255, 118, 129, 190), // AppBar rengi
      ),
      body: Container(
        color: const Color.fromARGB(255, 118, 129, 190),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: PaginatedDataTable(
            showCheckboxColumn: false,
            dataRowMinHeight: MediaQuery.of(context).size.height * 0.1,
            dataRowMaxHeight: MediaQuery.of(context).size.height * 0.1,
            header: const Text('Listeden Öğretmen Seçiniz'),
            rowsPerPage: 6,
            columns: const [
              DataColumn(
                  label: Text(
                'Öğretmen',
                style: TextStyle(fontSize: 20),
              )),
              DataColumn(
                  label: Text(
                'Uzmanlık',
                style: TextStyle(fontSize: 20),
              )),
            ],
            source: TeacherDataSource(), // Veri kaynağı
          ),
        ),
      ),
    );
  }
}

class TeacherDataSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    final studentController = Get.find<StudentController>();
    return DataRow(
      onSelectChanged: (value) {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  '${studentController.teachersNames[index]} ${studentController.teacherSurnames[index]}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(studentController.teacherAbouts[index]),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Öğrenci ID ve Öğretmen ID'yi al
                      int studentId = studentController.studentId.value;
                      int teacherId = int.tryParse(
                              studentController.teacherIds[index].toString()) ??
                          0;

                      try {
                        await studentController.setStudentsEnneagramResult(
                            studentId, teacherId);
                        Get.toNamed('/HomePage');
                      } catch (e) {
                        print("Hata: $e");
                      }
                    },
                    child: const Text('Danışman Seç'),
                  ),
                ],
              ),
            );
          },
        );
      },
      cells: [
        DataCell(Text(
          '${studentController.teachersNames[index]} ${studentController.teacherSurnames[index]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(
          Text(
            studentController.teachersExpertises[index],
            style: const TextStyle(
              color: Color.fromARGB(255, 82, 72, 72),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Get.find<StudentController>().teacherSurnames.length;

  @override
  int get selectedRowCount => 0;
}
