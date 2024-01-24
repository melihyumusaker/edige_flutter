import 'package:edige/controllers/CourseController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum HomeworkStatus { completed, notCompleted }

extension HomeworkStatusExtension on HomeworkStatus {
  int get value {
    switch (this) {
      case HomeworkStatus.completed:
        return 1;
      case HomeworkStatus.notCompleted:
        return 0;
      default:
        return 0;
    }
  }
}

class HomeworkDetailPage extends StatefulWidget {
  const HomeworkDetailPage({Key? key}) : super(key: key);

  @override
  State<HomeworkDetailPage> createState() => _HomeworkDetailPageState();
}

class _HomeworkDetailPageState extends State<HomeworkDetailPage> {
  HomeworkStatus? _homeworkStatus = HomeworkStatus.completed;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(CourseController());
    final selectedCourseDetail =
        Get.find<CourseController>().selectedCourseDetail;

    return Scaffold(
      backgroundColor: Color(0xFF81D4FA),
      appBar: HomeworkDetailAppBar(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF81D4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              courseNameText(selectedCourseDetail),
              const SizedBox(height: 8),
              subcourseNameText(selectedCourseDetail),
              const SizedBox(height: 16),
              deadlineText(),
              serverDeadlineText(selectedCourseDetail),
              const SizedBox(height: 16),
              descriptionText(),
              serverHomeworkDescriptionText(
                  selectedCourseDetail: selectedCourseDetail),
              const SizedBox(height: 16),
              isHomeworkDoneText(),
              isHomeworkDoneRadioButtons(),
              const SizedBox(height: 16),
              studentsCommentText(),
              const SizedBox(height: 16),
              studentsCommentTextField(),
              const SizedBox(height: 16),
              sendServerButton(selectedCourseDetail),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton sendServerButton(
      RxMap<dynamic, dynamic> selectedCourseDetail) {
    return ElevatedButton(
      onPressed: () async {
        int courseId = selectedCourseDetail['course_id'];
        int isHomeworkDone = _homeworkStatus?.value ?? 0;
        String studentComment = _commentController.text;

        Get.find<CourseController>()
            .studentFinishHomework(courseId, isHomeworkDone, studentComment);

        await Get.find<CourseController>().getAllStudentsCourses();
        await Get.find<CourseController>().getStudentsDoneCourse();
        await Get.find<CourseController>().getStudentsNotDoneCourses();
      },
      child: const Text(
        'Gönder',
        style: TextStyle(color: Color.fromARGB(255, 53, 159, 247)),
      ),
    );
  }

  TextField studentsCommentTextField() {
    return TextField(
      controller: _commentController,
      maxLines: 5,
      style: const TextStyle(
          fontSize: 16, color: Colors.black87), // Yazı tipi ve rengi
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: 'Yorumunuzu buraya yazın...',
        hintStyle: const TextStyle(color: Colors.grey), // İpucu metni stili
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Kenarlık yuvarlaklığı
          borderSide: BorderSide.none, // Kenarlık çizgisi yok
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // İç padding
      ),
    );
  }

  Text studentsCommentText() {
    return const Text(
      'Öğrenci Yorumu:',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Row isHomeworkDoneRadioButtons() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            dense: true, // Daha az yükseklik için
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
            ), // İç padding'i azalt
            title:
                const Text('Tamamlandı', style: TextStyle(color: Colors.white)),
            leading: Radio<HomeworkStatus>(
              activeColor: Colors.white,
              value: HomeworkStatus.completed,
              groupValue: _homeworkStatus,
              onChanged: (HomeworkStatus? value) {
                setState(() {
                  _homeworkStatus = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            dense: true, // Daha az yükseklik için
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
            ), // İç padding'i azalt
            title: const Text(
              'Tamamlanamadı',
              style: TextStyle(color: Colors.white),
            ),
            leading: Radio<HomeworkStatus>(
              activeColor: Colors.white,
              value: HomeworkStatus.notCompleted,
              groupValue: _homeworkStatus,
              onChanged: (HomeworkStatus? value) {
                setState(() {
                  _homeworkStatus = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Text isHomeworkDoneText() {
    return const Text(
      'Ödev Durum',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Text descriptionText() {
    return const Text(
      'Açıklama:',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Text serverDeadlineText(RxMap<dynamic, dynamic> selectedCourseDetail) {
    return Text(
      selectedCourseDetail['homework_deadline'] != null
          ? DateFormat('dd.MM.yyyy HH:mm')
              .format(DateTime.parse(selectedCourseDetail['homework_deadline']))
          : 'No deadline',
      style: const TextStyle(fontSize: 16, color: Colors.white),
    );
  }

  Text deadlineText() {
    return const Text(
      'Bitiş Tarihi:',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Text subcourseNameText(RxMap<dynamic, dynamic> selectedCourseDetail) {
    return Text(
      selectedCourseDetail['subcourse_name'] ?? 'Subcourse Name',
      style: const TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    );
  }

  Text courseNameText(RxMap<dynamic, dynamic> selectedCourseDetail) {
    return Text(
      selectedCourseDetail['course_name'] ?? 'Course Name',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  AppBar HomeworkDetailAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Ödev Detay',
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF64B5F6),
    );
  }
}

class serverHomeworkDescriptionText extends StatelessWidget {
  const serverHomeworkDescriptionText({
    super.key,
    required this.selectedCourseDetail,
  });

  final RxMap selectedCourseDetail;

  @override
  Widget build(BuildContext context) {
    return Text(
      selectedCourseDetail['homework_description'] ?? 'No description',
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
    );
  }
}
