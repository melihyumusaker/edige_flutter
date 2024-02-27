import 'package:edige/controllers/CourseController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeworkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const  HomeworkButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(
              255, 198, 231, 245), // Adjust the button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          fixedSize: Size(
            MediaQuery.of(context).size.width / 6,
            MediaQuery.of(context).size.width / 6,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.black54, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget HomeworkCard(Map<String, dynamic> course) {
  DateTime deadline = DateTime.parse(course['homework_deadline']);

  return InkWell(
    onTap: () {
      Get.find<CourseController>().selectedCourseDetail.value = course;
      Get.toNamed('/HomeworkDetailPage');
    },
    child: Card(
      color:const Color.fromARGB(255, 151, 217, 248),
      elevation: 16,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${course['course_name']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${course['subcourse_name']}',
                  style:const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 247, 240, 240),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                // Tarih ve saat bilgisini düzenle
                Text(
                  'Bitiş Tarihi: ${DateFormat('dd.MM.yyyy HH:mm').format(deadline)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 247, 230, 230),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: course['is_homework_done'] == 1
                      ? Colors.green
                      : Colors.red,
                ),
                child: Icon(
                  course['is_homework_done'] == 1 ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
